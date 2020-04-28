structure Main = 
struct

  structure F = MIPSFrame
  structure Tr = Translate(F)
  structure S = Semant(Tr)
  structure R = RegAlloc (F)

  fun readFileLines (infile : string) : string list = 
    let val ins = TextIO.openIn infile
        fun loop ins =
          case TextIO.inputLine ins of
              SOME (line) => line :: loop ins
            | NONE => []
    in  loop ins before TextIO.closeIn ins
    end
        

  fun emitproc out (F.PROC{body,frame}) =
        let val _ = ()
          (*val _ = print ("emit " ^ F.name frame ^ "\n")*)
          (* Linearize the statements of the body and trace schedule *)
          (* val _ = Printtree.printtree(out,body); *)
          val stms = Canon.linearize body
          val stms' = Canon.traceSchedule(Canon.basicBlocks stms)
          (* val _ = app (fn s => Printtree.printtree(TextIO.stdOut,s)) stms'; *)

          (* Convert to list of instructions *)
          val instrs = F.procEntryExit2 (frame, List.concat (map (MIPSGen.codeGen frame) stms'))
          val {prolog, body, epilog} = F.procEntryExit3 (frame, instrs)

          (* Format those instructions using temp names *)
          (* val formatFun = Assem.format(Temp.makestring) *)

          (* Register allocator go brrrrrr *)
          val (instrs, allocation) = R.alloc (body, frame)
            handle e => raise e
          
          (* (* Print the allocation table *)
          val _ = print ("\n\nAllocation Table: \n")

          val _ = map (fn (key, value) => (print ("    " ^ (value) ^ " <- " ^ (Temp.makestring key) ^ "\n")))
              (Temp.Map.listItemsi allocation)

          val _ = print("\n") *)

          (*Instead of formatting with temp names, format with allocated reg names *)
          val formatFun = 
            Assem.format (fn (temp) => case (Temp.Map.find (allocation, temp)) of 
                                                        NONE => "NotFound"
                                                      | SOME (register) => register)  
              handle e => (raise e)

        in  (TextIO.output (out, prolog);
            (* TextIO.output (out, ".text\n"); *)
            (app (fn i => let val instruction = (formatFun i)
                          in  TextIO.output(out, instruction ^ "\n")
                          end) instrs); 
            TextIO.output (out, epilog)) 
        end
    | emitproc out (F.STRING(lab,s)) = TextIO.output(out, (F.string (lab,s)) ^ "\n")

  fun withOpenFile fname f = 
    let val out = TextIO.openOut fname
    in  ((*(f TextIO.stdOut);*) (f out before TextIO.closeOut out))
    (* handle e => (TextIO.closeOut out; raise e) *)
    end

  fun compile filename = 
    let val _ = Temp.start ()
        (* Read the libraries from its file *)
        val runtimeLibLines = readFileLines "runtimele.s"
        val spimSyscallLib = readFileLines "sysspim.s"

        val absyn = Parse.parse (filename)
        (* val _ = print "\nAbstract Syntax Tree: \n";
        val _ = PrintAbsyn.print (TextIO.stdOut, absyn) *)
        
        val frags = ((*FindEscape.prog absyn;*) S.transProg absyn)
            handle e => raise e

        val openFile = withOpenFile (filename ^ ".s")
                              (fn out => (TextIO.output (out, F.jumpStart); 
                                          (app (emitproc out) ((*List.rev*) frags));
                                          
                                          (* Add the runtime library and SPIM syscall library to the end of the file *) 
                                          (app (fn l => TextIO.output (out, l)) (runtimeLibLines @ ["\n\n\n"] @ spimSyscallLib))))
        val _ = Temp.reset ()
    in  ()
    end

  (* Entry point of the application *)
  fun main (sml_path_name : string, args : string list) : OS.Process.status = 
    let val STATUS_SUCCESS = 0
        val STATUS_FAIL = 1
        val prog_name  = List.hd args
        val args = List.tl args
        val exitstatus = case args of 
                            [] => ((print "Error: Unspecified input file.\nUsage: ambush [inputfile] or ambush --help\n");
                                   STATUS_FAIL)
                          | [arg1] => if arg1 = "--help"
                                        then ((print "Usage: ambush [inputfile] or ambush --help\n");
                                              STATUS_SUCCESS)
                                        else (* We were given a file name-- compile it *)
                                             (compile arg1; 
                                              STATUS_SUCCESS)
                          | _ => ((print "Usage: ambush [inputfile] or ambush --help\n");
                                  STATUS_FAIL)
            handle _ => STATUS_FAIL
    in  exitstatus : OS.Process.status
    end
   
end