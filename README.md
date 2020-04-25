<p align="center">
  <img width="300" align="center" alt="logo-large" src="https://user-images.githubusercontent.com/10100323/73473240-6a6f0600-435a-11ea-95f7-57841d91c49e.png">
</p>

<p align="center">
  Compiler for Tiger programming language<br/>written in Standard ML for Duke <i>ECE/CS 553: Compiler Construction</i>.
</p>

### Group Members

- Jake Derry
- <strike>Ryan Piersma</strike>
- Radu Vasilescu

#### Why the name Ambush?

> A group of tigers is either called a "streak" or an "ambush."

<sub>Source: Archived copy of *Animal group names*. Zoological Society of San 
Diego. Archived from the original on July 4, 2013.</sub>

### Usage Instructions

To test the compiler, open a terminal in the main folder and run:

```bash
sml run.sml
```

In the resulting SML REPL, execute

```sml
runTest n;
```

To run the test case with the number `n`. To compile an arbitrary Tiger 
program, instead execute

```sml
Main.compile "testcases/myProgram";
```

(**NOTE:** Without the `.tig` extension)

#### Old Instructions: 

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

## Type Checking

Our type checker helps the user find typing issues within their program to
help debug their programs when the type checker fails. In addition, there are
some conditions when the type checker fails because of an internal issue. These
conditions are noted by raising an exception that causes the compiler to crash
and currently, these conditions are unreachable.

After type checking the entire program (which helps users find the issues within 
their programs), the rest of the compilation process does not continue.

## Intermediate Representation (IR)

The next stage is conversion to Intermediate Representation, a format in which
the code is represented as a set of trees consisting of basic operations. For 
example, the following Tiger code:

```sml
let var a := 7
    var b := 9
    var c := 3
in  c := a + b
end
```

Translates to the following IR (comments added for explanation):

```sml
(* Assign initial values to variables on stack *)
MOVE(MEM (BINOP (PLUS, TEMP tt25, CONST ~4)),
     CONST 7)
MOVE(MEM (BINOP (PLUS, TEMP tt25, CONST ~8)),
     CONST 9)
MOVE(MEM (BINOP (PLUS, TEMP tt25, CONST ~12)),
     CONST 3)

(* do c <- a + b, where (a, b, c) are on stack *)
MOVE(MEM (BINOP (PLUS, TEMP tt25, CONST ~12)),
     BINOP(PLUS, MEM (BINOP (PLUS, TEMP tt25, CONST ~4)),
                 MEM (BINOP (PLUS, TEMP tt25, CONST ~8))))
```

## Instruction Selection 
In order to produce MIPS assembly language instructions, the IR must be 
converted to instructions through the Instruction Selection process. 

For example, Instruction Selection produces the following output for the IR
above:

```mips
PROCEDURE L0
L0: 
L2:
addi t0, r0, 7
sw t0, ~4(t25)
addi t1, r0, 9
sw t1, ~8(t25)
addi t2, r0, 3
sw t2, ~12(t25)
lw t4, ~4(t25)
lw t5, ~8(t25)
add t3, t4, t5
sw t3, ~12(t25)
j L1
L1:
END L0
```
 

## Liveness Analysis

The liveness analysis stage first builds a control-flow graph of the program,
and then computes the "liveness" of each temp at every node in the graph. Then,
it generates an interference graph, where every node is a temp and every edge 
signifies that those temps are live at the same time.

Here is an example of a Liveness Analysis on the following Tiger program:

```sml
let var a := 0
in  while(a < 10) do a := a + 1; nil
end
```


Control-flow Graph:

![cfg](https://user-images.githubusercontent.com/10100323/79820219-bd54ca00-8359-11ea-9952-177c54baf053.png)



Liveness Results:

```
Node: nid = 0   liveIn:  , t25  liveOut: , t25  move:    N/A
Node: nid = 1   liveIn:  , t25  liveOut: , t1, t25      move:    N/A
Node: nid = 2   liveIn:  , t1, t25      liveOut: , t25  move:    N/A
Node: nid = 3   liveIn:  , t25  liveOut: , t25  move:    N/A
Node: nid = 4   liveIn:  , t25  liveOut: , t2, t25      move:    N/A
Node: nid = 5   liveIn:  , t2, t25      liveOut: , t2, t4, t25  move:    N/A
Node: nid = 6   liveIn:  , t2, t4, t25  liveOut: , t2, t4, t5, t25      move:    N/A
Node: nid = 7   liveIn:  , t2, t4, t5, t25      liveOut: , t2, t3, t25  move:    N/A
Node: nid = 8   liveIn:  , t2, t3, t25  liveOut: , t25  move:    N/A
Node: nid = 9   liveIn:         liveOut:        move:    N/A
Node: nid = 10  liveIn:         liveOut:        move:    N/A
Node: nid = 11  liveIn:  , t25  liveOut: , t25  move:    N/A
Node: nid = 12  liveIn:  , t25  liveOut: , t6, t25      move:    N/A
Node: nid = 13  liveIn:  , t6, t25      liveOut: , t0, t25      move:    t0 <- t6
Node: nid = 14  liveIn:  , t0, t25      liveOut: , t0, t8, t25  move:    N/A
Node: nid = 15  liveIn:  , t0, t8, t25  liveOut: , t0, t25      move:    N/A
Node: nid = 16  liveIn:  , t0, t25      liveOut: , t0, t9, t25  move:    N/A
Node: nid = 17  liveIn:  , t0, t9, t25  liveOut: , t25  move:    N/A
Node: nid = 18  liveIn:  , t25  liveOut: , t25  move:    N/A
Node: nid = 19  liveIn:         liveOut:        move:    N/A
```

Which then generates the interference graph:

![interference-graph](https://user-images.githubusercontent.com/10100323/79820223-c180e780-8359-11ea-80fb-b8e1de9e86f8.png)


## Register Allocation

The Register Allocation phase of the compiler applies a graph-coloring algorithm to the
interference graph in order to "color" (assign) temps to certain physical registers. The idea
is that multiple temps can be assigned to the same physical register, so long as they do not
interfere with one another (share an edge in the interference graph AKA are live at the same
time). 

In addition, we had to keep track of pre-allocated registers such as special machine registers
like the frame pointer, return address, and so on.

We have not implemented spilling or coalescing, meaning that for now, we can only handle
compiling Tiger programs that use a limited number of temps-- if they try to use too many
temps, we won't have room in the physical registers and are not yet able to spill to memory. 

One other improvement that we made during this stage is that instead of creating a series of
`MOVE`s to save and restore the caller-saved registers before and after a function call,
the compiler now saves those registers' values to local variables allocated within the
current frame, which saves a lot of register space and helps raise the limit to spilling. 

Here is an example of the register allocater at work. The following Tiger program:

```sml
let var a := 0
in  while(a < 10) do a := a + 1; nil
end
```

Compiles to the following MIPS assembly with correct physical registers allocated:

```mips
.text
    j    L0
.text
# PROCEDURE L0
L0: 
L5:
    addi $t1, $0, 0
    sw   $t1, -4($fp)
L2:
    addi $v0, $0, 1
    lw   $a0, -4($fp)
    addi $a1, $0, 10
    slt  $a0, $a0, $a1
    beq  $v0, $a0, L3
    b    L1
L1:
    j    L4
L3:
    lw   $t0, -4($fp)
    addi $a3, $t0, 1
    addi $a2, $a3, 0
    sw   $a2, -4($fp)
    j    L2
L4:
    
# END L0
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

-----

![Functional programming meme](https://pics.me.me/do-you-smoke-functional-very-time-programming-1s-more-effective-36314444.png)

-----

![Commit messages meme](https://pics.me.me/me-i-should-give-this-commit-a-proper-descriptive-message-58056481.png)

-----

>Do you want us to send the cocaine directly to your email? 
> -- Jake Derry, 2020, somehow contextually related to this project

-----

![image](https://user-images.githubusercontent.com/10100323/79821281-584ea380-835c-11ea-88fa-584e40e11d55.png)
