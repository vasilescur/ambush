structure Main =
struct
  fun main (fileName : string) = 
    let val absyn = Parse.parse fileName
        val _  = Semant.transProg absyn
    in  ()
    end
end