(*******************************************************************************
 * File:        tiger.lex
 * Authors:     Jake Derry, Radu Vasilescu
 * 
 * Description: Provides the ML-Lex configuration for the Tiger lexer.
 ******************************************************************************)

(* ===== Shortcuts ===== *)

type pos = int
(* type lexresult = Tokens.token *)

(* Shortcut function to calculate the start and end positions of a token *)
fun s_e pos text = (pos, pos + String.size text)



(* ===== Globals ===== *)

(* Efficiently count line numbers. *)
val lineNum = ErrorMsg.lineNum
val linePos = ErrorMsg.linePos

val inComment = ref false

fun err (p1, p2) = ErrorMsg.error p1



(* ===== String literals ===== *)

(* This value keeps track of the string literal being parsed so far. *)
val currentString = ref ""



(* ===== EOF Handler ===== *)

(* Deals with reaching the end of file. *)
fun eof () = 
  let val pos = hd (!linePos) 
  in  case (!currentString, !inComment)
        of ("", false) => Tokens.EOF (pos, pos)
         | ("", true)  => (ErrorMsg.error pos 
                                          ("Expected end of comment, \
                                          \ found EOF");
                           Tokens.EOF (pos, pos))
         | (_,  _)     => (ErrorMsg.error pos 
                                          ("Expected end of string, \
                                          \ found EOF");
                           Tokens.EOF (pos, pos))
  end




(* Added from textbook page 82: *)
type svalue = Tokens.svalue
type pos = int
type ('a, 'b) token = ('a, 'b) Tokens.token
type lexresult = (svalue, pos) token



(* If you're wondering why there's an unused "REM" state, 
   it's so we can use comments in the lexer definitions below
   the [double %]... It's a dirty hack but  *shrug*  *)

%%
%s REM STRING ESCAPE COMMENT;

letter = [a-zA-Z];

%header (functor TigerLexFun (structure Tokens: Tiger_TOKENS));

%%

<REM>"=======================================================" => (continue ());
<REM>"==================== White Space ======================" => (continue ());
<REM>"=======================================================" => (continue ());

<REM>"Count and ignore newlines." => (continue ());
  \n    => (lineNum := !lineNum + 1;
            linePos := yypos :: !linePos;
            continue ());

<REM>"Just ignore spaces or tabs." => (continue ());
  " "|\t|\r   => (continue ());


<REM>"=======================================================" => (continue ());
<REM>"===================== Comments ========================" => (continue ());
<REM>"=======================================================" => (continue ());

<REM>"Enter comment." => (continue ());
  <INITIAL>"/*" => (YYBEGIN COMMENT; inComment := true; continue ());

<REM>"Exit comment." => (continue ());
  <COMMENT>"*/" => (YYBEGIN INITIAL; inComment := false; continue ());

<REM>"Ignore symbols and reserved words in comments." => (continue ());
  <COMMENT>.    => (continue ());


<REM>"=======================================================" => (continue ());
<REM>"=================== Reserved Words ====================" => (continue ());
<REM>"=======================================================" => (continue ());

  <INITIAL>"while"    => (Tokens.WHILE (s_e yypos yytext));
  <INITIAL>"for"      => (Tokens.FOR (s_e yypos yytext));
  <INITIAL>"to"       => (Tokens.TO (s_e yypos yytext));
  <INITIAL>"break"    => (Tokens.BREAK (s_e yypos yytext));
  <INITIAL>"let"      => (Tokens.LET (s_e yypos yytext));
  <INITIAL>"in"       => (Tokens.IN (s_e yypos yytext));
  <INITIAL>"end"      => (Tokens.END (s_e yypos yytext));
  <INITIAL>"function" => (Tokens.FUNCTION (s_e yypos yytext));
  <INITIAL>"var"      => (Tokens.VAR (s_e yypos yytext));
  <INITIAL>"type"     => (Tokens.TYPE (s_e yypos yytext));
  <INITIAL>"array"    => (Tokens.ARRAY (s_e yypos yytext));
  <INITIAL>"if"       => (Tokens.IF (s_e yypos yytext));
  <INITIAL>"then"     => (Tokens.THEN (s_e yypos yytext));
  <INITIAL>"else"     => (Tokens.ELSE (s_e yypos yytext));
  <INITIAL>"do"       => (Tokens.DO (s_e yypos yytext));
  <INITIAL>"of"       => (Tokens.OF (s_e yypos yytext));
  <INITIAL>"nil"      => (Tokens.NIL (s_e yypos yytext));


<REM>"=======================================================" => (continue ());
<REM>"====================== Operators ======================" => (continue ());
<REM>"=======================================================" => (continue ());

<REM>"Assignment" => (continue ());
  <INITIAL>":="         => (Tokens.ASSIGN (s_e yypos yytext));

<REM>"Boolean" => (continue ());
  <INITIAL>"|"       => (Tokens.OR (s_e yypos yytext));
  <INITIAL>"&"       => (Tokens.AND (s_e yypos yytext));

<REM>"Equality" => (continue ());
  <INITIAL>">="       => (Tokens.GE (s_e yypos yytext));
  <INITIAL>">"        => (Tokens.GT (s_e yypos yytext));
  <INITIAL>"<="       => (Tokens.LE (s_e yypos yytext));
  <INITIAL>"<"        => (Tokens.LT (s_e yypos yytext));
  <INITIAL>"<>"       => (Tokens.NEQ (s_e yypos yytext));
  <INITIAL>"="        => (Tokens.EQ (s_e yypos yytext));

<REM>"Arithmetic" => (continue ());
  <INITIAL>"/"          => (Tokens.DIVIDE (s_e yypos yytext));
  <INITIAL>"*"          => (Tokens.TIMES (s_e yypos yytext));
  <INITIAL>"-"          => (Tokens.MINUS (s_e yypos yytext));
  <INITIAL>"+"          => (Tokens.PLUS (s_e yypos yytext));
  <INITIAL>"."          => (Tokens.DOT (s_e yypos yytext));


<REM>"=======================================================" => (continue ());
<REM>"================== Braces and Parens ==================" => (continue ());
<REM>"=======================================================" => (continue ());

  <INITIAL>"{" => (Tokens.LBRACE (s_e yypos yytext));
  <INITIAL>"}" => (Tokens.RBRACE (s_e yypos yytext));
  <INITIAL>"[" => (Tokens.LBRACK (s_e yypos yytext));
  <INITIAL>"]" => (Tokens.RBRACK (s_e yypos yytext));
  <INITIAL>"(" => (Tokens.LPAREN (s_e yypos yytext));
  <INITIAL>")" => (Tokens.RPAREN (s_e yypos yytext));


<REM>"=======================================================" => (continue ());
<REM>"===================== Punctuation =====================" => (continue ());
<REM>"=======================================================" => (continue ());

  <INITIAL>";" => (Tokens.SEMICOLON (s_e yypos yytext));
  <INITIAL>":" => (Tokens.COLON (s_e yypos yytext));
  <INITIAL>"," => (Tokens.COMMA (s_e yypos yytext));


<REM>"=======================================================" => (continue ());
<REM>"==================== Built-in types ===================" => (continue ());
<REM>"=======================================================" => (continue ());


<REM>"Parse an integer value from an int literal" => (continue ());
  <INITIAL>[0-9]+ => (let val (s, e) = s_e yypos yytext
                        in  Tokens.INT (valOf (Int.fromString yytext), s, e)
                        end);

<REM>"When we see a quote in INITIAL, begin a string literal." => (continue ());
  <INITIAL>"\"" => (YYBEGIN STRING; continue ());


<REM>"When we see anything other than a quote inside a string" => (continue ());
<REM>"we append it to the currently being built string var" => (continue ());
  <STRING>[^\\\"]+ => (currentString := !currentString ^ yytext;
                      continue ());

<REM>"Enter the escape state where we recognize escape \" " => (continue ());
<REM>"sequences." => (continue ());
  <STRING>\\ => (YYBEGIN ESCAPE; continue ());

<REM>"Add escape characters and return to the string state." => (continue ());
  <ESCAPE>n  => (currentString := !currentString ^ "\n"; 
                YYBEGIN STRING; 
                continue ());
  <ESCAPE>t  => (currentString := !currentString ^ "\t"; 
                YYBEGIN STRING; 
                continue ());

  <ESCAPE>[0-9][0-9][0-9] => (let val newChar = (Char.toString 
                                                  (chr 
                                                    (valOf 
                                                      (Int.fromString yytext))))
                              in currentString := !currentString ^ newChar
                              end; YYBEGIN STRING; continue());

  <ESCAPE>"\"" => (currentString := !currentString ^ "\"";
                  YYBEGIN STRING;
                  continue ());
                  
  <ESCAPE>\\ => (currentString := !currentString ^ "\\";
                YYBEGIN STRING;
                continue ());

  <ESCAPE>[ \t\n\f\r]+\\ => (YYBEGIN STRING; continue ());

  <ESCAPE>"^"[@A-Z\[\\\]^_\?]  => (let val ctrlChr = (String.str 
                                                       (valOf 
                                                         (Char.fromString 
                                                           ("\\" ^ yytext))))
                                   in  currentString := !currentString ^ ctrlChr
                                   end; YYBEGIN STRING; continue ());

<REM>"When we see a quote in STRING, end a string literal" => (continue ());
<REM>"and create the string token" => (continue ());
  <STRING>"\"" => (YYBEGIN INITIAL;
                  let val (s, e) = s_e yypos yytext;
                      val text   = !currentString
                  in  currentString := "";
                      Tokens.STRING (text, e - (String.size (text)), e)
                  end);


<REM>"=======================================================" => (continue ());
<REM>"==================== Identifiers ======================" => (continue ());
<REM>"=======================================================" => (continue ());

  <INITIAL>{letter}[a-zA-Z0-9_]*  => (let val (s, e) = s_e yypos yytext
                                      in  Tokens.ID (yytext, s, e)
                                      end);

<REM>"=======================================================" => (continue ());
<REM>"================= Last chance errors ==================" => (continue ());
<REM>"=======================================================" => (continue ());

<REM>"For when lexing goes wrong." => (continue ());
  . => (ErrorMsg.error yypos ("illegal character " ^ yytext
                              ^ "(ASCII "
                              ^ (Int.toString
                                  (Char.ord (hd (String.explode yytext)))) 
                              ^ ")"); 
        continue ());