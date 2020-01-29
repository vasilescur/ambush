signature Tiger_TOKENS =
sig
  type linenum (* = int *)
  type token

  (* Reserved words *)
  val WHILE    : linenum * linenum -> token
  val FOR      : linenum * linenum -> token
  val TO       : linenum * linenum -> token
  val BREAK    : linenum * linenum -> token
  val LET      : linenum * linenum -> token
  val IN       : linenum * linenum -> token
  val END      : linenum * linenum -> token
  val FUNCTION : linenum * linenum -> token
  val VAR      : linenum * linenum -> token
  val TYPE     : linenum * linenum -> token
  val ARRAY    : linenum * linenum -> token
  val IF       : linenum * linenum -> token
  val THEN     : linenum * linenum -> token
  val ELSE     : linenum * linenum -> token
  val DO       : linenum * linenum -> token
  val OF       : linenum * linenum -> token
  val NIL      : linenum * linenum -> token
  
  (* Assignment operator *)
  val ASSIGN : linenum * linenum -> token
  
  (* Boolean operators *)
  val OR  : linenum * linenum -> token
  val AND : linenum * linenum -> token
  
  (* Equality operators *)
  val GE  : linenum * linenum -> token
  val GT  : linenum * linenum -> token
  val LE  : linenum * linenum -> token
  val LT  : linenum * linenum -> token
  val NEQ : linenum * linenum -> token
  val EQ  : linenum * linenum -> token

  (* Arithmetic operators *)
  val DIVIDE : linenum * linenum -> token
  val TIMES  : linenum * linenum -> token
  val MINUS  : linenum * linenum -> token
  val PLUS   : linenum * linenum -> token
  val DOT    : linenum * linenum -> token

  (* Braces and parens *)
  val RBRACE : linenum * linenum -> token
  val LBRACE : linenum * linenum -> token
  val RBRACK : linenum * linenum -> token
  val LBRACK : linenum * linenum -> token
  val RPAREN : linenum * linenum -> token
  val LPAREN : linenum * linenum -> token

  (* Punctuation *)
  val SEMICOLON : linenum * linenum -> token
  val COLON     : linenum * linenum -> token
  val COMMA     : linenum * linenum -> token

  (* Built-in types *)
  val STRING : (string) * linenum * linenum -> token
  val INT    : (int) * linenum * linenum -> token

  (* Identifier *)
  val ID : (string) * linenum * linenum -> token

  (* End of file *)
  val EOF : linenum * linenum -> token
end



(* 

while, for, to, break, let, in, end, function, var, 
type, array, if, then, else, do, of, nil

*)

