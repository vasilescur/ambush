type pos = int
type lexresult = Tokens.token

val lineNum = ErrorMsg.lineNum
val linePos = ErrorMsg.linePos
val currentString = ""

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

%%
%s REM STRING COMMENT


digit = [0-9];
letter = [a-zA-Z];

%%


<REM>"===================================" => (continue ());
<REM>"=========== White Space ===========" => (continue ());
<REM>"===================================" => (continue ());


<REM>"Count and ignore newlines." => (continue ());
\n    => (lineNum := !lineNum + 1;
          linePos := yypos :: !linePos;
          continue ());


<REM>"Just ignore spaces or tabs." => (continue ());
" "|\t   => (continue ());

<REM>"===================================" => (continue ());
<REM>"============ Comments =============" => (continue ());
<REM>"===================================" => (continue ());

<REM>"Enter comment." => (continue ());
<INITIAL>"/*" => (YYBEGIN COMMENT; continue ());

<REM>"Exit comment." => (continue ());
<COMMENT>"*/" => (YYBEGIN INITIAL; continue ());

<REM>"Ignore symbols and reserved words in comments." => (continue ());
<COMMENT>.    => (continue ());

<REM>"===================================" => (continue ());
<REM>"========= Reserved Words ==========" => (continue ());
<REM>"===================================" => (continue ());

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


<REM>"===================================" => (continue ());
<REM>"============ Operators ============" => (continue ());
<REM>"===================================" => (continue ());

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



<REM>"===================================" => (continue ());
<REM>"======== Braces and Parens ========" => (continue ());
<REM>"===================================" => (continue ());

<INITIAL>"{" => (Tokens.LBRACE (s_e yypos yytext));
<INITIAL>"}" => (Tokens.RBRACE (s_e yypos yytext));
<INITIAL>"[" => (Tokens.LBRACK (s_e yypos yytext));
<INITIAL>"]" => (Tokens.RBRACK (s_e yypos yytext));
<INITIAL>"(" => (Tokens.LPAREN (s_e yypos yytext));
<INITIAL>")" => (Tokens.RPAREN (s_e yypos yytext));


<REM>"===================================" => (continue ());
<REM>"=========== Punctuation ===========" => (continue ());
<REM>"===================================" => (continue ());

<INITIAL>";" => (Tokens.SEMICOLON (s_e yypos yytext));
<INITIAL>":" => (Tokens.COLON (s_e yypos yytext));
<INITIAL>"," => (Tokens.COMMA (s_e yypos yytext));

<REM>"===================================" => (continue ());
<REM>"========== Built-in types =========" => (continue ());
<REM>"===================================" => (continue ());

<INITIAL>"\"" => ();

<INITIAL>{digit}+ => (Tokens.INT (s_e yypos yytext));


<REM>"===================================" => (continue ());
<REM>"=========== Identifiers ===========" => (continue ());
<REM>"===================================" => (continue ());

<INITIAL>{letter}[a-zA-Z0-9_]*  => (let val (s, e) = s_e yypos yytext
                                    in  Tokens.ID (yytext, s, e)
                                    end);


<REM>"For when lexing goes wrong." => (continue ());
.   => (ErrorMsg.error yypos ("illegal character " ^ yytext); 
        continue());