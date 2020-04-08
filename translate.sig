signature TRANSLATE =
sig
  type exp
  type level
  type access 

  val baseLevel : unit -> level
  val nextLevel : level * Temp.label -> level

  val intIR : int -> exp
  val stringIR : string -> exp
  val nilIR : unit -> exp 
  val callIR : Symbol.symbol * A.exp list -> exp


  (* val simpleVar : Env.access * Env.level -> Tree.exp *)
end