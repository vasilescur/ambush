functor Translate (F : FRAME) : TRANSLATE =
struct 
  structure T = Tree
  structure A = Absyn
  structure Err = ErrorMsg

  datatype level = 
      TOPLEVEL 
    | NONTOP of {unique: unit ref, parent: level, frame: F.frame}

  type access = level * F.access

  type frag = F.frag

  datatype exp = Ex of T.exp
               | Nx of T.stm
               | Cx of Temp.label * Temp.label -> T.stm

  val unfinished = Ex (T.CONST (0))

  val fragList = ref [] : F.frag list ref

  fun reset () = 
    fragList := []

  val outermost = TOPLEVEL

  (* Nil value *)
  val NIL = Ex (T.CONST 0)

  val malloc = Temp.namedlabel ("malloc")

  fun formals TOPLEVEL = []
    | formals (currentLevel as NONTOP {unique, parent, frame}) = 
        let
          fun appendLevel (frameAccess, level) = (currentLevel, frameAccess) :: level
        in
          foldl appendLevel [] (F.formals frame)
        end


  fun allocateLocal level escape =
    case level of 
        NONTOP ({unique = unique', parent = parent', frame = frame'}) =>
          (NONTOP ({unique = unique', parent = parent', frame = frame'}), F.allocateLocal frame' escape)
      | TOPLEVEL => (Err.error 0 "Cannot allocate a local at top level";
                     (outermost, F.allocateLocal (F.nextFrame {name = Temp.newlabel(), formals = []}) escape))


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

  fun nextLevel (currentLevel, label, formals) = 
    NONTOP ({unique = ref (), 
             parent = currentLevel, 
             frame = F.nextFrame ({name = label, formals = formals})})

  (* Follow static links *)
  fun followSLs TOPLEVEL TOPLEVEL guess = (Err.error 0 "Failed to follow SLs"; guess)   (* Any top level --> fail *)
    | followSLs TOPLEVEL _        guess = (Err.error 0 "Failed to follow SLs"; guess)
    | followSLs _        TOPLEVEL guess = (Err.error 0 "Failed to follow SLs"; guess)
    | followSLs (declevel as NONTOP{unique = uniquedec, parent = _, frame = _}) 
                (uselevel as NONTOP{unique = uniqueuse, parent = useparent, frame = _}) 
                guess =
                  if   uniquedec = uniqueuse
                  then guess
                  else followSLs declevel useparent (Tree.MEM guess)
    

  fun simpleVarIR ((declarationLevel, frameAccess), useLevel) =
    Ex (F.exp (frameAccess, followSLs declarationLevel useLevel (Tree.TEMP F.FP)))

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
    | opIR (left, A.EqOp, right) = Ex (T.RELOP (T.EQ, unEx left, unEx right))
    | opIR (left, A.NeqOp, right) = Ex (T.RELOP (T.NE, unEx left, unEx right))
    | opIR (left, A.LtOp, right) = Ex (T.RELOP (T.LT, unEx left, unEx right))
    | opIR (left, A.LeOp, right) = Ex (T.RELOP (T.LE, unEx left, unEx right))
    | opIR (left, A.GtOp, right) = Ex (T.RELOP (T.GT, unEx left, unEx right))
    | opIR (left, A.GeOp, right) = Ex (T.RELOP (T.GE, unEx left, unEx right))

  fun callIR (TOPLEVEL, calllevel, label, args) = Ex (T.CALL (T.NAME label, List.map unEx args))
    | callIR (declevel as NONTOP{unique, parent, frame}, calllevel, label, args) =
      let
          val sl = followSLs parent calllevel (Tree.TEMP F.FP)
          val unExedArgs = map unEx args
      in
          Ex (Tree.CALL (Tree.NAME label, sl :: unExedArgs))
      end

  fun seqIR ([]) = Ex (T.CONST 0)
    | seqIR ([exp]) = exp 
    | seqIR (front::seq) = Ex (Tree.ESEQ (unNx front, unEx (seqIR seq)))

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

  fun assignIR (var, exp) = Nx (T.MOVE (unEx var, unEx exp))

  fun whileIR (test, body, joinLabel) = let val testLabel = Temp.newlabel ()
                                            val testStm = unCx test
                                            val bodyLabel = Temp.newlabel ()
                                            val bodyNexp = unNx body
                                        in Nx (seq [T.LABEL testLabel,
                                                    testStm (bodyLabel, joinLabel),
                                                    T.LABEL bodyLabel,
                                                    bodyNexp,
                                                    T.JUMP (T.NAME testLabel, [testLabel]),
                                                    T.LABEL joinLabel])
                                        end

  fun forIR (var, lo, hi, body, joinLabel) = let val varExp = unEx var
                                                 val loExp = unEx lo
                                                 val hiExp = unEx hi
                                                 val bodyNexp = unNx body
                                                 val bodyLabel = Temp.newlabel ()
                                                 val updateLabel = Temp.newlabel ()
                                             in Nx (seq [T.MOVE (varExp, loExp),
                                                         T.CJUMP (T.LE, varExp, hiExp, bodyLabel, joinLabel),
                                                         T.LABEL bodyLabel,
                                                         bodyNexp,
                                                         T.CJUMP (T.LT, varExp, hiExp, updateLabel, joinLabel),
                                                         T.LABEL updateLabel,
                                                         T.MOVE (varExp, T.BINOP (T.PLUS, varExp, T.CONST 1)),
                                                         T.JUMP (T.NAME bodyLabel, [bodyLabel]),
                                                         T.LABEL joinLabel])
                                             end

  fun breakIR (joinLabel) = Nx (T.JUMP (T.NAME joinLabel, [joinLabel]))

  fun recordIR (exps) = let val record = Temp.newtemp ()
                            val recordSize = List.length exps 
                            fun fields ([], counter) = []
                              | fields (exp::fexps, counter) = (T.MOVE (T.MEM (T.BINOP (T.PLUS,
                                                                                        T.TEMP record,
                                                                                        T.CONST (counter * F.wordSize))),
                                                                unEx exp))::fields (fexps, counter + 1)
                                          val head = T.MOVE (T.TEMP record,
                                                             (F.externalCall ("allocRecord", [T.CONST(recordSize * F.wordSize)])))
                                          fun setUpRecord () = head::fields(exps, 0)
                                      in Ex (T.ESEQ (seq (setUpRecord ()), T.TEMP record))
                                      end

  fun arrayIR (sizeExp, initExp) = Ex (F.externalCall ("initArray", [unEx sizeExp, unEx initExp]))

  fun letIR (decExps, bodyExp) = let fun stm (dec) = unNx dec
                                 in Ex (T.ESEQ (seq (List.map stm decExps), unEx bodyExp))
                                 end

  fun newVar () = Ex (T.TEMP (Temp.newtemp ()))

  fun procedureEntryExit (level', body', label) =
    let val levelFrame =  (* Determine the level *)
          case level' of 
              TOPLEVEL => (Err.error 0 "Illegal function declaration in outermost level";
                           F.nextFrame ({name = label, formals = []}))
            | NONTOP ({unique = _, parent = _, frame = frame'}) => frame'
        val trBody = unNx body'
        val trBody' = F.procEntryExit1(levelFrame, trBody)
    in  (* Append to frag list *)
        print "procedureEntryExit just added to fragList\n";
        fragList := F.PROC ({body = trBody', frame = levelFrame}) :: (!fragList)
    end

  fun result () = !fragList

  fun appendExpressionList (expressionList, body as exp') =
    let fun createExpressionListStatement (head :: tail) = unNx (head) :: createExpressionListStatement (tail)
          | createExpressionListStatement ([]) = []
    in  Ex (Tree.ESEQ (seq (createExpressionListStatement expressionList), unEx (exp')))
    end
end