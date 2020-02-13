structure Parse : sig val parse : string -> Absyn.exp  end =
struct 
  structure TigerLrVals = TigerLrValsFun(structure Token = LrParser.Token)
  structure Lex = TigerLexFun(structure Tokens = TigerLrVals.Tokens)
  structure TigerP = Join(structure ParserData = TigerLrVals.ParserData
			structure Lex=Lex
			structure LrParser = LrParser)
  fun parse filename =
      let val _ = (ErrorMsg.reset(); ErrorMsg.fileName := filename)

          (* Initialize SockSound! *)
          (* This will kill itself upon connection close *)
          (* val _ = OS.Process.system "python3 socksound.py & disown"  *)
          (* val _ = OS.Process.sleep (Time.fromMilliseconds 500) *)
          val sock = valOf (SockSound.init ())

          (* Startup sound! *)
          val _ = SockSound.play (sock, "c5", 0.4)
          val _ = SockSound.play (sock, "g5", 0.4)
          val _ = SockSound.play (sock, "c6", 1.0)

          val file = TextIO.openIn filename
          fun get _ = TextIO.input file

          fun parseerror(s,p1,p2) = ErrorMsg.error p1 s

          val _ = SockSound.play (sock, "d4", 1.5)
          val lexer = LrParser.Stream.streamify (Lex.makeLexer get)
          val _ = SockSound.play (sock, "f#5", 0.8)

          val _ = SockSound.play (sock, "a4", 1.5)
          val (absyn, _) = TigerP.parse(30,lexer,parseerror,())
          val _ = SockSound.play (sock, "c#5", 0.8)

          val _ = SockSound.play (sock, "d5", 2.0)
       in TextIO.closeIn file;
          print "\nAST (pretty): \n\n";
          PrintAbsyn.print (TextIO.stdOut, absyn);
          print "\nabsyn: \n";

          SockSound.close (sock);

          absyn
      end handle LrParser.ParseError => raise ErrorMsg.Error

end



