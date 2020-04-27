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
                curOffset : int ref,
                shifts    : T.stm list }

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

  (* Saved (callee-saved) *)
  val s0 = Temp.newtemp ()
  val s1 = Temp.newtemp ()
  val s2 = Temp.newtemp ()
  val s3 = Temp.newtemp ()
  val s4 = Temp.newtemp ()
  val s5 = Temp.newtemp ()
  val s6 = Temp.newtemp ()
  val s7 = Temp.newtemp ()

  (* Special registers *)
  val FP = Temp.newtemp ()
  val SP = Temp.newtemp ()
  val RA = Temp.newtemp ()

  val GP = Temp.newtemp ()
  val specialregs = [RV, FP, SP, RA]

  val callersaves = (* argregs @ *) [t0, t1, t2, t3, t4, t5, t6, t7, t8, t9]
  val calleesaves = [s0, s1, s2, s3, s4, s5, s6, s7] 

  val jumpStart = ".text\n    j    L0\n"

  (* Categories of registers *)

  val regList =
    [ ("$v0", v0), ("$v1", v1),
      
      ("$a0", a0), ("$a1", a1), ("$a2", a2), ("$a3", a3), 
    
     ("$t0", t0), ("$t1", t1), ("$t2", t2), ("$t3", t3), 
     ("$t4", t4), ("$t5", t5), ("$t6", t6), ("$t7", t7), 
     ("$t8", t8), ("$t9", t9),
     
     ("$s0", s0), ("$s1", s1), ("$s2", s2), ("$s3", s3), 
     ("$s4", s4), ("$s5", s5), ("$s6", s6), ("$s7", s7), 
     
     ("$fp", FP), ("$sp", SP), ("$ra", RA)]

  val tempMap = List.foldl (fn ((name, temp), map) => Temp.Map.insert (map, temp, name)) Temp.Map.empty regList

  val registers : register list = List.foldl (fn ((name, temp), registers) => name::registers) [] regList

  val availableRegisters : register list =
    List.map (fn (name) => case (Temp.Map.find (tempMap, name)) of
                              NONE     => ("$ERR")
                            | SOME (r) => r)
             ([a1, a2, a3] @ valregs @ calleesaves @ callersaves)

  val wordSize = 4 
  val argRegisters = 4

  (* Getters *)
  fun name {name = symbol, formals = _, numLocals = _, curOffset = _, shifts = _} = Symbol.name symbol
  fun formals {name = _, formals = formals, numLocals = _, curOffset = _, shifts = _} = formals

  fun allocateLocal frame' escape = 
        let
            fun incrementNumLocals {name=_, formals=_, numLocals=x, curOffset=_, shifts = _} = x := !x + 1
            fun incrementOffset {name=_, formals=_, numLocals=_, curOffset=x, shifts = _} = x := !x - wordSize
            fun getOffsetValue {name=_, formals=_, numLocals=_, curOffset=x, shifts = _} = !x
        in
            incrementNumLocals frame';
            case escape of
                true => (incrementOffset frame'; InFrame(getOffsetValue frame'))
              | false => InReg(Temp.newtemp())
        end

  fun printFrame {name = name', formals = formals', numLocals = numLocals', curOffset = currentOffset', shifts = _} =
    (print ("FRAME <" ^ (Symbol.name name') ^ "> (" ^ Int.toString(!numLocals') ^ " locals, current offset = " ^ Int.toString(!currentOffset') ^ ")\n"))

  fun externalCall (s, args) =
    (* =============================================== TODO: external call No-op noop NOP  =============================================== *)
    (* Tree.CALL(Tree.NAME(Temp.namedlabel s), args) *)
    Tree.NOP ()

  (* ost = offset *)
  fun exp (InFrame (ost), frameaddr) = Tree.MEM (Tree.BINOP (Tree.PLUS, frameaddr, Tree.CONST (ost)))
    | exp (InReg (temp), frameaddr) = Tree.TEMP (temp)

  fun procEntryExit1(frame', stm') = 
    (* TODO: For each incoming register parameter, move it to the place
             from which it is seen from within the function.  *)

    (* Save callee-saved registers *)
    let val {name, formals, numLocals, curOffset, shifts} : frame = frame'

        (* Print the formals for debugging *)
        (* val _ = print ("Formals available in frame of function " ^ Symbol.name (name) ^ ": \n") *)
        val _ = map (fn fml => (let val loc = case fml of 
                                                  InFrame (n) => "frame " ^ Int.toString (n) 
                                                | InReg (tmp) => Temp.makestring tmp
                               in  (print ("  " ^ loc ^ "\n"))
                               end))
                    formals
    
        val accesses : access Temp.map = 
          foldl (fn (r, map) => Temp.Map.insert (map, r, allocateLocal frame' true))
                Temp.Map.empty
                ([RA, SP, FP] @ calleesaves)

        (* Returns the backup memory location of a callee-saved register *)
        fun mem (r) = let val access = valOf (Temp.Map.find (accesses, r))
                      in  exp (access, T.TEMP FP)
                      end 

        (* Create statements that store or load the specified register *)
        fun store (r : Temp.temp) = T.MOVE (mem r, T.TEMP r)
        fun load (r : Temp.temp) = T.MOVE (T.TEMP r, mem r)

        (* Make those statements for everything we need to save/restore *)
        val storeStms = map store ([RA, SP, FP] @ calleesaves)
        val loadStms = map load (List.rev ([RA, SP, FP] @ calleesaves))

        (* Makes a tree sequence *)
        fun seq (e :: exps) = T.SEQ(e, seq exps)
          | seq ([]) = T.EXP (T.CONST 0)
        
    in  (* Append save/restore on either end of the body *)
        seq (shifts @ storeStms @ [stm'] @ loadStms)
    end


  fun procEntryExit2(frame, body) =
    body
    (* body @
    [A.OPER{assem="",
    src =[ZERO,RA,SP] @ calleesaves,
    dst=[], jump=SOME[]}] *)

  fun procEntryExit3({name, formals, numLocals, curOffset, shifts}, body) =
    let val oset = (!numLocals + (List.length argregs)) * wordSize
    in  {prolog = ".text\n# PROCEDURE " ^ Symbol.name name ^ "\n" 
                    ^ Symbol.name name ^ ": \n"
                    ^ "    sw   $fp, 0($sp)\n"
                    ^ "    move $fp, $sp\n"
                    ^ "    addi $sp, $sp, -" ^ Int.toString oset ^ "\n",
         body = body,
         epilog =   "    move $sp, $fp\n"
                  ^ "    lw   $fp, 0($sp)\n"
                  ^ "    jr   $ra\n"
                  ^ "# END " ^ Symbol.name name ^ "\n\n"}
    end
    

  
  fun string (label, str) = 
    (".data\n" ^ Symbol.name label ^ ": .asciiz \"" ^ str ^ "\"\n")



  (* fun createAccess (n : int ref, escape : bool) : access =
    case escape of 
        true =>  (n := !n - wordSize;
                  InFrame (!n + wordSize))
      | false => InReg(Temp.newtemp())


  

  fun nextFrame {name : Temp.label, formals : bool list} =
    let val _ = if (List.length formals) > 4 then raise TooManyArguments else ()
        val n : int ref = ref 0;
        val formals' : access list = map (fn (e) => createAccess (n, e)) formals
    in  {name=name, formals=formals', numLocals=n, curOffset=ref (!n * 4)} : frame 
    end  *)

  exception TooManyArguments of string
  exception FrameFailure of string

  fun nextFrame ({name : Temp.label, formals : bool list}) : frame = 
    let val n = ref 0
        fun iterate ([], _, _) = [] 
          | iterate (head :: tail, [], oset) = raise FrameFailure ("[name = " ^ Symbol.name name ^ "] More formals than argument registers")
              (* if head then (n := !n + 1; 
                            InFrame (oset) :: iterate (tail, [], oset + wordSize))
              else raise TooManyArguments ("Cannot handle more than 3 formals") *)
          | iterate (head :: tail, reg::regs, oset) =
              if head then
                  (n := !n + 1;
                   InFrame(oset) :: iterate(tail, regs, oset + wordSize))
              else let val newTemp = Temp.newtemp ()
                   in  InReg(newTemp) :: iterate(tail, regs, oset)
                   end

        (* accesses represents where the argument values are when they come into the function *)
        val accesses : access list = iterate (false :: formals, argregs, wordSize)

        (* Moves values of the argument registers into their appropriate accesses *)
        fun viewShift (ac, r) = T.MOVE (exp (ac, (T.TEMP FP)), T.TEMP r)

        (* Make the move instructions *)

        (* val _ = (ListPair.map (fn (dst : access, src : Temp.temp) => print ("    " ^ dst ^ " <-- " ^ Temp.makestring (src) ^ "\n"))) (accesses, argregs) *)

        val moveInstrs = (ListPair.map viewShift) (accesses, argregs)

        (* val _ = print ("Making move instructions for view shift: \n")
        val _ = map (fn t => Printtree.printtree (TextIO.stdOut, t)) moveInstrs *)


    in  case (List.length formals) <= (List.length argregs) of
            true =>  {name=name,
                      formals=accesses,
                      numLocals=n,
                      curOffset=ref (!n * wordSize),
                      shifts=moveInstrs} : frame 
          | false => raise TooManyArguments ("Too many args (" ^ Int.toString (!n) ^ ")") 
    end 


  (* fun nextFrame {name, formals} = 
        let val numLocals = ref 0
            fun allocateFormals(oset, [], allocList, numRegs) = (numLocals := oset; allocList)
              | allocateFormals(oset, curFormal::l, allocList, numRegs) = 
                  case curFormal of
                       true => allocateFormals (oset + 1, l, (InFrame (oset * wordSize))::allocList, numRegs)
                     | false => 
                         if   numRegs < 4
                         then allocateFormals (oset, l, (InReg(Temp.newtemp()))::allocList, numRegs + 1)
                         else allocateFormals (oset + 1, l, (InFrame (oset * wordSize))::allocList, numRegs)
        in  {name=name, 
             formals=allocateFormals(0, formals, [], 0),
             numLocals=numLocals,
             curOffset=ref (!numLocals * wordSize)}
        end *)

end