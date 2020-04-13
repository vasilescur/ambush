structure Main = 
struct

  structure F = MIPSFrame
  structure Tr = Translate(F)
  structure S = Semant(Tr)
  (* structure R = RegAlloc *)

  fun getsome (SOME x) = x

  fun emitproc out (F.PROC{body,frame}) =
        let val _ = print ("emit " ^ F.name frame ^ "\n")
            (* val _ = Printtree.printtree(out,body); *)
            val stms = Canon.linearize body
            (* val _ = app (fn s => Printtree.printtree(out,s)) stms; *)
            val stms' = Canon.traceSchedule(Canon.basicBlocks stms)
            val instrs = F.procEntryExit2 (frame, List.concat (map (MIPSGen.codeGen frame) stms'))
            val {prolog, body, epilog} = F.procEntryExit3 (frame, instrs)
            val format0 = Assem.format(Temp.makestring)
        in  (TextIO.output (out, prolog); (app (fn i => TextIO.output(out, (format0 i) ^ "\n")) instrs); TextIO.output (out, epilog))
        end
    | emitproc out (F.STRING(lab,s)) = TextIO.output(out, (F.string (lab,s)) ^ "\n")

   fun withOpenFile fname f = 
       let val out = TextIO.openOut fname
        in ((f TextIO.stdOut); (f out before TextIO.closeOut out))
      handle e => (TextIO.closeOut out; raise e)
       end 

   fun compile filename = 
       let val absyn = Parse.parse (filename ^ ".tig") 
           val frags = ((*FindEscape.prog absyn;*) S.transProg absyn)
        in 
            withOpenFile (filename ^ ".s") 
	     (fn out => (app (emitproc out) frags))
       end

end