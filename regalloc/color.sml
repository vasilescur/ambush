signature COLOR =
sig
  type register
  type allocation = register Temp.Map.map
  val color: {interference: Liveness.igraph,
              initial: allocation,
              spillCost: Liveness.node -> int,
              registers: register list} -> allocation * Temp.temp list
end

functor Color (F : FRAME) : COLOR =
struct
  type register = F.register
  type allocation = register Temp.Map.map
  fun color ({interference, initial, spillCost, registers}) = (initial, [])
end