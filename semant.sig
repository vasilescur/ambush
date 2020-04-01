signature SEMANT =
sig
  type exp
  val transProg: Absyn.exp -> unit
end