<p align="center">
  <img width="300" align="center" alt="logo-large" src="https://user-images.githubusercontent.com/10100323/73473240-6a6f0600-435a-11ea-95f7-57841d91c49e.png">
</p>

<p align="center">
  Compiler for Tiger programming language<br/>written in Standard ML for Duke <i>ECE/CS 553: Compiler Construction</i>.
</p>

### Group Members

- Jake Derry
- Ryan Piersma
- Radu Vasilescu

#### Why the name Ambush?

> A group of tigers is either called a "streak" or an "ambush."

<sub>Source: Archived copy of *Animal group names*. Zoological Society of San 
Diego. Archived from the original on July 4, 2013.</sub>

### Usage Instructions

To use the lexer, first open an `sml` REPL in the root folder of this 
repository. Then, run the following command to compile the project:

```sml
CM.make "sources.cm";
```

In order to test the parser, use the following command, where `myFile.tig` is 
a relative path to the Tiger input source file:

```sml
Parse.parse "myFile.tig";
```

### Project Structure and Files

#### General

- `errormsg.sml` provides a signature for creating helpful error messages
- `sml-style-guide.pdf` outlines a style convention for writing SML code
- `sources.cm` is the "Makefile" for the Compilation Manager
- The `testcases/` folder contains several Tiger example programs
- The `.cm/` folder contains Compilation Manager auto-generated files
- `.gitignore` is used by Git to exclude files

#### Lexer

- `tiger.lex` is our ML-Lex definition file for Tiger
- `tiger.lex.sml.ours` is the auto-generated lexer from our own `tiger.lex`
- `tiger.lex.sml` is the auto-generated lexer from the TEXTBOOK author
- `tokens.sig` and `tokens.sml` are the starter code files for tokens and 
  signatures. **They are unused** currently, in favor of the auto-generated
  tokens and signatures created by ML-Yacc.

#### Parser

- `tiger.grm` is our ML-Yacc grammar definition for Tiger
- `tiger.grm.desc` is an auto-generated file from ML-Yacc
- `tiger.grm.sig` contains auto-generated code from ML-Yacc
- `tiger.grm.sml` contains the auto-generated parser by ML-Yacc


## Lexer

The lexer is responsible for turning source code into tokens. 

### Comments

Ambush handles comments by creating a `COMMENT` state which represents being 
inside a comment. There is alao a variable called `inComment` which keeps track 
of whether the lexer is currently inside a `COMMENT` state. 

These are the relevant few rules:

```sml
val inComment : bool ref 
```

```sml
<REM>"Enter comment." => (continue ());
  <INITIAL>"/*" => (YYBEGIN COMMENT; inComment := true; continue ());

<REM>"Exit comment." => (continue ());
  <COMMENT>"*/" => (YYBEGIN INITIAL; inComment := false; continue ());

<REM>"Ignore symbols and reserved words in comments." => (continue ());
  <COMMENT>.    => (continue ());
```

The `inComment` variable is used to detect comments that are left unclosed at
the end of the file (see *Error Handling* section for more details).

### Strings

We handle strings by using two additional states: the `STRING` state which
represents being inside a string and the `ESCAPE` state which represents being
inside an escape character.

After entry into the `STRING` state, all characters reached are stored in a
`currentString` variable. When existing the `STRING` state, the `currentString`
is used to create the new token which represents a strin.

Additionally, we deal with escape characters after entering the `ESCAPE` 
state, adding the appropriate escape character to the `currentString` variable 
after identifying the escape character with the character(s) following the 
backslash.

### Error Handling

If the lexer encounters an invalid character anywhere in any state (that is to 
say, any portion of code not already matched by a different rule), it presents
an `ErrorMsg`, and does not emit a token for that portion of code:

```sml
. => (ErrorMsg.error yypos 
                     ("illegal character " ^ yytext ^ "(ASCII "
                     ^ (Int.toString (Char.ord (hd (String.explode yytext)))) 
                     ^ ")"); 
      continue ());
```

### EOF handling

At `EOF` (End-Of-File), we detect any unfinished strings or comments in the 
`eof` function. If ending in one of these non-accepting states, we raise an 
error message that indicates whether the program was ended with an unfinished 
string or comment. We always emit the `EOF` token whether an error was reported 
or not:

```sml
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
```

## Parser

Implemented a parser that takes in a set of tokens and outputs an AST.

The parser currently has neither shift/reduce nor reduce/reduce conflicts, and seems
to parse the Tiger test cases correctly. For example, the following Tiger program:

```sml
/* an array type and an array variable */
let
    type  arrtype = array of int
    var arr1:arrtype := arrtype [10] of 0
in
  arr1
end
```

Parses to the tree:

```sml
LetExp([
 VarDec(arr1,true,SOME(arrtype),
  ArrayExp(arrtype,
   IntExp(10),
   IntExp(0))),
 TypeDec[
  (arrtype,
   ArrayTy(int))]],
 VarExp(
  SimpleVar(arr1)))
```

## Extra Credit Features

### Musical Tiger

We had an idea to implement a musical compiler that produces sound output
relevant to each stage of the compilation process as it runs. Upon realizing
the sheer stupidity of this idea, it has been quarantined to its own branch.
To play with this feature, checkout the branch `musical` and see its version
of the `README.md`.

No guarantees are made that the `musical` branch will be maintained or updated
past the state that it was as of 2020-02-27 at 12:15 PM. As of now, it should 
not be considered part of our official submission.

## Future Compiler Features (Extra Credit)

 - [ ] SML Formatter
    - [ ] Tiger formatter
    - [ ] Tiger VS Code extension
    - [ ] Coloring formatting for (let, in, end)
 - [ ] Garbage collector
 - [ ] Rich error reporting
 - [ ] Tiger REPL
 - [ ] More/better Tiger libraries
    - [ ] Math library
    - [ ] Data structures library
 - [ ] Optimized compiliation for different processors
 - [ ] Tiger web framework (integration)? See [`SML on Stilts`](https://github.com/j4cbo/stilts)...

<br/> <br/>

## Dank Memes For Your Consideration and Enjoyment

![Binary tree pants meme](https://i.kym-cdn.com/photos/images/original/001/272/773/6dd.jpg)

![Functional programming meme](https://pics.me.me/do-you-smoke-functional-very-time-programming-1s-more-effective-36314444.png)

![Commit messages meme](https://pics.me.me/me-i-should-give-this-commit-a-proper-descriptive-message-58056481.png)

>Do you want us to send the cocaine directly to your email? 
> -- Jake Derry, 2020, somehow contextually related to this project
