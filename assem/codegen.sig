signature CODEGEN =
sig
  structure Frame : FRAME
  val codeGen : Frame.frame -> Tree.stm -> Assem.instr list
end