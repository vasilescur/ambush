structure Main =
struct
  structure F = MIPSFrame
  structure R = Translate (F)
  structure S = Semant (R)

  fun main (fileName : string) = 
    let val _ = ()
    
        (* Lex and Parse --> AST *)
        val absyn = Parse.parse fileName

        (* Typecheck and translate --> fragment list *)
        val _ = R.fragList := []
        val frags  = S.transProg absyn


        (* For testing: print the fragment list *)
        fun printFragment (F.PROC ({body = body', frame = frame'})) = 
              (F.printFrame frame';
               Printtree.printtree (TextIO.stdOut, body');
               print "\n")
          | printFragment (F.STRING (label', literal)) = 
              print ("[STRING] " ^ (Symbol.name label') ^ " \"" ^ literal ^ "\"\n")

    in  app printFragment frags;
        frags
    end
end