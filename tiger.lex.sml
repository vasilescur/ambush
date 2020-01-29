structure Mlex  = struct

    structure yyInput : sig

        type stream
	val mkStream : (int -> string) -> stream
	val fromStream : TextIO.StreamIO.instream -> stream
	val getc : stream -> (Char.char * stream) option
	val getpos : stream -> int
	val getlineNo : stream -> int
	val subtract : stream * stream -> string
	val eof : stream -> bool
	val lastWasNL : stream -> bool

      end = struct

        structure TIO = TextIO
        structure TSIO = TIO.StreamIO
	structure TPIO = TextPrimIO

        datatype stream = Stream of {
            strm : TSIO.instream,
	    id : int,  (* track which streams originated 
			* from the same stream *)
	    pos : int,
	    lineNo : int,
	    lastWasNL : bool
          }

	local
	  val next = ref 0
	in
	fun nextId() = !next before (next := !next + 1)
	end

	val initPos = 2 (* ml-lex bug compatibility *)

	fun mkStream inputN = let
              val strm = TSIO.mkInstream 
			   (TPIO.RD {
			        name = "lexgen",
				chunkSize = 4096,
				readVec = SOME inputN,
				readArr = NONE,
				readVecNB = NONE,
				readArrNB = NONE,
				block = NONE,
				canInput = NONE,
				avail = (fn () => NONE),
				getPos = NONE,
				setPos = NONE,
				endPos = NONE,
				verifyPos = NONE,
				close = (fn () => ()),
				ioDesc = NONE
			      }, "")
	      in 
		Stream {strm = strm, id = nextId(), pos = initPos, lineNo = 1,
			lastWasNL = true}
	      end

	fun fromStream strm = Stream {
		strm = strm, id = nextId(), pos = initPos, lineNo = 1, lastWasNL = true
	      }

	fun getc (Stream {strm, pos, id, lineNo, ...}) = (case TSIO.input1 strm
              of NONE => NONE
	       | SOME (c, strm') => 
		   SOME (c, Stream {
			        strm = strm', 
				pos = pos+1, 
				id = id,
				lineNo = lineNo + 
					 (if c = #"\n" then 1 else 0),
				lastWasNL = (c = #"\n")
			      })
	     (* end case*))

	fun getpos (Stream {pos, ...}) = pos

	fun getlineNo (Stream {lineNo, ...}) = lineNo

	fun subtract (new, old) = let
	      val Stream {strm = strm, pos = oldPos, id = oldId, ...} = old
	      val Stream {pos = newPos, id = newId, ...} = new
              val (diff, _) = if newId = oldId andalso newPos >= oldPos
			      then TSIO.inputN (strm, newPos - oldPos)
			      else raise Fail 
				"BUG: yyInput: attempted to subtract incompatible streams"
	      in 
		diff 
	      end

	fun eof s = not (isSome (getc s))

	fun lastWasNL (Stream {lastWasNL, ...}) = lastWasNL

      end

    datatype yystart_state = 
REM | digit | STRING | COMMENT | INITIAL
    structure UserDeclarations = 
      struct

type pos = int
type lexresult = Tokens.token

val lineNum = ErrorMsg.lineNum
val linePos = ErrorMsg.linePos

fun err (p1, p2) = ErrorMsg.error p1

fun eof () = 
  let val pos = hd (!linePos) 
  in  Tokens.EOF (pos, pos) 
  end
  

fun s_e pos text = (pos, pos + String.size text)



(* 

while, for, to, break, let, in, end, function, var, type, array, if, then, else,
do, of, nil

*)




(* If you're wondering why there's an unused "REM" state, 
   it's so we can use comments in the lexer definitions below
   the [double %]... It's a dirty hack but  *shrug*  *)



      end

    datatype yymatch 
      = yyNO_MATCH
      | yyMATCH of yyInput.stream * action * yymatch
    withtype action = yyInput.stream * yymatch -> UserDeclarations.lexresult

    local

    val yytable = 
#[([(#"\^@",#"\b",4),
(#"\v",#"\^_",4),
(#"!",#"<",4),
(#">",#"@",4),
(#"D",#"D",4),
(#"G",#"H",4),
(#"K",#"\255",4),
(#"\t",#"\t",5),
(#" ",#" ",5),
(#"\n",#"\n",6),
(#"=",#"=",7),
(#"A",#"A",8),
(#"B",#"B",9),
(#"C",#"C",10),
(#"E",#"E",11),
(#"F",#"F",12),
(#"I",#"I",13),
(#"J",#"J",14)], []), ([(#"\^@",#"\b",4),
(#"\v",#"\^_",4),
(#"!",#"\255",4),
(#"\t",#"\t",5),
(#" ",#" ",5),
(#"\n",#"\n",6)], []), ([(#"\^@",#"\b",395),
(#"\v",#"\^_",395),
(#"!",#")",395),
(#"+",#"\255",395),
(#"\t",#"\t",396),
(#" ",#" ",396),
(#"\n",#"\n",6),
(#"*",#"*",397)], []), ([(#"\^@",#"\b",4),
(#"\v",#"\^_",4),
(#"!",#"%",4),
(#"'",#"'",4),
(#"0",#"9",4),
(#"?",#"@",4),
(#"\\",#"\\",4),
(#"^",#"`",4),
(#"~",#"\255",4),
(#"\t",#"\t",5),
(#" ",#" ",5),
(#"\n",#"\n",6),
(#"&",#"&",399),
(#"(",#"(",400),
(#")",#")",401),
(#"*",#"*",402),
(#"+",#"+",403),
(#",",#",",404),
(#"-",#"-",405),
(#".",#".",406),
(#"/",#"/",407),
(#":",#":",408),
(#";",#";",409),
(#"<",#"<",410),
(#"=",#"=",411),
(#">",#">",412),
(#"A",#"Z",413),
(#"c",#"c",413),
(#"g",#"h",413),
(#"j",#"k",413),
(#"m",#"m",413),
(#"p",#"s",413),
(#"u",#"u",413),
(#"x",#"z",413),
(#"[",#"[",414),
(#"]",#"]",415),
(#"a",#"a",416),
(#"b",#"b",417),
(#"d",#"d",418),
(#"e",#"e",419),
(#"f",#"f",420),
(#"i",#"i",421),
(#"l",#"l",422),
(#"n",#"n",423),
(#"o",#"o",424),
(#"t",#"t",425),
(#"v",#"v",426),
(#"w",#"w",427),
(#"{",#"{",428),
(#"|",#"|",429),
(#"}",#"}",430)], []), ([], [77]), ([], [6, 77]), ([], [4]), ([(#"=",#"=",193)], [77]), ([(#"r",#"r",175),
(#"s",#"s",176)], [77]), ([(#"o",#"o",169)], [77]), ([(#"o",#"o",144)], [77]), ([(#"n",#"n",112),
(#"q",#"q",113),
(#"x",#"x",114)], [77]), ([(#"o",#"o",86)], [77]), ([(#"g",#"g",41)], [77]), ([(#"u",#"u",15)], [77]), ([(#"s",#"s",16)], []), ([(#"t",#"t",17)], []), ([(#" ",#" ",18)], []), ([(#"i",#"i",19)], []), ([(#"g",#"g",20)], []), ([(#"n",#"n",21)], []), ([(#"o",#"o",22)], []), ([(#"r",#"r",23)], []), ([(#"e",#"e",24)], []), ([(#" ",#" ",25)], []), ([(#"s",#"s",26)], []), ([(#"p",#"p",27)], []), ([(#"a",#"a",28)], []), ([(#"c",#"c",29)], []), ([(#"e",#"e",30)], []), ([(#"s",#"s",31)], []), ([(#" ",#" ",32)], []), ([(#"o",#"o",33)], []), ([(#"r",#"r",34)], []), ([(#" ",#" ",35)], []), ([(#"t",#"t",36)], []), ([(#"a",#"a",37)], []), ([(#"b",#"b",38)], []), ([(#"s",#"s",39)], []), ([(#".",#".",40)], []), ([], [5]), ([(#"n",#"n",42)], []), ([(#"o",#"o",43)], []), ([(#"r",#"r",44)], []), ([(#"e",#"e",45)], []), ([(#" ",#" ",46)], []), ([(#"s",#"s",47)], []), ([(#"y",#"y",48)], []), ([(#"m",#"m",49)], []), ([(#"b",#"b",50)], []), ([(#"o",#"o",51)], []), ([(#"l",#"l",52)], []), ([(#"s",#"s",53)], []), ([(#" ",#" ",54)], []), ([(#"a",#"a",55)], []), ([(#"n",#"n",56)], []), ([(#"d",#"d",57)], []), ([(#" ",#" ",58)], []), ([(#"r",#"r",59)], []), ([(#"e",#"e",60)], []), ([(#"s",#"s",61)], []), ([(#"e",#"e",62)], []), ([(#"r",#"r",63)], []), ([(#"v",#"v",64)], []), ([(#"e",#"e",65)], []), ([(#"d",#"d",66)], []), ([(#" ",#" ",67)], []), ([(#"w",#"w",68)], []), ([(#"o",#"o",69)], []), ([(#"r",#"r",70)], []), ([(#"d",#"d",71)], []), ([(#"s",#"s",72)], []), ([(#" ",#" ",73)], []), ([(#"i",#"i",74)], []), ([(#"n",#"n",75)], []), ([(#" ",#" ",76)], []), ([(#"c",#"c",77)], []), ([(#"o",#"o",78)], []), ([(#"m",#"m",79)], []), ([(#"m",#"m",80)], []), ([(#"e",#"e",81)], []), ([(#"n",#"n",82)], []), ([(#"t",#"t",83)], []), ([(#"s",#"s",84)], []), ([(#".",#".",85)], []), ([], [14]), ([(#"r",#"r",87)], []), ([(#" ",#" ",88)], []), ([(#"w",#"w",89)], []), ([(#"h",#"h",90)], []), ([(#"e",#"e",91)], []), ([(#"n",#"n",92)], []), ([(#" ",#" ",93)], []), ([(#"l",#"l",94)], []), ([(#"e",#"e",95)], []), ([(#"x",#"x",96)], []), ([(#"i",#"i",97)], []), ([(#"n",#"n",98)], []), ([(#"g",#"g",99)], []), ([(#" ",#" ",100)], []), ([(#"g",#"g",101)], []), ([(#"o",#"o",102)], []), ([(#"e",#"e",103)], []), ([(#"s",#"s",104)], []), ([(#" ",#" ",105)], []), ([(#"w",#"w",106)], []), ([(#"r",#"r",107)], []), ([(#"o",#"o",108)], []), ([(#"n",#"n",109)], []), ([(#"g",#"g",110)], []), ([(#".",#".",111)], []), ([], [76]), ([(#"t",#"t",132)], []), ([(#"u",#"u",126)], []), ([(#"i",#"i",115)], []), ([(#"t",#"t",116)], []), ([(#" ",#" ",117)], []), ([(#"c",#"c",118)], []), ([(#"o",#"o",119)], []), ([(#"m",#"m",120)], []), ([(#"m",#"m",121)], []), ([(#"e",#"e",122)], []), ([(#"n",#"n",123)], []), ([(#"t",#"t",124)], []), ([(#".",#".",125)], []), ([], [12]), ([(#"a",#"a",127)], []), ([(#"l",#"l",128)], []), ([(#"i",#"i",129)], []), ([(#"t",#"t",130)], []), ([(#"y",#"y",131)], []), ([], [44]), ([(#"e",#"e",133)], []), ([(#"r",#"r",134)], []), ([(#" ",#" ",135)], []), ([(#"c",#"c",136)], []), ([(#"o",#"o",137)], []), ([(#"m",#"m",138)], []), ([(#"m",#"m",139)], []), ([(#"e",#"e",140)], []), ([(#"n",#"n",141)], []), ([(#"t",#"t",142)], []), ([(#".",#".",143)], []), ([], [10]), ([(#"u",#"u",145)], []), ([(#"n",#"n",146)], []), ([(#"t",#"t",147)], []), ([(#" ",#" ",148)], []), ([(#"a",#"a",149)], []), ([(#"n",#"n",150)], []), ([(#"d",#"d",151)], []), ([(#" ",#" ",152)], []), ([(#"i",#"i",153)], []), ([(#"g",#"g",154)], []), ([(#"n",#"n",155)], []), ([(#"o",#"o",156)], []), ([(#"r",#"r",157)], []), ([(#"e",#"e",158)], []), ([(#" ",#" ",159)], []), ([(#"n",#"n",160)], []), ([(#"e",#"e",161)], []), ([(#"w",#"w",162)], []), ([(#"l",#"l",163)], []), ([(#"i",#"i",164)], []), ([(#"n",#"n",165)], []), ([(#"e",#"e",166)], []), ([(#"s",#"s",167)], []), ([(#".",#".",168)], []), ([], [3]), ([(#"o",#"o",170)], []), ([(#"l",#"l",171)], []), ([(#"e",#"e",172)], []), ([(#"a",#"a",173)], []), ([(#"n",#"n",174)], []), ([], [41]), ([(#"i",#"i",185)], []), ([(#"s",#"s",177)], []), ([(#"i",#"i",178)], []), ([(#"g",#"g",179)], []), ([(#"n",#"n",180)], []), ([(#"m",#"m",181)], []), ([(#"e",#"e",182)], []), ([(#"n",#"n",183)], []), ([(#"t",#"t",184)], []), ([], [39]), ([(#"t",#"t",186)], []), ([(#"h",#"h",187)], []), ([(#"m",#"m",188)], []), ([(#"e",#"e",189)], []), ([(#"t",#"t",190)], []), ([(#"i",#"i",191)], []), ([(#"c",#"c",192)], []), ([], [51]), ([(#"=",#"=",194)], []), ([(#"=",#"=",195)], []), ([(#"=",#"=",196)], []), ([(#"=",#"=",197)], []), ([(#"=",#"=",198)], []), ([(#"=",#"=",199)], []), ([(#" ",#" ",200),
(#"=",#"=",201)], []), ([(#"B",#"B",369)], []), ([(#" ",#" ",202),
(#"=",#"=",203)], []), ([(#"R",#"R",344)], []), ([(#"=",#"=",204)], []), ([(#" ",#" ",205),
(#"=",#"=",206)], []), ([(#"I",#"I",275),
(#"P",#"P",276),
(#"W",#"W",277)], []), ([(#" ",#" ",207),
(#"=",#"=",208)], []), ([(#"C",#"C",231),
(#"O",#"O",232)], []), ([(#"=",#"=",209)], []), ([(#"=",#"=",210)], []), ([(#"=",#"=",211)], []), ([(#"=",#"=",212)], []), ([(#"=",#"=",213)], []), ([(#"=",#"=",214)], []), ([(#"=",#"=",215)], []), ([(#"=",#"=",216)], []), ([(#"=",#"=",217)], []), ([(#"=",#"=",218)], []), ([(#"=",#"=",219)], []), ([(#"=",#"=",220)], []), ([(#"=",#"=",221)], []), ([(#"=",#"=",222)], []), ([(#"=",#"=",223)], []), ([(#"=",#"=",224)], []), ([(#"=",#"=",225)], []), ([(#"=",#"=",226)], []), ([(#"=",#"=",227)], []), ([(#"=",#"=",228)], []), ([(#"=",#"=",229)], []), ([(#"=",#"=",230)], []), ([], [0, 2, 7, 9, 16, 18, 36, 38, 57, 59, 66, 68, 72, 74]), ([(#"o",#"o",254)], []), ([(#"p",#"p",233)], []), ([(#"e",#"e",234)], []), ([(#"r",#"r",235)], []), ([(#"a",#"a",236)], []), ([(#"t",#"t",237)], []), ([(#"o",#"o",238)], []), ([(#"r",#"r",239)], []), ([(#"s",#"s",240)], []), ([(#" ",#" ",241)], []), ([(#"=",#"=",242)], []), ([(#"=",#"=",243)], []), ([(#"=",#"=",244)], []), ([(#"=",#"=",245)], []), ([(#"=",#"=",246)], []), ([(#"=",#"=",247)], []), ([(#"=",#"=",248)], []), ([(#"=",#"=",249)], []), ([(#"=",#"=",250)], []), ([(#"=",#"=",251)], []), ([(#"=",#"=",252)], []), ([(#"=",#"=",253)], []), ([], [37]), ([(#"m",#"m",255)], []), ([(#"m",#"m",256)], []), ([(#"e",#"e",257)], []), ([(#"n",#"n",258)], []), ([(#"t",#"t",259)], []), ([(#"s",#"s",260)], []), ([(#" ",#" ",261)], []), ([(#"=",#"=",262)], []), ([(#"=",#"=",263)], []), ([(#"=",#"=",264)], []), ([(#"=",#"=",265)], []), ([(#"=",#"=",266)], []), ([(#"=",#"=",267)], []), ([(#"=",#"=",268)], []), ([(#"=",#"=",269)], []), ([(#"=",#"=",270)], []), ([(#"=",#"=",271)], []), ([(#"=",#"=",272)], []), ([(#"=",#"=",273)], []), ([(#"=",#"=",274)], []), ([], [8]), ([(#"d",#"d",322)], []), ([(#"u",#"u",300)], []), ([(#"h",#"h",278)], []), ([(#"i",#"i",279)], []), ([(#"t",#"t",280)], []), ([(#"e",#"e",281)], []), ([(#" ",#" ",282)], []), ([(#"S",#"S",283)], []), ([(#"p",#"p",284)], []), ([(#"a",#"a",285)], []), ([(#"c",#"c",286)], []), ([(#"e",#"e",287)], []), ([(#" ",#" ",288)], []), ([(#"=",#"=",289)], []), ([(#"=",#"=",290)], []), ([(#"=",#"=",291)], []), ([(#"=",#"=",292)], []), ([(#"=",#"=",293)], []), ([(#"=",#"=",294)], []), ([(#"=",#"=",295)], []), ([(#"=",#"=",296)], []), ([(#"=",#"=",297)], []), ([(#"=",#"=",298)], []), ([(#"=",#"=",299)], []), ([], [1]), ([(#"n",#"n",301)], []), ([(#"c",#"c",302)], []), ([(#"t",#"t",303)], []), ([(#"u",#"u",304)], []), ([(#"a",#"a",305)], []), ([(#"t",#"t",306)], []), ([(#"i",#"i",307)], []), ([(#"o",#"o",308)], []), ([(#"n",#"n",309)], []), ([(#" ",#" ",310)], []), ([(#"=",#"=",311)], []), ([(#"=",#"=",312)], []), ([(#"=",#"=",313)], []), ([(#"=",#"=",314)], []), ([(#"=",#"=",315)], []), ([(#"=",#"=",316)], []), ([(#"=",#"=",317)], []), ([(#"=",#"=",318)], []), ([(#"=",#"=",319)], []), ([(#"=",#"=",320)], []), ([(#"=",#"=",321)], []), ([], [67]), ([(#"e",#"e",323)], []), ([(#"n",#"n",324)], []), ([(#"t",#"t",325)], []), ([(#"i",#"i",326)], []), ([(#"f",#"f",327)], []), ([(#"i",#"i",328)], []), ([(#"e",#"e",329)], []), ([(#"r",#"r",330)], []), ([(#"s",#"s",331)], []), ([(#" ",#" ",332)], []), ([(#"=",#"=",333)], []), ([(#"=",#"=",334)], []), ([(#"=",#"=",335)], []), ([(#"=",#"=",336)], []), ([(#"=",#"=",337)], []), ([(#"=",#"=",338)], []), ([(#"=",#"=",339)], []), ([(#"=",#"=",340)], []), ([(#"=",#"=",341)], []), ([(#"=",#"=",342)], []), ([(#"=",#"=",343)], []), ([], [73]), ([(#"e",#"e",345)], []), ([(#"s",#"s",346)], []), ([(#"e",#"e",347)], []), ([(#"r",#"r",348)], []), ([(#"v",#"v",349)], []), ([(#"e",#"e",350)], []), ([(#"d",#"d",351)], []), ([(#" ",#" ",352)], []), ([(#"W",#"W",353)], []), ([(#"o",#"o",354)], []), ([(#"r",#"r",355)], []), ([(#"d",#"d",356)], []), ([(#"s",#"s",357)], []), ([(#" ",#" ",358)], []), ([(#"=",#"=",359)], []), ([(#"=",#"=",360)], []), ([(#"=",#"=",361)], []), ([(#"=",#"=",362)], []), ([(#"=",#"=",363)], []), ([(#"=",#"=",364)], []), ([(#"=",#"=",365)], []), ([(#"=",#"=",366)], []), ([(#"=",#"=",367)], []), ([(#"=",#"=",368)], []), ([], [17]), ([(#"r",#"r",370)], []), ([(#"a",#"a",371)], []), ([(#"c",#"c",372)], []), ([(#"e",#"e",373)], []), ([(#"s",#"s",374)], []), ([(#" ",#" ",375)], []), ([(#"a",#"a",376)], []), ([(#"n",#"n",377)], []), ([(#"d",#"d",378)], []), ([(#" ",#" ",379)], []), ([(#"P",#"P",380)], []), ([(#"a",#"a",381)], []), ([(#"r",#"r",382)], []), ([(#"e",#"e",383)], []), ([(#"n",#"n",384)], []), ([(#"s",#"s",385)], []), ([(#" ",#" ",386)], []), ([(#"=",#"=",387)], []), ([(#"=",#"=",388)], []), ([(#"=",#"=",389)], []), ([(#"=",#"=",390)], []), ([(#"=",#"=",391)], []), ([(#"=",#"=",392)], []), ([(#"=",#"=",393)], []), ([(#"=",#"=",394)], []), ([], [58]), ([], [15, 77]), ([], [6, 15, 77]), ([(#"/",#"/",398)], [15, 77]), ([], [13]), ([], [43, 77]), ([], [64, 77]), ([], [65, 77]), ([], [53, 77]), ([], [55, 77]), ([], [71, 77]), ([], [54, 77]), ([], [56, 77]), ([(#"*",#"*",479)], [52, 77]), ([(#"=",#"=",478)], [70, 77]), ([], [69, 77]), ([(#"=",#"=",476),
(#">",#">",477)], [48, 77]), ([], [50, 77]), ([(#"=",#"=",475)], [46, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [75, 77]), ([], [62, 77]), ([], [63, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"q",431),
(#"s",#"z",431),
(#"r",#"r",471)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"q",431),
(#"s",#"z",431),
(#"r",#"r",467)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"n",431),
(#"p",#"z",431),
(#"o",#"o",466)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"k",431),
(#"m",#"m",431),
(#"o",#"z",431),
(#"l",#"l",461),
(#"n",#"n",462)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"n",431),
(#"p",#"t",431),
(#"v",#"z",431),
(#"o",#"o",452),
(#"u",#"u",453)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"e",431),
(#"g",#"m",431),
(#"o",#"z",431),
(#"f",#"f",450),
(#"n",#"n",451)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"d",431),
(#"f",#"z",431),
(#"e",#"e",448)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"h",431),
(#"j",#"z",431),
(#"i",#"i",446)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"e",431),
(#"g",#"z",431),
(#"f",#"f",445)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"g",431),
(#"i",#"n",431),
(#"p",#"x",431),
(#"z",#"z",431),
(#"h",#"h",438),
(#"o",#"o",439),
(#"y",#"y",440)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"b",#"z",431),
(#"a",#"a",436)], [75, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"g",431),
(#"i",#"z",431),
(#"h",#"h",432)], [75, 77]), ([], [60, 77]), ([], [42, 77]), ([], [61, 77]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"h",431),
(#"j",#"z",431),
(#"i",#"i",433)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"k",431),
(#"m",#"z",431),
(#"l",#"l",434)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"d",431),
(#"f",#"z",431),
(#"e",#"e",435)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [19, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"q",431),
(#"s",#"z",431),
(#"r",#"r",437)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [27, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"d",431),
(#"f",#"z",431),
(#"e",#"e",443)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [21, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"o",431),
(#"q",#"z",431),
(#"p",#"p",441)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"d",431),
(#"f",#"z",431),
(#"e",#"e",442)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [28, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"m",431),
(#"o",#"z",431),
(#"n",#"n",444)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [31, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [34, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"k",431),
(#"m",#"z",431),
(#"l",#"l",447)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [35, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"s",431),
(#"u",#"z",431),
(#"t",#"t",449)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [23, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [30, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [24, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"q",431),
(#"s",#"z",431),
(#"r",#"r",460)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"m",431),
(#"o",#"z",431),
(#"n",#"n",454)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"b",431),
(#"d",#"z",431),
(#"c",#"c",455)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"s",431),
(#"u",#"z",431),
(#"t",#"t",456)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"h",431),
(#"j",#"z",431),
(#"i",#"i",457)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"n",431),
(#"p",#"z",431),
(#"o",#"o",458)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"m",431),
(#"o",#"z",431),
(#"n",#"n",459)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [26, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [20, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"r",431),
(#"t",#"z",431),
(#"s",#"s",464)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"c",431),
(#"e",#"z",431),
(#"d",#"d",463)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [25, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"d",431),
(#"f",#"z",431),
(#"e",#"e",465)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [32, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [33, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"d",431),
(#"f",#"z",431),
(#"e",#"e",468)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"b",#"z",431),
(#"a",#"a",469)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"j",431),
(#"l",#"z",431),
(#"k",#"k",470)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [22, 75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"q",431),
(#"s",#"z",431),
(#"r",#"r",472)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"b",#"z",431),
(#"a",#"a",473)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"x",431),
(#"z",#"z",431),
(#"y",#"y",474)], [75]), ([(#"0",#"9",431),
(#"A",#"Z",431),
(#"_",#"_",431),
(#"a",#"z",431)], [29, 75]), ([], [45]), ([], [47]), ([], [49]), ([], [40]), ([], [11])]
    fun mk yyins = let
        (* current start state *)
        val yyss = ref INITIAL
	fun YYBEGIN ss = (yyss := ss)
	(* current input stream *)
        val yystrm = ref yyins
	(* get one char of input *)
	val yygetc = yyInput.getc
	(* create yytext *)
	fun yymktext(strm) = yyInput.subtract (strm, !yystrm)
        open UserDeclarations
        fun lex 
(yyarg as ()) = let 
     fun continue() = let
            val yylastwasn = yyInput.lastWasNL (!yystrm)
            fun yystuck (yyNO_MATCH) = raise Fail "stuck state"
	      | yystuck (yyMATCH (strm, action, old)) = 
		  action (strm, old)
	    val yypos = yyInput.getpos (!yystrm)
	    val yygetlineNo = yyInput.getlineNo
	    fun yyactsToMatches (strm, [],	  oldMatches) = oldMatches
	      | yyactsToMatches (strm, act::acts, oldMatches) = 
		  yyMATCH (strm, act, yyactsToMatches (strm, acts, oldMatches))
	    fun yygo actTable = 
		(fn (~1, _, oldMatches) => yystuck oldMatches
		  | (curState, strm, oldMatches) => let
		      val (transitions, finals') = Vector.sub (yytable, curState)
		      val finals = List.map (fn i => Vector.sub (actTable, i)) finals'
		      fun tryfinal() = 
		            yystuck (yyactsToMatches (strm, finals, oldMatches))
		      fun find (c, []) = NONE
			| find (c, (c1, c2, s)::ts) = 
		            if c1 <= c andalso c <= c2 then SOME s
			    else find (c, ts)
		      in case yygetc strm
			  of SOME(c, strm') => 
			       (case find (c, transitions)
				 of NONE => tryfinal()
				  | SOME n => 
				      yygo actTable
					(n, strm', 
					 yyactsToMatches (strm, finals, oldMatches)))
			   | NONE => tryfinal()
		      end)
	    in 
let
fun yyAction0 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction1 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction2 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction3 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction4 (strm, lastMatch : yymatch) = (yystrm := strm;
      (lineNum := !lineNum + 1;
          linePos := yypos :: !linePos;
          continue ()))
fun yyAction5 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction6 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction7 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction8 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction9 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction10 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction11 (strm, lastMatch : yymatch) = (yystrm := strm;
      (YYBEGIN COMMENT; continue ()))
fun yyAction12 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction13 (strm, lastMatch : yymatch) = (yystrm := strm;
      (YYBEGIN INITIAL; continue ()))
fun yyAction14 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction15 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction16 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction17 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction18 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction19 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.WHILE (s_e yypos yytext))
      end
fun yyAction20 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.FOR (s_e yypos yytext))
      end
fun yyAction21 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.TO (s_e yypos yytext))
      end
fun yyAction22 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.BREAK (s_e yypos yytext))
      end
fun yyAction23 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.LET (s_e yypos yytext))
      end
fun yyAction24 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.IN (s_e yypos yytext))
      end
fun yyAction25 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.END (s_e yypos yytext))
      end
fun yyAction26 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.FUNCTION (s_e yypos yytext))
      end
fun yyAction27 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.VAR (s_e yypos yytext))
      end
fun yyAction28 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.TYPE (s_e yypos yytext))
      end
fun yyAction29 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.ARRAY (s_e yypos yytext))
      end
fun yyAction30 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.IF (s_e yypos yytext))
      end
fun yyAction31 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.THEN (s_e yypos yytext))
      end
fun yyAction32 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.ELSE (s_e yypos yytext))
      end
fun yyAction33 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.DO (s_e yypos yytext))
      end
fun yyAction34 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.OF (s_e yypos yytext))
      end
fun yyAction35 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.NIL (s_e yypos yytext))
      end
fun yyAction36 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction37 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction38 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction39 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction40 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.ASSIGN (s_e yypos yytext))
      end
fun yyAction41 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction42 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.OR (s_e yypos yytext))
      end
fun yyAction43 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.AND (s_e yypos yytext))
      end
fun yyAction44 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction45 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.GE (s_e yypos yytext))
      end
fun yyAction46 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.GT (s_e yypos yytext))
      end
fun yyAction47 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.LE (s_e yypos yytext))
      end
fun yyAction48 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.LT (s_e yypos yytext))
      end
fun yyAction49 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.NEQ (s_e yypos yytext))
      end
fun yyAction50 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.EQ (s_e yypos yytext))
      end
fun yyAction51 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction52 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.DIVIDE (s_e yypos yytext))
      end
fun yyAction53 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.TIMES (s_e yypos yytext))
      end
fun yyAction54 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.MINUS (s_e yypos yytext))
      end
fun yyAction55 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.PLUS (s_e yypos yytext))
      end
fun yyAction56 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.DOT (s_e yypos yytext))
      end
fun yyAction57 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction58 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction59 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction60 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.LBRACE (s_e yypos yytext))
      end
fun yyAction61 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.RBRACE (s_e yypos yytext))
      end
fun yyAction62 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.LBRACK (s_e yypos yytext))
      end
fun yyAction63 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.RBRACK (s_e yypos yytext))
      end
fun yyAction64 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.LPAREN (s_e yypos yytext))
      end
fun yyAction65 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.RPAREN (s_e yypos yytext))
      end
fun yyAction66 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction67 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction68 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction69 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.SEMICOLON (s_e yypos yytext))
      end
fun yyAction70 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.COLON (s_e yypos yytext))
      end
fun yyAction71 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm; (Tokens.COMMA (s_e yypos yytext))
      end
fun yyAction72 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction73 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction74 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction75 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm;
        (let val (s, e) = s_e yypos yytext
                                    in  Tokens.ID (yytext, s, e)
                                    end)
      end
fun yyAction76 (strm, lastMatch : yymatch) = (yystrm := strm; (continue ()))
fun yyAction77 (strm, lastMatch : yymatch) = let
      val yytext = yymktext(strm)
      in
        yystrm := strm;
        (ErrorMsg.error yypos ("illegal character " ^ yytext); 
        continue())
      end
val yyactTable = Vector.fromList([yyAction0, yyAction1, yyAction2, yyAction3,
  yyAction4, yyAction5, yyAction6, yyAction7, yyAction8, yyAction9, yyAction10,
  yyAction11, yyAction12, yyAction13, yyAction14, yyAction15, yyAction16,
  yyAction17, yyAction18, yyAction19, yyAction20, yyAction21, yyAction22,
  yyAction23, yyAction24, yyAction25, yyAction26, yyAction27, yyAction28,
  yyAction29, yyAction30, yyAction31, yyAction32, yyAction33, yyAction34,
  yyAction35, yyAction36, yyAction37, yyAction38, yyAction39, yyAction40,
  yyAction41, yyAction42, yyAction43, yyAction44, yyAction45, yyAction46,
  yyAction47, yyAction48, yyAction49, yyAction50, yyAction51, yyAction52,
  yyAction53, yyAction54, yyAction55, yyAction56, yyAction57, yyAction58,
  yyAction59, yyAction60, yyAction61, yyAction62, yyAction63, yyAction64,
  yyAction65, yyAction66, yyAction67, yyAction68, yyAction69, yyAction70,
  yyAction71, yyAction72, yyAction73, yyAction74, yyAction75, yyAction76,
  yyAction77])
in
  if yyInput.eof(!(yystrm))
    then UserDeclarations.eof(yyarg)
    else (case (!(yyss))
       of REM => yygo yyactTable (0, !(yystrm), yyNO_MATCH)
        | digit => yygo yyactTable (1, !(yystrm), yyNO_MATCH)
        | STRING => yygo yyactTable (1, !(yystrm), yyNO_MATCH)
        | COMMENT => yygo yyactTable (2, !(yystrm), yyNO_MATCH)
        | INITIAL => yygo yyactTable (3, !(yystrm), yyNO_MATCH)
      (* end case *))
end
            end
	  in 
            continue() 	  
	    handle IO.Io{cause, ...} => raise cause
          end
        in 
          lex 
        end
    in
    fun makeLexer yyinputN = mk (yyInput.mkStream yyinputN)
    end

  end
