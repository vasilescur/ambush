signature FRAME =
sig
  type frame
  type access

  datatype frag = PROC of {body: Tree.stm, frame: frame}
                | STRING of Temp.label * string
  
  val FP : Temp.temp
  val RV : Temp.temp

  val SP : Temp.temp
  val RA : Temp.temp

  type register = string 

  (* val registers : register list  *)

  val argregs : Temp.temp list
  val callersaves : Temp.temp list 
  val calleesaves : Temp.temp list

  val wordSize : int

  val exp : access * Tree.exp -> Tree.exp
  val name : frame -> string
  val formals : frame -> access list
  val nextFrame : {name: Temp.label, formals: bool list} -> frame
  val string: Temp.label * string -> string

  val allocateLocal : frame -> bool -> access 

  val printFrame : frame -> unit

  val externalCall : string * Tree.exp list -> Tree.exp 
end