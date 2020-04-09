signature FRAME =
sig
  type frame
  type access

  datatype frag = PROC of {body: Tree.stm, frame: frame}
                | STRING of Temp.label * string
  
  val FP : Temp.temp
  val RV : Temp.temp

  val wordSize : int

  val exp : access * Tree.exp -> Tree.exp
  val name : frame -> Temp.label
  val formals : frame -> access list
  val nextFrame : {name: Temp.label, formals: bool list} -> frame

  val allocateLocal : frame -> bool -> access 

  val printFrame : frame -> unit

  val externalCall : string * Tree.exp list -> Tree.exp 
end