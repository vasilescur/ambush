signature TRANSLATE =
sig
  type exp
  type level
  type access 

  val baseLevel : unit -> level
  val nextLevel : level * Temp.label * bool list -> level

  val intIR : int -> exp
  val stringIR : string -> exp
  val nilIR : unit -> exp 
  (* val callIR : level * Symbol.symbol * exp list -> exp *)


  (* val simpleVar : Env.access * Env.level -> Tree.exp *)
end