signature FRAME =
sig
  val FP : Temp.temp
  val wordSize: int
  val exp : Env.access -> Tree.exp -> Tree.exp
end