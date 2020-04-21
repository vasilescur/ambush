(* signature LIVENESS =
sig
  type igraph
  type node
  type live
  type livegraph
  val interferenceGraph : Flow.flowgraph -> igraph * (node -> Temp.temp list)
  val show : outstream * igraph -> unit
  val flowToLiveGraph : Flow.graph -> livegraph
  val showLiveGraph : livegraph -> unit

end *)

structure Liveness (*: LIVENESS*) =
struct
  structure TempSet = Temp.Set 
  structure TempMap = Temp.Map
  structure G = Flow.G
  
  exception NodeNotFound

  type temp_set = TempSet.set

  type node = Temp.temp G.node
  datatype igraph = IGRAPH of {graph: Temp.temp G.graph,
                               tnode: Temp.temp -> node,
                               gtemp: node -> Temp.temp,
                               moves: (node * node) list}

  type live = {def: Temp.set,
               use: Temp.set,
               move: (Temp.temp * Temp.temp) option,
               liveIn: Temp.set,
               liveOut: Temp.set}
  
  type livegraph = live G.graph

  (* Calculates liveness and adds that info to flow graph *)
  fun flowToLiveGraph (flow : Flow.node G.graph) : livegraph =
    let fun convertFlowToLive () = 
              (* Copy original graph (only nodes) *)
          let fun init (flowNode : Flow.node Flow.G.node, liveGraph : livegraph) = 
                let val nid = G.getNodeID (flowNode)
                    val (assm, def, use, move, jump) = G.nodeInfo (flowNode)
                    val newInfo = {def=TempSet.addList (TempSet.empty, def), 
                                        use=TempSet.addList (TempSet.empty, use), 
                                        move=move, 
                                        liveIn=Temp.Set.empty, 
                                        liveOut=Temp.Set.empty}
                in  G.addNode (liveGraph, nid, newInfo)
                end 

              (* Copy the edges *)
              fun copyEdges (oldNode, newGraph) =
                let val nid = G.getNodeID (oldNode)
                    val oldInfo = G.nodeInfo (oldNode)
                    val oldSuccs = G.succs (oldNode)
                    val newNode = G.getNode (newGraph, nid)
                in List.foldl (fn (succ, graph) => G.addEdge (graph, {from=nid, to=succ})) newGraph oldSuccs
                end 

              fun iterateLiveness (edgedGraph) =
                let fun iterGraph (nid, graph) =
                      let val node = G.getNode (graph, nid)

                          val info = G.nodeInfo node
                          val {def=def, use=use, move=move, liveIn=oldLiveIn, liveOut=oldLiveOut} = info
                          
                          val succs = G.succs (node)
                          val preds = G.preds (node)

                          val newLiveIn = TempSet.union (use, (TempSet.difference (oldLiveOut, def)))
                          val newLiveOut = foldl (fn (nid, set) => let val iterNode = G.getNode (graph, nid)
                                                                       val lIn = #liveIn (G.nodeInfo iterNode)
                                                                   in  TempSet.union (set, lIn)
                                                                   end) TempSet.empty succs
                          val unchanged : bool = ((TempSet.equal (oldLiveIn, newLiveIn)) andalso (TempSet.equal (oldLiveOut, newLiveOut)))
                          val newInfo = {def=def, use=use, move=move, liveIn=newLiveIn, liveOut=newLiveOut}
                          val newGraph = G.changeNodeData (graph, nid, newInfo)
                      in  (unchanged, newGraph)
                      end

                    fun untilUnchanged (true, graph) = graph
                      | untilUnchanged (false, graph) = 
                          untilUnchanged (G.foldNodes (fn (node, (unchanged, graph)) => 
                                                        (let val nid = G.getNodeID(node)
                                                             val (newUnchanged, newGraph) = iterGraph (nid, graph)
                                                         in  (unchanged andalso newUnchanged, newGraph)
                                                         end )) (true, graph) graph)
                in untilUnchanged (false, edgedGraph)
                end 

              val initializedGraph : livegraph = G.foldNodes init G.empty flow
              val edgedGraph : livegraph = G.foldNodes copyEdges initializedGraph flow
              val liveGraph : livegraph = iterateLiveness edgedGraph

          in liveGraph
          end
    in  convertFlowToLive ()
    end

  (* Uses a flow graph with liveness info to make an interference graph *)
    fun interferenceGraph (flow) = let val liveGraph = flowToLiveGraph flow
                                      val (graph, tempMap, moves) = liveGraphToIGraph (liveGraph)
                                      
                                      fun tnode (x) = G.getNode (graph, getNid (tempMap, x))
                                      fun gtemp (x) = G.nodeInfo (x)
                                      
                                      val uniqueMoves =
                                        let fun identical ((f1, t1), (f2, t2)) = 
                                              ((f1 = f2 andalso t1 = t2) orelse (f1 = t2 andalso f2 = t1))
                                            fun cyclical (f1, t1) = (f1 = t1)
                                            fun haveEdge (e, []) = false 
                                              | haveEdge (e, head::tail) = case identical(e, head) of
                                                                              true => true
                                                                            | false => haveEdge(e, tail)
                                            
                                        in  foldl (fn (e, es) => case (haveEdge (e, es) orelse cyclical (e)) of 
                                                                    true => es
                                                                  | false => e::es)
                                                  []
                                                  moves 
                                            
                                        end 
                                        
                                      fun mapEdge (a, b) = (tnode a, tnode b)
                                      
                                      val moves = map mapEdge moves
                                      
                                  in IGRAPH {graph=graph,
                                              tnode=tnode,
                                              gtemp=gtemp,
                                              moves=moves}
                                  end
  and getNid (tmap, node) =
    case TempMap.find (tmap, node) of 
        SOME (nid) => nid 
      | _ => raise NodeNotFound
  and liveGraphToIGraph (lgraph) =
    let val tmap = TempMap.empty
        val igraph = G.empty
        
        val counter = ref 0
        
        fun insertTemp (temp, (igraph, tmap)) = 
          case TempMap.find (tmap, temp) of 
              SOME (x) => (igraph, tmap)
            | NONE => let val nid = !counter
                          val _ = counter := nid + 1
                      in  (G.addNode (igraph, nid, temp), TempMap.insert (tmap, temp, nid))
                      end 
        
        (* Insert all the temps *)
        val (igraph, tmap) = G.foldNodes (fn (liveNode, (igraph, tmap)) =>
                                            let val {def=def, use=use,
                                                     liveIn=liveIn, liveOut=liveOut,
                                                     move=move} = G.nodeInfo liveNode
                                                val (igraph, tmap) = TempSet.foldl insertTemp (igraph, tmap) def
                                                val (igraph, tmap) = TempSet.foldl insertTemp (igraph, tmap) use 
                                            in  (igraph, tmap)
                                            end )
                                          (igraph, tmap) lgraph

        (* Insert all the edges *)
        fun insertEdges (liveNode, (igraph, moves)) =
          let val {def=def, use=use,
                   liveIn=liveIn, liveOut=liveOut,
                   move=move} = G.nodeInfo liveNode
              val moves = case move of 
                              SOME (mv) => mv::moves
                            | NONE => moves
              val igraph = case move of 
                              SOME (dst, src) => TempSet.foldl (fn (live, igraph) =>
                                                            if (live <> dst andalso live <> src) then
                                                              G.doubleEdge (igraph, getNid (tmap, dst), getNid (tmap, live))
                                                            else igraph)
                                                 igraph liveOut
                            | NONE => TempSet.foldl (fn (defVar, igraph) => (TempSet.foldl (
                                            fn (live, igraph) => 
                                              if (defVar <> live) then
                                                G.doubleEdge (igraph, getNid (tmap, defVar), getNid (tmap, live))
                                              else igraph)
                                            igraph liveOut))
                                          igraph def
              (* val igraph = TempSet.foldl (fn (live1, igraph) => (TempSet.foldl (
                                            fn (live2, igraph) => 
                                              if (live1 <> live2) then 
                                                G.doubleEdge (igraph, getNid (tmap, live1), getNid (tmap, live2))
                                              else igraph)
                                            igraph liveOut))
                                          igraph liveOut *)
          in  (igraph, moves)
          end 
        
        val (igraph, moves) = G.foldNodes insertEdges (igraph, []) lgraph 
        
    in (igraph, tmap, moves)
    end 

  fun moveToString (SOME (t1, t2)) = (Temp.makestring t1 ^ " <- " ^ Temp.makestring t2)
    | moveToString (NONE) = "N/A"

  fun showLiveGraph (liveGraph : livegraph) = 
    (print "\n--- Live Graph: --- \n";
     G.printGraph (fn (nid, liveObj:live) =>
                    let val liveIn : Temp.set = #liveIn liveObj
                        val liveOut : Temp.set = #liveOut liveObj
                        val move = #move liveObj
                    in  ("nid = " ^ (Int.toString nid) ^ " \tliveIn:  " ^ (Temp.tempSetToString liveIn) ^ 
                                                        " \tliveOut: " ^ (Temp.tempSetToString liveOut) ^ 
                                                        " \tmove:    " ^ (moveToString move))
                    end) liveGraph false)

  fun printNodeForVis (nid, temp) = (* Int.toString nid ^ ": " ^ *) Temp.makestring temp
end