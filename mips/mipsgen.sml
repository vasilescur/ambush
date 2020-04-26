structure MIPSGen : CODEGEN =
struct
  structure Frame = MIPSFrame

  structure A = Assem 
  structure T = Tree

  exception ArgsSpill of string

  fun intToString i =
    if   i < 0 
    then "-" ^ Int.toString (~i) 
    else Int.toString i

  fun codeGen (frame) (stm: Tree.stm) : A.instr list =
        let val ilist = ref (nil: A.instr list)
            fun emit x = ilist := x :: !ilist
            fun result (gen) = 
              let val t = Temp.newtemp() 
              in  gen t; 
                  t 
              end

            fun munchStm(T.SEQ(a,b)) = (munchStm a; munchStm b)
            
              (* Label *)
              | munchStm(T.LABEL lab) =
                    emit(A.LABEL{assem= (Symbol.name lab) ^ ":", lab=lab})

              (* Data movements *)

              (* Memory stores *)
  
              (* (e1 + i) <-- e2 *)
              | munchStm(T.MOVE(T.MEM(T.BINOP(T.PLUS,e1,T.CONST i)),e2)) =
                  emit(A.OPER{assem="sw   `s0, " ^ intToString i ^ "(`s1)",
                  src=[munchExp e2, munchExp e1],
                  dst=[],jump=NONE})
              | munchStm(T.MOVE(T.MEM(T.BINOP(T.PLUS,T.CONST i,e1)),e2)) =
                  emit(A.OPER{assem="sw   `s0, " ^ intToString i ^ "(`s1)",
                  src=[munchExp e2, munchExp e1],
                  dst=[],jump=NONE})

              (* (e1 - i) <-- e2 *)

              | munchStm (T.MOVE(T.MEM(T.BINOP(T.MINUS, e1, T.CONST i)), e2)) =
                  emit(A.OPER{assem="sw   `s0, -" ^ intToString (i) ^ "(`s1)",
                  src=[munchExp e2, munchExp e1],
                  dst=[],jump=NONE})
              | munchStm (T.MOVE(T.MEM(T.BINOP(T.MINUS, T.CONST i, e1)), e2)) =
                  emit(A.OPER{assem="sw   `s0, -" ^ intToString (i) ^ "(`s1)",
                  src=[munchExp e2, munchExp e1],
                  dst=[],jump=NONE})

              (* (i) <-- e2 *)
              | munchStm(T.MOVE(T.MEM(e1), e2)) =
                  emit(A.OPER{assem="sw   `s0, 0(`s1)",
                  src=[munchExp e2, munchExp e1],
                  dst= [] ,jump=NONE})



              (* | munchStm(T.MOVE(T.MEM(e1),T.MEM(e2))) =
                  emit(A.OPER{assem="sw s0, (s1)",
                  src=[munchExp e1, munchExp e2],
                  dst=[],jump=NONE}) *)
              (* | munchStm(T.MOVE(T.MEM(T.CONST i),e2)) =
                  emit(A.OPER{assem="sw s0, " ^ intToString i ^ "<- s0",
                  src=[munchExp e2], dst=[],jump=NONE}) *)



              (* Memory loads *)

              | munchStm (T.MOVE((T.TEMP i, T.CONST n))) =
                emit(A.OPER{assem="li   `d0, " ^ intToString n,
                            src=[],dst=[i],jump=NONE})

              | munchStm (T.MOVE(T.TEMP i,
                                T.MEM(T.BINOP(T.PLUS, e1, T.CONST n)))) =
                emit(A.OPER{assem="lw   `d0, " ^ intToString n ^ "(`s0)",
                            src=[munchExp e1],dst=[i],jump=NONE})

              | munchStm (T.MOVE(T.TEMP i,
                                T.MEM(T.BINOP(T.PLUS, T.CONST n, e1)))) =
                emit(A.OPER{assem="lw   `d0, " ^ intToString n ^ "(`s0)",
                            src=[munchExp e1],dst=[i],jump=NONE})

              | munchStm (T.MOVE(T.TEMP i,
                                T.MEM(T.BINOP(T.MINUS, e1, T.CONST n)))) =
                emit(A.OPER{assem="lw   `d0, " ^ intToString (n) ^ "(`s0)",
                            src=[munchExp e1],dst=[i],jump=NONE})

              | munchStm (T.MOVE(T.TEMP i,
                                T.MEM(T.BINOP(T.MINUS, T.CONST n, e1)))) =
                emit(A.OPER{assem="lw   `d0, " ^ intToString (n) ^ "(`s0)",
                            src=[munchExp e1],dst=[i],jump=NONE})


              (* Register-to-register moves *)
              
              | munchStm (T.MOVE((T.TEMP i, e2))) =
                emit(A.MOVE{assem="move `d0, `s0",
                            src=munchExp e2,dst=i})

              (* Branches *)

              | munchStm (T.JUMP(T.NAME lab, _)) =
                emit(A.OPER{assem="j    `j0",src=[],dst=[],jump=SOME([lab])})

              | munchStm (T.JUMP(e, labels)) =
                emit(A.OPER{assem="jr   `j0",src=[munchExp e],
                            dst=[],jump=SOME(labels)})
                            
                            
              (* Comparisons with 0 *)

              | munchStm (T.CJUMP(T.GE, e1, T.CONST 0, l1, l2)) =
                emit(A.OPER{assem="bgez `s0, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1],jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.GT, e1, T.CONST 0, l1, l2)) =
                emit(A.OPER{assem="bgtz `s0, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1],jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.LE, e1, T.CONST 0, l1, l2)) =
                emit(A.OPER{assem="blez `s0, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1],jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.LT, e1, T.CONST 0, l1, l2)) =
                emit(A.OPER{assem="bltz `s0, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1],jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.EQ, e1, T.CONST 0, l1, l2)) =
                emit(A.OPER{assem="beqz `s0, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1],jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.NE, e1, T.CONST 0, l1, l2)) =
                emit(A.OPER{assem="bnez `s0, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1],jump=SOME [l1,l2]})


              (* General branch cases *)

              | munchStm (T.CJUMP(T.GE, e1, e2, l1, l2)) =
                emit(A.OPER{assem="bge  `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.UGE, e1, e2, l1, l2)) =
                emit(A.OPER{assem="bgeu `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.GT, e1, e2, l1, l2)) =
                emit(A.OPER{assem="bgt  `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.UGT, e1, e2, l1, l2)) =
                emit(A.OPER{assem="bgtu `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.LT, e1, e2, l1, l2)) =
                emit(A.OPER{assem="blt  `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.ULT, e1, e2, l1, l2)) =
                emit(A.OPER{assem="bltu `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.LE, e1, e2, l1, l2)) =
                emit(A.OPER{assem="ble  `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.ULE, e1, e2, l1, l2)) =
                emit(A.OPER{assem="bleu `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.EQ, e1, e2, l1, l2)) =
                emit(A.OPER{assem="beq  `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})

              | munchStm (T.CJUMP(T.NE, e1, e2, l1, l2)) =
                emit(A.OPER{assem="bne  `s0, `s1, `j0\n    b    `j1",
                            dst=[],src=[munchExp e1, munchExp e2],
                            jump=SOME [l1,l2]})


              (* Calls *)

              (* "The one below it would literally do it" -- Jake Derry *)
              (* | munchStm (T.EXP (T.CALL (T.NAME l, args))) =
                let val p = map (fn r => (Temp.newtemp (), r)) Frame.callersaves
                    val sources = map #1 p

                    fun load a r = T.MOVE (T.TEMP r, T.TEMP a)
                    fun store a r = T.MOVE (T.TEMP a, T.TEMP r)
                in  map (fn (a, r) => munchStm(store a r)) p;
                    munchArgs (0, args);
                    emit(A.OPER{assem="jal `j0" ,
                                src=[],
                                dst=[],
                                jump=SOME([l])});
                    map (fn (a, r) => munchStm(load a r)) (List.rev p);
                    ()
                end  *)

              | munchStm (T.EXP e) = (munchExp e; ())

              | munchStm(_) = emit(A.LABEL{assem="MISSING STM",
                                           lab=Temp.newlabel ()})


                (* Memory operations *)

            and munchExp (T.MEM(T.CONST i)) =
                  result(fn r => emit(A.OPER{assem="lw   `d0, " ^ intToString i ^ "($zero)",
                                             src=[],
                                             dst=[r],
                                             jump=NONE}))

                | munchExp (T.MEM (T.TEMP t)) = 
                  result(fn r => emit(A.OPER{assem="lw   `d0, 0(`s0)",
                                             src=[t], 
                                             dst=[r], 
                                             jump=NONE}))

                | munchExp (T.MEM(T.BINOP(T.PLUS, e1, T.CONST i))) =
                  result(fn r => emit(A.OPER{assem="lw   `d0, " ^ intToString i ^ "(`s0)",
                                             src=[munchExp e1],
                                             dst=[r],
                                             jump=NONE}))

                | munchExp (T.MEM(T.BINOP(T.PLUS, T.CONST i, e2))) =
                  result(fn r => emit(A.OPER{assem="lw   `d0, " ^ intToString i ^ "(`s0)",
                                             src=[munchExp e2],
                                             dst=[r],
                                             jump=NONE}))

                | munchExp (T.MEM(T.BINOP(T.MINUS, e1, T.CONST i))) =
                  result(fn r => emit(A.OPER{assem="lw   `d0, -" ^ intToString (i) ^ "(`s0)",
                                             src=[munchExp e1],
                                             dst=[r],
                                             jump=NONE}))

                | munchExp (T.MEM(T.BINOP(T.MINUS, T.CONST i, e2))) =
                  result(fn r => emit(A.OPER{assem="lw   `d0, -" ^ intToString (i) ^ "(`s0)",
                                             src=[munchExp e2],
                                             dst=[r],
                                             jump=NONE}))
                                
                (* Binary operations *)

                (* Constants *)
                | munchExp(T.CONST i) =
                    result(fn r => emit(A.OPER{assem="addi `d0, $0, " ^ intToString i,
                                               src=[], dst=[r], jump=NONE}))

                (* Add and subtracts *)
                | munchExp(T.BINOP(T.PLUS,e1,T.CONST i)) =
                    result(fn r => emit(A.OPER{assem="addi `d0, `s0, " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.PLUS,T.CONST i,e1)) =
                    result(fn r => emit(A.OPER{assem="addi `d0, `s0, " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.PLUS,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="add  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.MINUS,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="sub  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))
                
                (* Multiply and divide *)
                | munchExp(T.BINOP(T.MUL,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="mul  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.DIV,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="div  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                
                (* And, Or, XOR *)
                | munchExp(T.BINOP(T.AND,T.CONST i, e1)) =
                    result(fn r => emit(A.OPER{assem="andi `d0, `s0, " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.AND,e1,T.CONST i)) =
                    result(fn r => emit(A.OPER{assem="andi `d0, `s0, " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.AND,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="and  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                | munchExp(T.BINOP(T.OR,T.CONST i, e1)) =
                    result(fn r => emit(A.OPER{assem="ori  `d0, `s0, " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.OR,e1,T.CONST i)) =
                    result(fn r => emit(A.OPER{assem="ori  `d0, `s0, " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.OR,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="or   `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))
                
                | munchExp(T.BINOP(T.XOR,T.CONST i, e1)) =
                    result(fn r => emit(A.OPER{assem="xori `d0, `s0, " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.XOR,e1,T.CONST i)) =
                    result(fn r => emit(A.OPER{assem="xori `d0, `s0, " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.XOR,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="xor  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                (* Relational Operations *)

                | munchExp (T.RELOP (T.GE, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="sge  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                | munchExp (T.RELOP (T.UGE, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="sgeu `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                | munchExp (T.RELOP (T.GT, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="sgt  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                | munchExp (T.RELOP (T.UGT, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="sgtu `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                | munchExp (T.RELOP (T.LT, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="slt  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                | munchExp (T.RELOP (T.ULT, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="sltu `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                | munchExp (T.RELOP (T.LE, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="sle  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                | munchExp (T.RELOP (T.ULE, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="sleu `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))

                | munchExp (T.RELOP (T.EQ, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="seq  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))
                
                | munchExp (T.RELOP (T.NE, e1, e2)) =
                    result(fn r => emit(A.OPER{assem="sne  `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))


                (* Shifts *)
                | munchExp(T.BINOP(T.LSHIFT,e1,T.CONST i)) =
                    result(fn r => emit(A.OPER{assem="sll  `d0, `s0 " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.LSHIFT,T.CONST i,e1)) =
                    result(fn r => emit(A.OPER{assem="sll  `d0, `s0 " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.LSHIFT,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="sllv `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.RSHIFT,e1,T.CONST i)) =
                    result(fn r => emit(A.OPER{assem="srl  `d0, `s0 " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.RSHIFT,T.CONST i,e1)) =
                    result(fn r => emit(A.OPER{assem="srl  `d0, `s0 " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.RSHIFT,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="srlv `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.ARSHIFT,e1,T.CONST i)) =
                    result(fn r => emit(A.OPER{assem="sra  `d0, `s0 " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.ARSHIFT,T.CONST i,e1)) =
                    result(fn r => emit(A.OPER{assem="sra  `d0, `s0 " ^ intToString i,
                                               src=[munchExp e1], dst=[r], jump=NONE}))
                | munchExp(T.BINOP(T.ARSHIFT,e1,e2)) =
                    result(fn r => emit(A.OPER{assem="srav `d0, `s0, `s1",
                                               src=[munchExp e1, munchExp e2], dst=[r], jump=NONE}))



                (* Registers *)
                | munchExp(T.TEMP t) = t

                (* Names *)
                | munchExp(T.NAME l) = 
                    result(fn r => emit (A.OPER{assem="la   `d0, " ^ Symbol.name l,
                                                src=[],
                                                dst=[r],
                                                jump=NONE}))

                (* Calls *)
                | munchExp (T.CALL (T.NAME l, args)) =
                  let
                      val _ = ()
                      (* Allocate a local var in the frame for each caller-saved reg/temp *)
                      (* Accesses maps temps -> accesses *)
                      val accesses : Frame.access Temp.map = 
                        foldl (fn (r, map) => Temp.Map.insert (map, r, Frame.allocateLocal frame true)) 
                              Temp.Map.empty 
                              Frame.callersaves

                      (* Returns the "backup" memory location of a caller-saved register specified by access *)
                      fun mem (r) = let val access = valOf (Temp.Map.find (accesses, r))
                                    in Frame.exp (access, T.TEMP Frame.FP)
                                    end

                      (* Create statements that store or load the specified register to/from local variables in the frame *)
                      fun store (r : Temp.temp) = T.MOVE (mem r, T.TEMP r)
                      fun load (r : Temp.temp) = T.MOVE (T.TEMP r, mem r)
                  in  map (fn (r) => munchStm(store r)) Frame.callersaves;
                      munchArgs (0, args);
                      emit(A.OPER{assem="jal  `j0",
                                  src=Frame.argregs,
                                  dst=[Frame.RV],
                                  jump=SOME([l])});
                      map (fn (r) => munchStm(load r)) (List.rev Frame.callersaves);
                      Frame.RV
                  end

                (* Get rid of this *)
                | munchExp(tree) = 
                    let val _ = print ("Missing expr: ")
                        val _ = Printtree.printtree (TextIO.stdOut, T.EXP (tree))
                        val _ = print "\n"

                    in result(fn r => emit(A.LABEL {assem="MISSING EXP", 
                                                              lab=Temp.newlabel ()}))
                    end


            and munchArgs (_, nil) = nil 
              | munchArgs (i, exp :: tail) =
                  let val length = List.length Frame.argregs
                  in  if i < length then
                        let val destination = List.nth (Frame.argregs, i)
                            val source = munchExp (exp)
                        in  munchStm (T.MOVE (T.TEMP destination, T.TEMP source));
                            destination :: munchArgs (i + 1, tail)
                        end 
                      else  raise ArgsSpill ("Too many arguments in function call. TODO: Spilling")
                  end

        in munchStm stm; rev(!ilist)
        end
end