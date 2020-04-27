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
  structure A = Assem

  type allocation = C.allocation
  type register = F.register
  type frame = F.frame

  exception RegisterAllocationFailure of string

  fun alloc (instrs, frame) = 
    let val (flow, nodelist) = MakeGraph.instrs2graph (instrs)
        val interference = Liveness.interferenceGraph (flow)
        (* val _ = print "Printing interference graph..."
        val _ = Liveness.print (interference) *)

        val (allocation, spills) = C.color ({interference=interference,
                                             initial=F.tempMap,
                                             spillCost=(fn (_) => 1),
                                             registers=F.availableRegisters})
        fun getRegister (temp) = case Temp.Map.find (allocation, temp) of
                                    NONE     => raise RegisterAllocationFailure ("Did not find register to go with a temp")
                                  | SOME (r) => r
        fun moveSelf (A.MOVE {assem, dst, src}) = ((getRegister dst) <> (getRegister src))
          | moveSelf (_) = true
        val instrs = List.filter moveSelf instrs
    in  (instrs, allocation)
    end
end