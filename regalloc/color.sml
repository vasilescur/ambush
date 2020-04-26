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
  structure W = Worklist (F)

  type register = F.register
  type allocation = register Temp.Map.map

  structure RegisterKey =
  struct
    type ord_key = register
    val compare = String.compare
  end

  structure RSet = ListSetFn (RegisterKey)

  (* val registerTemps = (List.foldl (fn ((k, v), list) => k::list) [] (Temp.Map.listItemsi F.tempMap)) *)
  (* val registerNames = (List.foldl (fn ((k, v), list) => v::list) [] (Temp.Map.listItemsi F.tempMap)) *)

  fun color ({interference : Liveness.igraph, initial : allocation, spillCost : Liveness.node -> int, registers : F.register list}) =
        let val Liveness.IGRAPH {graph, tnode, gtemp, moves} = interference
            val (worklist, moveNodes) = setupWorklist (interference, initial)
            val simplified = simplify (worklist, graph, gtemp)
            val selectedWorklist = select (simplified, graph, gtemp, tnode, registers)
            val colored : allocation = W.colored (selectedWorklist)
        in  (colored, moveNodes)
        end

  and setupWorklist (Liveness.IGRAPH {graph : Temp.temp Flow.G.graph, tnode : Temp.temp -> Liveness.node, 
                      gtemp : Liveness.node -> Temp.temp, moves : (Liveness.node * Liveness.node) list}, initialAlloc) = 
        let val temps = (Flow.G.foldNodes (fn (node, li) => Flow.G.nodeInfo (node)::li) [] graph)
            val initWorklist = W.create (temps, initialAlloc)
            val moveSet = foldl (fn ((move1, move2), set) =>
                                      Temp.Set.add (Temp.Set.add (set, gtemp move1), gtemp move2))
                          Temp.Set.empty moves
            fun addToWorklist (temp, (worklist, moves)) =
                  let (* val _ = print "Retrieving temp from node...\n" *)
                      val node = tnode temp
                      (* val _ = print "Determining temp type...\n" *)
                      val tempType = if (Liveness.LiveG.inDegree (node) > List.length F.registers)
                                     then W.HIGH
                                     else if Temp.Set.member (moveSet, temp)
                                          then W.MOVE
                                          else W.LOW
                      (* val _ = print "Adding to worklist...\n" *)
                  in  if (tempType = W.MOVE) then ((*print "Move type found!\n";*) (W.add (worklist, tempType, temp), temp::moves))
                                             else ((*print "Non-move type found!\n";*) (W.add (worklist, tempType, temp), moves))
                  handle NotFound => raise NotFound
                  end
        in  Temp.Set.foldl addToWorklist (initWorklist, []) (W.init (initWorklist))
        handle NotFound => raise NotFound
        end

  and simplify (worklist, graph, gtemp) = Temp.Set.foldl W.stack worklist (W.simplify (worklist))

  and select (worklist, graph, gtemp, tnode, registers) =
        let val colorSet = RSet.addList (RSet.empty, registers)
            fun selectColor (temp, worklist) = 
              let val node = tnode (temp)
                  fun removeColors (node, colors) = 
                        let val temp = gtemp node
                            val colored = W.colored (worklist)
                            val color = Temp.Map.find (colored, temp)
                        in  case color of
                                NONE => colors
                              | SOME (color) => if   RSet.member (colors, color)
                                                then RSet.delete (colors, color)
                                                else colors
                        end
                        handle e => raise e
                  val availableColors = (Liveness.LiveG.foldSuccs' graph) removeColors colorSet node
                  val tempColor = if   RSet.numItems (availableColors) <= 0
                                  then raise W.SpillException
                                  else List.hd (RSet.listItems (availableColors))
              in  W.color (worklist, temp, tempColor)
              end
        in Temp.Set.foldl selectColor worklist (W.select (worklist))
        end

end