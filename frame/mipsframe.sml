structure T = TREE 
structure Err = ErrorMsg

structure MIPSFrame : FRAME =
struct

  datatype access = 
      InFrame of int
    | InRegister of Temp.temp

  (* type frame = {name, formals, } *)

  datatype frag =
      PROC of {body: Tree.stm, frame: frame} 
    | STRING of Temp.label * string

  val FP = Temp.newtemp ()
  val RV = Temp.newtemp ()
  val wordSize = 4 
  val argRegisters = 4

  fun exp (frameaccess, frameaddress) =
    case frameaccess of 
        InFrame offset => T.MEM (T.BINOP (T.PLUS, frameaddress, T.CONST offset))
      | InRegister temp => T.TEMP (temp)

  fun newFrame ({name, formals}) = 
    let fun allocateArgs (allocs, arg::args, offset, argDepth) = 
          if arg (* escapes *) then 
            allocateArgs((InFrame offset)::allocs,args, offset + wordSize, argDepth + 1)
          else if argDepth > argRegisters then
                 allocateArgs((InFrame offset)::allocs,args, offset + wordSize, argDepth + 1)
               else (* store in frame *) 
                 allocateArgs((InRegister Temp.newtemp ())::allocs,args, offset + wordSize, argDepth + 1)
    in
      {name=name, formals=allocateArgs ([], formals, 0, 0)}
    end

end