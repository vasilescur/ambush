signature REG_ALLOC =
sig
  type allocation
  type register
  type frame
  val alloc : Assem.instr list * frame -> Assem.instr list * allocation
end

functor RegAlloc (F: FRAME) : REG_ALLOC =
struct
  structure C = Color (F)

  type allocation = C.allocation
  type register = F.register
  type frame = F.frame

  fun alloc (instrs, frame) = 
    let val (flow, nodelist) = MakeGraph.instrs2graph (instrs)
        val interference = Liveness.interferenceGraph (flow)
        (* val _ = print "Printing interference graph..."
        val _ = Liveness.print (interference) *)
        val (allocation, spills) = C.color ({interference=interference,
                                             initial=F.tempMap,
                                             spillCost=(fn (_) => 1),
                                             registers=F.availableRegisters})
    in  (instrs, allocation)
    end
end