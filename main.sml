structure Main = 
struct

  structure F = MIPSFrame
  structure Tr = Translate(F)
  structure S = Semant(Tr)
  structure R = RegAlloc (F)

  fun emitproc out (F.PROC{body,frame}) =
        let val _ = print ("emit " ^ F.name frame ^ "\n")
            (* Linearize the statements of the body and trace schedule *)
            (* val _ = Printtree.printtree(out,body); *)
            val stms = Canon.linearize body
            val _ = app (fn s => Printtree.printtree(TextIO.stdOut,s)) stms;
            val stms' = Canon.traceSchedule(Canon.basicBlocks stms)

            (* Convert to list of instructions *)
            val instrs = F.procEntryExit2 (frame, List.concat (map (MIPSGen.codeGen frame) stms'))
            val {prolog, body, epilog} = F.procEntryExit3 (frame, instrs)

            (* Format those instructions using temp names *)
            val format0 = Assem.format(Temp.makestring)

            val (instrs, allocation) = R.alloc (body, frame)

        in  (TextIO.output (out, prolog); (app (fn i => TextIO.output(out, (format0 i) ^ "\n")) instrs); TextIO.output (out, epilog))
        end
    | emitproc out (F.STRING(lab,s)) = TextIO.output(out, (F.string (lab,s)) ^ "\n")

   fun withOpenFile fname f = 
       let val out = TextIO.openOut fname
       in  ((*(f TextIO.stdOut);*) (f out before TextIO.closeOut out))
       handle e => (TextIO.closeOut out; raise e)
       end 

   fun compile filename = 
       let val absyn = Parse.parse (filename ^ ".tig")
           val _ = print "\nAbstract Syntax Tree: \n";
           val _ = PrintAbsyn.print (TextIO.stdOut, absyn)
           val _ = Temp.reset ()
           val frags = ((*FindEscape.prog absyn;*) S.transProg absyn)
       in  withOpenFile (filename ^ ".s") 
	                      (fn out => (app (emitproc out) (List.rev frags)))
       handle S.TypeCheckError => (print "Compilation failed due to type checking error")
       end
end