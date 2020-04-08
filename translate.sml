functor Translate (F : FRAME) : TRANSLATE =
struct 
  structure T = Tree

  datatype level = 
      TOPLEVEL 
    | NONTOP of {unique: unit ref, parent: level, frame: F.frame}

  type access = level * F.access

  datatype exp = Ex of T.exp
               | Nx of T.stm
               | Cx of Temp.label * Temp.label -> T.stm
               | unit  (* TODO: remove *)

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
    | unEx (ex : exp) = T.CONST 0

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
  fun nextLevel (currentLevel, label, formals) = NONTOP ({unique = () ref, parent=currentLevel, frame=F.newFrame ({name=label, formals=formals})})

  fun intIR (x) = Ex (T.CONST x)
  fun stringIR (literal) =
    let
      fun checkFragmentLiteral(fragment) = 
        case fragment of 
            F.PROC(_) => false
          | F.STRING(label', literal') => String.compare (litearl', literal) = EQUAL
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
  fun callIR (func, args) =
    let
      bindings
    in
      body
    end
end