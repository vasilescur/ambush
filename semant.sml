structure Semant : SEMANT =
struct
  type venv = Env.enventry Symbol.table
  type tenv = Env.ty Symbol.table

  (* type expty = {exp: Translate.exp, ty: Types.ty} *)

  (*   
  val transVar: venv * tenv * Absyn.var -> expty
  val transExp: venv * tenv * Absyn.exp -> expty
  val transDec: venv * tenv * Absyn.dec -> {venv: venv, tenv: tenv}
  val transTy: tenv * Absyn.ty -> Types.ty 
  *)

  (* transProg : Absyn.exp -> unit *)
  fun transProg (absyn : Absyn.exp) : unit =
    let
      val _ = ()
    in
      ()
    end
end