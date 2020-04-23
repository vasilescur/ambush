signature REG_ALLOC =
sig
  type register
  type frame
  type allocation = register Temp.Map.map
  val alloc : Assem.instr list * frame -> Assem.instr list * allocation
end

functor RegAlloc (F: FRAME) : REG_ALLOC =
struct
  structure C = Color (F)

  type register = F.register
  type frame = F.frame
  type allocation = register Temp.Map.map

  fun alloc (instrs, frame) = 
    let val (flow, nodelist) = MakeGraph.instrs2graph (instrs)
        val interference = Liveness.interferenceGraph (flow)
        val (allocation, spills) = C.color ({interference=interference,
                                             initial=F.tempMap,
                                             spillCost=(fn (_) => 1),
                                             registers=F.registers})
    in (instrs, allocation)
    end
end