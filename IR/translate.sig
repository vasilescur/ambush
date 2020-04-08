signature TRANSLATE =
sig
  type exp

  (* val simpleVar : Env.access * Env.level -> Tree.exp *)

  val unEx : exp -> Tree.exp
  (* val unNx : exp -> Tree.stm
  val unCx : exp -> Temp.label * Temp.label ->Tree.stm *)
end