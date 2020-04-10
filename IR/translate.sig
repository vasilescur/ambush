signature TRANSLATE =
sig
  type exp
  type level
  type access
  type frag

  val unfinished : exp
  val outermost : level

  val fragList : frag list ref

  val baseLevel : unit -> level
  val nextLevel : level * Temp.label * bool list -> level

  val formals : level -> access list
  val allocateLocal : level -> bool -> access

  val simpleVarIR : access * level -> exp
  val newVar : unit -> exp
  val callIR : level * level * Symbol.symbol * exp list -> exp
  val opIR : exp * Absyn.oper * exp -> exp
  val ifIR : exp * exp * exp option -> exp
  val assignIR : exp * exp -> exp
  val whileIR : exp * exp * Temp.label -> exp
  val breakIR : Temp.label -> exp
  val forIR : exp * exp * exp * exp * Temp.label -> exp 
  val arrayIR : exp * exp -> exp
  val recordIR : exp list -> exp
  val seqIR : exp list -> exp
  val intIR : int -> exp
  val nilIR : unit -> exp 
  val stringIR : string -> exp
  val letIR : exp list * exp -> exp


  val procedureEntryExit : level * exp * Temp.label -> unit

  val result : unit -> frag list

end