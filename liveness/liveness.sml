(* signature LIVENESS =
sig
  type igraph
  type node
  type live
  type livegraph
  (* val interferenceGraph : Flow.flowgraph -> igraph * (node -> Temp.temp list)
  val show : outstream * igraph -> unit *)
  val flowToLiveGraph : Flow.graph -> livegraph
  val showLiveGraph : livegraph -> unit

end *)

structure Liveness (*: LIVENESS*) =
struct
  structure TempSet = Temp.Set 
  structure TempMap = Temp.Map
  structure G = Flow.G

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
  (* fun interferenceGraph (flow) = let val liveGraph = flowToLiveGraph flow
                                 in {graph=graph,
                                     tnode=tnode,
                                     gtemp=gtemp,
                                     moves=moves}
                                 end *)

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
    

end