structure W = Worklist

signature COLOR =
sig
  type register
  type allocation
  val color: {interference: Liveness.igraph,
              initial: allocation,
              spillCost: Liveness.node -> int,
              registers: register list} -> allocation * Temp.temp list
end

functor Color (F : FRAME) : COLOR =
struct
  type register = F.register
  type allocation = register Temp.Map.map
  fun color ({interference : Liveness.igraph, initial : allocation, spillCost : Liveness.node -> int, registers : F.register list}) =
        let val worklist = setupWorklist (interference)
        in (initial, [])
        end

  and setupWorklist (Liveness.IGRAPH {graph : Temp.temp Flow.G.graph, tnode : Temp.temp -> Liveness.node, 
                      gtemp : Liveness.node -> Temp.temp, moves : (Liveness.node * Liveness.node) list}) = 
        let val registerTemps = (List.foldl (fn ((k, v), list) => k::list) [] (Temp.Map.listItemsi F.tempMap))
            val initWorklist = W.init registerTemps
            val moveSet = foldl (fn ((move1, move2), set) => 
                                      Temp.Set.add (Temp.Set.add (set, gtemp move1), gtemp move2)) 
                          Temp.Set.empty moves
            fun addToWorklist (node, (worklist, moves)) = 
                  let val temp = gtemp node
                      val tempType = if Liveness.LiveG.degree (node) > List.length F.registers
                                     then W.HIGH
                                     else if Temp.Set.member (moveSet, temp)
                                          then W.MOVE
                                          else W.LOW
                  in if (tempType = W.MOVE) then (W.add (worklist, tempType, temp), temp::moves)
                                            else (W.add (worklist, tempType, temp), moves)
                  end
        in Liveness.LiveG.foldNodes addToWorklist (initWorklist, []) graph
        end

  and simplify (graph, worklist, gtemp) =
        let fun popNode (node, worklist) = 
                  let val temp = gtemp (node)
                  in W.stack (worklist, temp)
                  end
        in Liveness.LiveG.foldNodes popNode worklist graph
        end

  and select () = ()


end