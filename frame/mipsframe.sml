structure T = Tree 
structure Err = ErrorMsg

structure MIPSFrame : FRAME =
struct

  datatype access = 
      InFrame of int 
    | InReg of Temp.temp

  type frame = {name: Temp.label, formals: access list,
                numLocals: int ref, curOffset: int ref}

  datatype frag =
      PROC of {body: Tree.stm, frame: frame} 
    | STRING of Temp.label * string

  val FP = Temp.newtemp ()
  val RV = Temp.newtemp ()
  val wordSize = 4 
  val argRegisters = 4

  (* Getters *)
  fun name {name = name, formals = _, numLocals = _, curOffset = _} = name
  fun formals {name = _, formals = formals, numLocals = _, curOffset = _} = formals



  fun allocateLocal frame' escape = 
        let
            fun incrementNumLocals {name=_, formals=_, numLocals=x, curOffset=_} = x := !x + 1
            fun incrementOffset {name=_, formals=_, numLocals=_, curOffset=x} = x := !x - wordSize
            fun getOffsetValue {name=_, formals=_, numLocals=_, curOffset=x} = !x
        in
            incrementNumLocals frame';
            case escape of
                true => (incrementOffset frame'; InFrame(getOffsetValue frame'))
              | false => InReg(Temp.newtemp())
        end

  fun exp (fraccess, frameaddr) = 
        case fraccess of
            InFrame offset => Tree.MEM(Tree.BINOP(Tree.PLUS, frameaddr, Tree.CONST offset))
          | InReg temp => Tree.TEMP(temp)

  fun newFrame {name, formals} = 
        let
            fun allocateFormals(offset, [], allocList, numRegs) = allocList
              | allocateFormals(offset, curFormal::l, allocList, numRegs) = 
                  (
                  case curFormal of
                       true => allocateFormals(offset + wordSize, l, (InFrame offset)::allocList, numRegs)
                     | false => 
                         if numRegs < 4
                         then allocateFormals(offset, l, (InReg(Temp.newtemp()))::allocList, numRegs + 1)
                         else allocateFormals(offset + wordSize, l, (InFrame offset)::allocList, numRegs)
                  )
        in
            {name=name, formals=allocateFormals(0, formals, [], 0),
            numLocals=ref 0, curOffset=ref 0}
        end


  fun externalCall (s, args) =
      Tree.CALL(Tree.NAME(Temp.namedlabel s), args)

  fun procEntryExit1(frame', stm') = stm'

end