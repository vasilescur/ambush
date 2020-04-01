structure Main =
struct
  structure S = Semant (Translate (MIPSFrame))
  fun main (fileName : string) = 
    let val absyn = Parse.parse fileName
        val _  = S.transProg absyn
    in  ()
    end
end