structure MIPSGen : CODEGEN =
struct
  structure Frame = MIPSFrame
  fun codeGen (frame) = let fun treeToAssem (stm) = [Assem.LABEL {assem="", lab=Temp.newlabel ()}]
                        in treeToAssem
                        end
end