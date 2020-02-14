structure Parse : sig val parse : string -> Absyn.exp  end =
struct 
  structure TigerLrVals = TigerLrValsFun(structure Token = LrParser.Token)
  structure Lex = TigerLexFun(structure Tokens = TigerLrVals.Tokens)
  structure TigerP = Join(structure ParserData = TigerLrVals.ParserData
			structure Lex=Lex
			structure LrParser = LrParser)

  (* --- ENABLE SOUND IN THE COMPILATION PROCESS? --- *)
  val ENABLE_SOUND : bool = false

  fun play (note, duration) = 
            if   ENABLE_SOUND andalso Option.isSome (!SockSound.sock)
            then SOME (SockSound.play (note, duration)) 
            else NONE
  
  fun parse filename =
      let val _ = (ErrorMsg.reset(); ErrorMsg.fileName := filename)

          (* Initialize SockSound! *)
          val _ = OS.Process.system "python3 socksound.py & disown"   (* This will kill itself upon connection close *)
          val _ = OS.Process.sleep (Time.fromMilliseconds 1000)

          val _ = SockSound.sock := SockSound.init ()

          (* val _ = print "sock is " ^ (valOf (!SockSound.sock)) *)
          
          (* Don't play sound if it's disabled. *)
          

          (* Startup sound! *)
          val _ = play ("c5", 0.4)
          val _ = play ("g5", 0.4)
          val _ = play ("c6", 1.0)

          val file = TextIO.openIn filename
          fun get _ = TextIO.input file

          fun parseerror(s,p1,p2) = ErrorMsg.error p1 s

          val _ = play ("d4", 1.5)
          val lexer = LrParser.Stream.streamify (Lex.makeLexer get)
          val _ = play ("f#5", 0.8)

          val _ = play ("a4", 1.5)
          val (absyn, _) = TigerP.parse(30,lexer,parseerror,())
          val _ = play ("c#5", 0.8)

          val _ = play ("d5", 2.0)
       in TextIO.closeIn file;
          print "\nAST (pretty): \n\n";
          PrintAbsyn.print (TextIO.stdOut, absyn);
          print "\nabsyn: \n";

          SockSound.close ();

          absyn
      end handle LrParser.ParseError => raise ErrorMsg.Error

end



