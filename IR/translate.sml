functor Translate (F : FRAME) : TRANSLATE =
struct 
  structure T = Tree
  structure A = Absyn

  datatype level = 
      TOPLEVEL 
    | NONTOP of {unique: unit ref, parent: level, frame: F.frame}

  type access = level * F.access

  datatype exp = Ex of T.exp
               | Nx of T.stm
               | Cx of Temp.label * Temp.label -> T.stm

  val unfinished = Ex (T.CONST (0))

  val fragList = ref [] : F.frag list ref

  val outermost = TOPLEVEL 

  (* Nil value *)
  val NIL = Ex (T.CONST 0)

  (* new level function *)

  (* formals function *)

  (* allocate a local var function *)

  val errexp = ()
  fun seq (e :: exps) = T.SEQ(e, seq exps)
    | seq ([]) = T.EXP (T.CONST 0)


  fun unEx (Ex e) = e
    | unEx (Cx genstm) =
        let val r = Temp.newtemp ()
            val t = Temp.newlabel () and f = Temp.newlabel ()
        in T.ESEQ ( seq [T.MOVE (T.TEMP r, T.CONST 1),
                  genstm (t,f),
                  T.LABEL f,
                  T.MOVE (T.TEMP r, T.CONST 0),
                  T.LABEL t],
                  T.TEMP r)
        end
    | unEx (Nx s) = T.ESEQ (s, T.CONST 0)

  fun unCx (Cx c) = c
    | unCx (Ex (T.CONST 1)) = (fn (labt, labf) => T.JUMP (T.NAME (labt), [labt]))
    | unCx (Ex (T.CONST 0)) = (fn (labt, labf) => T.JUMP (T.NAME (labf), [labf]))
    | unCx (Ex e) = (fn (labt, labf) => T.CJUMP (T.EQ, T.CONST 1, e, labt, labf))
    | unCx (Nx _) = (ErrorMsg.error 0 "Error: cannot unCx parameter of type Nx";
                     fn (a, b) => T.LABEL (Temp.newlabel ()))

  fun unNx (Ex e) = T.EXP (e)
    | unNx (Nx n) = n
    | unNx (c) = unNx (Ex (unEx (c)))

  fun baseLevel () = TOPLEVEL
  fun nextLevel (currentLevel, label, formals) = NONTOP ({unique = ref (), parent=currentLevel, frame=F.newFrame ({name=label, formals=formals})})

  (* Follow static links *)
  fun followSLs TOPLEVEL TOPLEVEL guess = (Err.error 0 "Failed to follow SLs"; guess)
              | followSLs TOPLEVEL _ guess = (Err.error 0 "Failed to follow SLs"; guess)
              | followSLs _ TOPLEVEL guess = (Err.error 0 "Failed to follow SLs"; guess)
              | followSLs (declevel as NONTOP{unique = uniqdec, parent = _, frame = _}) 
                          (uselevel as NONTOP{unique = uniquse, parent = useparent, frame = _}) guess =
                    if    uniqdec = uniquse
                    then  guess
                    else  followSLs declevel useparent (Tree.MEM guess)
    

  fun intIR (x) = Ex (T.CONST x)
  fun stringIR (literal) =
    let
      fun checkFragmentLiteral(fragment) = 
        case fragment of 
            F.PROC(_) => false
          | F.STRING(label', literal') => String.compare (literal', literal) = EQUAL
      fun generateFragmentLabel() =
        case List.find checkFragmentLiteral (!fragList) of
            SOME (F.STRING (label', literal')) => label'
          | _ => let  val label' = Temp.newlabel()
                 in   fragList := F.STRING (label', literal) :: (!fragList);
                      F.STRING (label', literal) :: (!fragList);
                      label' 
                 end
      val label = generateFragmentLabel ()
    in
      Ex (Tree.NAME (label))
    end

  fun nilIR () = Ex (T.CONST 0)

  fun opIR (left, A.PlusOp, right) = Ex (T.BINOP (T.PLUS, unEx left, unEx right))
    | opIR (left, A.MinusOp, right) = Ex (T.BINOP (T.MINUS, unEx left, unEx right))
    | opIR (left, A.TimesOp, right) = Ex (T.BINOP (T.MUL, unEx left, unEx right)) (* Optimizations? *)
    | opIR (left, A.DivideOp, right) = Ex (T.BINOP (T.DIV, unEx left, unEx right))
    | opIR (left, _, right) = Ex (T.CONST 0)
    
  fun callIR (TOPLEVEL, calllevel, label, args) = Ex (T.CALL (T.NAME label, List.map unEx args))
    | callIR (declevel as NONTOP{unique, parent, frame}, calllevel, label, args) =
      let
          val sl = followSLs parent calllevel (Tree.TEMP F.FP)
          val unExedArgs = map unEx args
      in
          Ex (Tree.CALL (Tree.NAME label, sl :: unExedArgs))
      end

  fun ifIR (test, thenExp, optElseExp) = 
      case optElseExp of
        SOME (elseExp) => let val trueExp = unEx thenExp
                              val falseExp = unEx elseExp
                              val thenLabel = Temp.newlabel ()
                              val elseLabel = Temp.newlabel ()
                              val joinLabel = Temp.newlabel ()
                              val testStm = unCx test
                          in Ex (T.ESEQ (seq [testStm (thenLabel, elseLabel),
                                          T.LABEL thenLabel,
                                          T.EXP trueExp,
                                          T.JUMP (T.NAME joinLabel, [joinLabel]),
                                          T.LABEL elseLabel,
                                          T.EXP falseExp,
                                          T.LABEL joinLabel], T.CONST 0))
                          end
      | NONE => let val condExp = unEx thenExp
                    val thenLabel = Temp.newlabel ()
                    val joinLabel = Temp.newlabel ()
                    val testStm = unCx test
                in Ex (T.ESEQ (seq [testStm (thenLabel, joinLabel), 
                                      T.LABEL thenLabel, 
                                      T.EXP condExp,
                                      T.LABEL joinLabel], T.CONST 0))
                end
end