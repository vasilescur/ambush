structure MIPSFrame : FRAME =
struct
  val FP = Temp.newtemp ()
  val wordSize = 4 
  fun exp (access) = 
    let
      fun identity (tree : Tree.exp) = 
        tree
    in
      identity
    end

end