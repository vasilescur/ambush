functor Translate (Frame : FRAME) : TRANSLATE =
struct 
  structure T = Tree
  datatype exp = Ex of T.exp
               | Nx of T.stm
               | Cx of Temp.label * Temp.label -> T.stm
               | unit

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
end