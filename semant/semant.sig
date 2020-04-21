signature SEMANT =
sig
  type exp
  type frag
  val transProg: Absyn.exp -> frag list (* Tree.stm *)
  exception TypeCheckError
end