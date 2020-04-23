structure T = Temp
structure G = Liveness.G

signature COLOR =
sig
  type register
  type allocation = register T.Map.map
  val color: {interference: Liveness.igraph,
              initial: allocation,
              spillCost: Liveness.node -> int,
              registers: register list} -> allocation * T.temp list
end

functor Color (F : FRAME) : COLOR =
struct
  type register = F.register
  type allocation = register Temp.Map.map
  fun color ({interference, initial, spillCost, registers}) = (initial, [])

  fun setupWorklist (initial, {graph, tnode, gtemp, moves}) = 
        let val empty = Worklist.empty
            fun addToWorklist (node, worklist) = worklist
        in G.foldNodes addToWorklist empty graph
        end

  fun simplify (graph, worklist, gtemp) =
        let fun popNode (node, worklist) = 
                  let val temp = gtemp (node)
                  in Worklist.simplify (worklist, temp)
                  end
        in G.foldNodes popNode worklist graph
        end

  fun select () = ()


end