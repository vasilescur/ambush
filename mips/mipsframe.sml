structure MIPSFrame : FRAME =
struct
  structure T = Tree 
  structure Err = ErrorMsg

  structure A = Assem
  structure S = Symbol

  datatype access = 
      InFrame of int 
    | InReg of Temp.temp

  type frame = {name      : Temp.label, 
                formals   : access list,
                numLocals : int ref, 
                curOffset : int ref}

  datatype frag =
      PROC   of {body : Tree.stm, frame : frame} 
    | STRING of Temp.label * string


  type register = string

  (* Register Lists *)
  val ZERO = Temp.newtemp ()

  (* Results and evaluation *)
  val v0 = Temp.newtemp ()
  val RV = v0
  val v1 = Temp.newtemp ()
  val valregs = [v0, v1]

  (* Argument registers *)
  val a0 = Temp.newtemp ()
  val a1 = Temp.newtemp ()
  val a2 = Temp.newtemp ()
  val a3 = Temp.newtemp ()
  val argregs = [a0, a1, a2, a3]

  (* Temporary (caller-saved) *)
  val t0 = Temp.newtemp ()
  val t1 = Temp.newtemp ()
  val t2 = Temp.newtemp ()
  val t3 = Temp.newtemp ()
  val t4 = Temp.newtemp ()
  val t5 = Temp.newtemp ()
  val t6 = Temp.newtemp ()
  val t7 = Temp.newtemp ()
  val t8 = Temp.newtemp ()
  val t9 = Temp.newtemp ()
  val callersaves = [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9]

  (* Saved (callee-saved) *)
  val s0 = Temp.newtemp ()
  val s1 = Temp.newtemp ()
  val s2 = Temp.newtemp ()
  val s3 = Temp.newtemp ()
  val s4 = Temp.newtemp ()
  val s5 = Temp.newtemp ()
  val s6 = Temp.newtemp ()
  val s7 = Temp.newtemp ()
  val calleesaves = [s0, s1, s2, s3, s4, s5, s6, s7] 

  (* Special registers *)
  val FP = Temp.newtemp ()
  val SP = Temp.newtemp ()
  val RA = Temp.newtemp ()

  val GP = Temp.newtemp ()
  val specialregs = [RV, FP, SP, RA]


  (* Categories of registers *)

  val regList =
    [("$a0", a0), ("$a1", a1), ("$a2", a2), ("$a3", a3), 
    
     ("$t0", t0), ("$t1", t1), ("$t2", t2), ("$t3", t3), 
     ("$t4", t4), ("$t5", t5), ("$t6", t6), ("$t7", t7), 
     ("$t8", t8), ("$t9", t9),
     
     ("$s0", s0), ("$s1", s1), ("$s2", s2), ("$s3", s3), 
     ("$s4", s4), ("$s5", s5), ("$s6", s6), ("$s7", s7), 
     
     ("$fp", FP), ("$v0", RV), ("$sp", SP), ("$ra", RA)]

  val tempMap = List.foldl (fn ((name, temp), map) => Temp.Map.insert (map, temp, name)) Temp.Map.empty regList

  val registers : register list = List.foldl (fn ((name, temp), registers) => name::registers) [] regList

  val availableRegisters : register list =
    List.map (fn (name) => case (Temp.Map.find (tempMap, name)) of
                              NONE     => "$ERR"
                            | SOME (r) => r)
             (calleesaves @ callersaves @ argregs @ valregs)

  val wordSize = 4 
  val argRegisters = 4

  (* Getters *)
  fun name {name = symbol, formals = _, numLocals = _, curOffset = _} = Symbol.name symbol
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

  fun printFrame {name = name', formals = formals', numLocals = numLocals', curOffset = currentOffset'} =
    (print ("FRAME <" ^ (Symbol.name name') ^ "> (" ^ Int.toString(!numLocals') ^ " locals, current offset = " ^ Int.toString(!currentOffset') ^ ")\n"))

  fun externalCall (s, args) =
    (* =============================================== TODO: external call No-op noop NOP  =============================================== *)
    (* Tree.CALL(Tree.NAME(Temp.namedlabel s), args) *)
    Tree.NOP ()

  fun procEntryExit1(frame', stm') = 
    stm'

  fun procEntryExit2(frame, body) =
    (* body *)
    body @
    [A.OPER{assem="",
    src =[ZERO,RA,SP] @ calleesaves,   
    dst=[], jump=SOME[]}]

  fun procEntryExit3({name, formals, numLocals, curOffset}, body) =
    {prolog = ".text\n# PROCEDURE " ^ Symbol.name name ^ "\n" ^ Symbol.name name ^ ": \n",
      body = body,
      epilog = "# END " ^ Symbol.name name ^ "\n\n"}

  
  fun string (label, str) = 
    (".data\n" ^ Symbol.name label ^ ": .asciiz \"" ^ str ^ "\"\n")

  fun exp (fraccess, frameaddr) =  (* frameaddr is the frame pointer as a tree expression *)
    case fraccess of
        InFrame offset => Tree.MEM(Tree.BINOP(Tree.PLUS, frameaddr, Tree.CONST offset))
      | InReg temp => Tree.TEMP (temp)

  
  fun nextFrame {name, formals} = 
        let fun allocateFormals(offset, [], allocList, numRegs) = allocList
              | allocateFormals(offset, curFormal::l, allocList, numRegs) = 
                  case curFormal of
                       true => allocateFormals (offset + wordSize, l, (InFrame offset)::allocList, numRegs)
                     | false => 
                         if   numRegs < 4
                         then allocateFormals (offset, l, (InReg(Temp.newtemp()))::allocList, numRegs + 1)
                         else allocateFormals (offset + wordSize, l, (InFrame offset)::allocList, numRegs)
        in  {name=name, formals=allocateFormals(0, formals, [], 0),
            numLocals=ref 0, curOffset=ref 0}
        end

end