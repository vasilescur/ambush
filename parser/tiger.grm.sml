functor TigerLrValsFun(structure Token : TOKEN)
 : sig structure ParserData : PARSER_DATA
       structure Tokens : Tiger_TOKENS
   end
 = 
struct
structure ParserData=
struct
structure Header = 
struct
structure A = Absyn;

fun a_IGNORE_ME x = 3;
(*Ignore the above definition, it is just there to fix syntax highlighting :P *)

(*******************************************************************************
 * File:        tiger.grm
 * Authors:     Jake Derry, Radu Vasilescu, Ryan Piersma
 *
 * Description: Grammar definition file for ML-Yacc.
 *              Tiger Reference: https://www.lrde.epita.fr/~tiger/tiger.html
 ******************************************************************************)


end
structure LrTable = Token.LrTable
structure Token = Token
local open LrTable in 
val table=let val actionRows =
"\
\\001\000\001\000\000\000\000\000\
\\001\000\001\000\186\000\005\000\186\000\007\000\186\000\008\000\051\000\
\\009\000\186\000\010\000\050\000\011\000\186\000\012\000\049\000\
\\013\000\186\000\014\000\174\000\015\000\186\000\016\000\186\000\
\\018\000\186\000\019\000\186\000\020\000\186\000\021\000\186\000\
\\022\000\186\000\023\000\186\000\024\000\186\000\025\000\186\000\
\\026\000\186\000\027\000\186\000\028\000\174\000\031\000\186\000\
\\032\000\186\000\035\000\186\000\036\000\186\000\038\000\186\000\
\\039\000\186\000\042\000\048\000\043\000\186\000\044\000\186\000\
\\045\000\186\000\000\000\
\\001\000\001\000\187\000\005\000\187\000\007\000\187\000\009\000\187\000\
\\010\000\017\000\011\000\187\000\013\000\187\000\014\000\175\000\
\\015\000\187\000\016\000\187\000\018\000\187\000\019\000\187\000\
\\020\000\187\000\021\000\187\000\022\000\187\000\023\000\187\000\
\\024\000\187\000\025\000\187\000\026\000\187\000\027\000\187\000\
\\028\000\175\000\031\000\187\000\032\000\187\000\035\000\187\000\
\\036\000\187\000\038\000\187\000\039\000\187\000\043\000\187\000\
\\044\000\187\000\045\000\187\000\000\000\
\\001\000\001\000\211\000\005\000\211\000\007\000\211\000\009\000\211\000\
\\011\000\211\000\013\000\211\000\015\000\031\000\016\000\030\000\
\\018\000\029\000\019\000\028\000\026\000\211\000\027\000\211\000\
\\031\000\211\000\032\000\211\000\035\000\211\000\036\000\211\000\
\\038\000\211\000\039\000\211\000\043\000\211\000\044\000\211\000\
\\045\000\211\000\000\000\
\\001\000\001\000\212\000\005\000\212\000\007\000\212\000\009\000\212\000\
\\011\000\212\000\013\000\212\000\015\000\031\000\016\000\030\000\
\\018\000\029\000\019\000\028\000\026\000\212\000\027\000\212\000\
\\031\000\212\000\032\000\212\000\035\000\212\000\036\000\212\000\
\\038\000\212\000\039\000\212\000\043\000\212\000\044\000\212\000\
\\045\000\212\000\000\000\
\\001\000\001\000\213\000\005\000\213\000\007\000\213\000\009\000\213\000\
\\011\000\213\000\013\000\213\000\015\000\031\000\016\000\030\000\
\\018\000\029\000\019\000\028\000\026\000\213\000\027\000\213\000\
\\031\000\213\000\032\000\213\000\035\000\213\000\036\000\213\000\
\\038\000\213\000\039\000\213\000\043\000\213\000\044\000\213\000\
\\045\000\213\000\000\000\
\\001\000\001\000\214\000\005\000\214\000\007\000\214\000\009\000\214\000\
\\011\000\214\000\013\000\214\000\015\000\031\000\016\000\030\000\
\\018\000\029\000\019\000\028\000\026\000\214\000\027\000\214\000\
\\031\000\214\000\032\000\214\000\035\000\214\000\036\000\214\000\
\\038\000\214\000\039\000\214\000\043\000\214\000\044\000\214\000\
\\045\000\214\000\000\000\
\\001\000\001\000\215\000\005\000\215\000\007\000\215\000\009\000\215\000\
\\011\000\215\000\013\000\215\000\015\000\031\000\016\000\030\000\
\\018\000\029\000\019\000\028\000\026\000\215\000\027\000\215\000\
\\031\000\215\000\032\000\215\000\035\000\215\000\036\000\215\000\
\\038\000\215\000\039\000\215\000\043\000\215\000\044\000\215\000\
\\045\000\215\000\000\000\
\\001\000\001\000\216\000\005\000\216\000\007\000\216\000\009\000\216\000\
\\011\000\216\000\013\000\216\000\015\000\031\000\016\000\030\000\
\\018\000\029\000\019\000\028\000\026\000\216\000\027\000\216\000\
\\031\000\216\000\032\000\216\000\035\000\216\000\036\000\216\000\
\\038\000\216\000\039\000\216\000\043\000\216\000\044\000\216\000\
\\045\000\216\000\000\000\
\\001\000\002\000\016\000\003\000\015\000\004\000\014\000\008\000\013\000\
\\009\000\047\000\016\000\012\000\030\000\011\000\033\000\010\000\
\\034\000\009\000\037\000\008\000\041\000\007\000\042\000\006\000\000\000\
\\001\000\002\000\016\000\003\000\015\000\004\000\014\000\008\000\013\000\
\\016\000\012\000\030\000\011\000\033\000\010\000\034\000\009\000\
\\037\000\008\000\041\000\007\000\042\000\006\000\000\000\
\\001\000\002\000\042\000\000\000\
\\001\000\002\000\054\000\000\000\
\\001\000\002\000\071\000\000\000\
\\001\000\002\000\072\000\000\000\
\\001\000\002\000\073\000\000\000\
\\001\000\002\000\081\000\000\000\
\\001\000\002\000\107\000\012\000\106\000\029\000\105\000\000\000\
\\001\000\002\000\109\000\000\000\
\\001\000\002\000\112\000\000\000\
\\001\000\002\000\135\000\000\000\
\\001\000\002\000\141\000\000\000\
\\001\000\002\000\145\000\000\000\
\\001\000\006\000\089\000\028\000\088\000\000\000\
\\001\000\006\000\128\000\000\000\
\\001\000\006\000\139\000\020\000\138\000\000\000\
\\001\000\007\000\079\000\009\000\078\000\015\000\031\000\016\000\030\000\
\\018\000\029\000\019\000\028\000\020\000\027\000\021\000\026\000\
\\022\000\025\000\023\000\024\000\024\000\023\000\025\000\022\000\
\\026\000\021\000\027\000\020\000\000\000\
\\001\000\008\000\090\000\000\000\
\\001\000\009\000\094\000\000\000\
\\001\000\009\000\100\000\000\000\
\\001\000\009\000\125\000\000\000\
\\001\000\011\000\085\000\015\000\031\000\016\000\030\000\018\000\029\000\
\\019\000\028\000\020\000\027\000\021\000\026\000\022\000\025\000\
\\023\000\024\000\024\000\023\000\025\000\022\000\026\000\021\000\
\\027\000\020\000\000\000\
\\001\000\011\000\099\000\015\000\031\000\016\000\030\000\018\000\029\000\
\\019\000\028\000\020\000\027\000\021\000\026\000\022\000\025\000\
\\023\000\024\000\024\000\023\000\025\000\022\000\026\000\021\000\
\\027\000\020\000\000\000\
\\001\000\013\000\117\000\000\000\
\\001\000\013\000\136\000\000\000\
\\001\000\014\000\019\000\028\000\018\000\000\000\
\\001\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\
\\031\000\076\000\000\000\
\\001\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\
\\035\000\113\000\000\000\
\\001\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\
\\036\000\075\000\000\000\
\\001\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\
\\036\000\142\000\000\000\
\\001\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\
\\039\000\103\000\000\000\
\\001\000\020\000\087\000\000\000\
\\001\000\020\000\098\000\000\000\
\\001\000\020\000\148\000\000\000\
\\001\000\028\000\074\000\000\000\
\\001\000\028\000\124\000\000\000\
\\001\000\038\000\070\000\000\000\
\\001\000\040\000\122\000\000\000\
\\151\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\152\000\043\000\041\000\044\000\040\000\045\000\039\000\000\000\
\\153\000\000\000\
\\154\000\000\000\
\\155\000\045\000\039\000\000\000\
\\156\000\043\000\041\000\000\000\
\\157\000\000\000\
\\158\000\000\000\
\\159\000\000\000\
\\160\000\000\000\
\\161\000\000\000\
\\162\000\000\000\
\\163\000\000\000\
\\164\000\002\000\112\000\000\000\
\\165\000\000\000\
\\166\000\005\000\127\000\000\000\
\\167\000\000\000\
\\168\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\169\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\170\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\171\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\172\000\000\000\
\\173\000\000\000\
\\176\000\000\000\
\\177\000\040\000\120\000\000\000\
\\178\000\000\000\
\\179\000\002\000\016\000\003\000\015\000\004\000\014\000\008\000\013\000\
\\016\000\012\000\030\000\011\000\033\000\010\000\034\000\009\000\
\\037\000\008\000\041\000\007\000\042\000\006\000\000\000\
\\180\000\000\000\
\\181\000\005\000\102\000\015\000\031\000\016\000\030\000\018\000\029\000\
\\019\000\028\000\020\000\027\000\021\000\026\000\022\000\025\000\
\\023\000\024\000\024\000\023\000\025\000\022\000\026\000\021\000\
\\027\000\020\000\000\000\
\\182\000\000\000\
\\183\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\184\000\005\000\097\000\000\000\
\\185\000\000\000\
\\188\000\000\000\
\\189\000\000\000\
\\190\000\000\000\
\\191\000\000\000\
\\192\000\018\000\029\000\019\000\028\000\000\000\
\\193\000\018\000\029\000\019\000\028\000\000\000\
\\194\000\000\000\
\\195\000\000\000\
\\196\000\000\000\
\\197\000\000\000\
\\198\000\000\000\
\\199\000\000\000\
\\200\000\000\000\
\\201\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\202\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\203\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\204\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\
\\032\000\114\000\000\000\
\\205\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\206\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\026\000\021\000\027\000\020\000\000\000\
\\207\000\000\000\
\\208\000\000\000\
\\209\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\000\000\
\\210\000\015\000\031\000\016\000\030\000\018\000\029\000\019\000\028\000\
\\020\000\027\000\021\000\026\000\022\000\025\000\023\000\024\000\
\\024\000\023\000\025\000\022\000\000\000\
\\217\000\000\000\
\\218\000\000\000\
\\219\000\000\000\
\\220\000\007\000\116\000\015\000\031\000\016\000\030\000\018\000\029\000\
\\019\000\028\000\020\000\027\000\021\000\026\000\022\000\025\000\
\\023\000\024\000\024\000\023\000\025\000\022\000\026\000\021\000\
\\027\000\020\000\000\000\
\"
val actionRowNumbers =
"\010\000\002\000\035\000\048\000\
\\081\000\100\000\049\000\011\000\
\\010\000\010\000\010\000\009\000\
\\083\000\082\000\001\000\010\000\
\\010\000\012\000\010\000\010\000\
\\010\000\010\000\010\000\010\000\
\\010\000\010\000\010\000\010\000\
\\010\000\010\000\053\000\069\000\
\\051\000\052\000\054\000\049\000\
\\046\000\013\000\014\000\015\000\
\\044\000\038\000\036\000\084\000\
\\026\000\091\000\093\000\016\000\
\\010\000\074\000\031\000\095\000\
\\071\000\103\000\102\000\006\000\
\\008\000\005\000\007\000\004\000\
\\003\000\087\000\088\000\086\000\
\\085\000\070\000\055\000\050\000\
\\010\000\041\000\023\000\027\000\
\\010\000\010\000\010\000\028\000\
\\090\000\010\000\079\000\042\000\
\\032\000\029\000\076\000\073\000\
\\040\000\017\000\010\000\018\000\
\\061\000\037\000\098\000\097\000\
\\104\000\107\000\033\000\016\000\
\\010\000\072\000\089\000\075\000\
\\010\000\101\000\056\000\047\000\
\\061\000\057\000\065\000\045\000\
\\030\000\063\000\024\000\010\000\
\\010\000\105\000\010\000\092\000\
\\079\000\078\000\010\000\076\000\
\\020\000\034\000\010\000\025\000\
\\062\000\019\000\021\000\039\000\
\\096\000\107\000\080\000\094\000\
\\077\000\059\000\058\000\066\000\
\\010\000\022\000\063\000\060\000\
\\010\000\106\000\067\000\043\000\
\\064\000\099\000\010\000\068\000\
\\000\000"
val gotoT =
"\
\\001\000\148\000\002\000\003\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\005\000\036\000\008\000\035\000\010\000\034\000\011\000\033\000\
\\012\000\032\000\013\000\031\000\014\000\030\000\000\000\
\\000\000\
\\002\000\041\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\042\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\043\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\044\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\002\000\050\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\051\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\002\000\053\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\054\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\055\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\056\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\057\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\058\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\059\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\060\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\061\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\062\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\063\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\064\000\003\000\002\000\004\000\001\000\000\000\
\\013\000\065\000\000\000\
\\000\000\
\\000\000\
\\010\000\066\000\000\000\
\\000\000\
\\005\000\067\000\008\000\035\000\010\000\034\000\011\000\033\000\
\\012\000\032\000\013\000\031\000\014\000\030\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\018\000\075\000\000\000\
\\000\000\
\\000\000\
\\022\000\078\000\000\000\
\\002\000\080\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\082\000\003\000\002\000\004\000\001\000\020\000\081\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\002\000\084\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\002\000\089\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\090\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\091\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\000\000\
\\002\000\093\000\003\000\002\000\004\000\001\000\000\000\
\\023\000\094\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\021\000\099\000\000\000\
\\000\000\
\\000\000\
\\009\000\102\000\000\000\
\\002\000\106\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\015\000\109\000\016\000\108\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\019\000\113\000\000\000\
\\000\000\
\\022\000\116\000\000\000\
\\002\000\117\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\002\000\119\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\015\000\109\000\016\000\121\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\017\000\124\000\000\000\
\\000\000\
\\002\000\127\000\003\000\002\000\004\000\001\000\000\000\
\\002\000\128\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\002\000\129\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\023\000\130\000\000\000\
\\000\000\
\\002\000\131\000\003\000\002\000\004\000\001\000\000\000\
\\021\000\132\000\000\000\
\\000\000\
\\000\000\
\\002\000\135\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\000\000\
\\015\000\138\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\019\000\141\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\002\000\142\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\017\000\144\000\000\000\
\\000\000\
\\002\000\145\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\000\000\
\\002\000\147\000\003\000\002\000\004\000\001\000\000\000\
\\000\000\
\\000\000\
\"
val numstates = 149
val numrules = 70
val s = ref "" and index = ref 0
val string_to_int = fn () => 
let val i = !index
in index := i+2; Char.ord(String.sub(!s,i)) + Char.ord(String.sub(!s,i+1)) * 256
end
val string_to_list = fn s' =>
    let val len = String.size s'
        fun f () =
           if !index < len then string_to_int() :: f()
           else nil
   in index := 0; s := s'; f ()
   end
val string_to_pairlist = fn (conv_key,conv_entry) =>
     let fun f () =
         case string_to_int()
         of 0 => EMPTY
          | n => PAIR(conv_key (n-1),conv_entry (string_to_int()),f())
     in f
     end
val string_to_pairlist_default = fn (conv_key,conv_entry) =>
    let val conv_row = string_to_pairlist(conv_key,conv_entry)
    in fn () =>
       let val default = conv_entry(string_to_int())
           val row = conv_row()
       in (row,default)
       end
   end
val string_to_table = fn (convert_row,s') =>
    let val len = String.size s'
        fun f ()=
           if !index < len then convert_row() :: f()
           else nil
     in (s := s'; index := 0; f ())
     end
local
  val memo = Array.array(numstates+numrules,ERROR)
  val _ =let fun g i=(Array.update(memo,i,REDUCE(i-numstates)); g(i+1))
       fun f i =
            if i=numstates then g i
            else (Array.update(memo,i,SHIFT (STATE i)); f (i+1))
          in f 0 handle General.Subscript => ()
          end
in
val entry_to_action = fn 0 => ACCEPT | 1 => ERROR | j => Array.sub(memo,(j-2))
end
val gotoT=Array.fromList(string_to_table(string_to_pairlist(NT,STATE),gotoT))
val actionRows=string_to_table(string_to_pairlist_default(T,entry_to_action),actionRows)
val actionRowNumbers = string_to_list actionRowNumbers
val actionT = let val actionRowLookUp=
let val a=Array.fromList(actionRows) in fn i=>Array.sub(a,i) end
in Array.fromList(List.map actionRowLookUp actionRowNumbers)
end
in LrTable.mkLrTable {actions=actionT,gotos=gotoT,numRules=numrules,
numStates=numstates,initialState=STATE 0}
end
end
local open Header in
type pos = int
type arg = unit
structure MlyValue = 
struct
datatype svalue = VOID | ntVOID of unit ->  unit
 | STRING of unit ->  (string) | INT of unit ->  (int)
 | ID of unit ->  (string)
 | record_tail of unit ->  ( ( A.symbol * A.exp * pos )  list)
 | record_field of unit ->  ( ( A.symbol * A.exp * pos ) )
 | arguments_tail of unit ->  (A.exp list)
 | arguments of unit ->  (A.exp list)
 | exp_can_be_empty of unit ->  ( ( A.exp * pos )  list)
 | exp_tail of unit ->  ( ( A.exp * pos )  list)
 | tyfields_tail of unit ->  (A.field list)
 | tyfields of unit ->  (A.field list) | tyfield of unit ->  (A.field)
 | fundecs of unit ->  (A.fundec list) | fundec of unit ->  (A.fundec)
 | vardec of unit ->  (A.vardec) | tydecs of unit ->  (A.tydec list)
 | tydec of unit ->  (A.tydec) | ty of unit ->  (A.ty)
 | dec of unit ->  (A.dec) | not_tydec of unit ->  (A.dec list)
 | not_fundec of unit ->  (A.dec list) | decs of unit ->  (A.dec list)
 | lval_not_id of unit ->  (A.var) | lval of unit ->  (A.var)
 | exp of unit ->  (A.exp) | program of unit ->  (A.exp)
end
type svalue = MlyValue.svalue
type result = A.exp
end
structure EC=
struct
open LrTable
infix 5 $$
fun x $$ y = y::x
val is_keyword =
fn (T 32) => true | (T 33) => true | (T 34) => true | (T 40) => true
 | (T 36) => true | (T 37) => true | (T 38) => true | (T 42) => true
 | (T 43) => true | (T 44) => true | (T 28) => true | (T 29) => true
 | (T 30) => true | (T 31) => true | (T 35) => true | (T 39) => true
 | (T 41) => true | _ => false
val preferred_change : (term list * term list) list = 
(nil
,nil
 $$ (T 30))::
(nil
,nil
 $$ (T 31))::
(nil
,nil
 $$ (T 7))::
nil
val noShift = 
fn (T 0) => true | _ => false
val showTerminal =
fn (T 0) => "EOF"
  | (T 1) => "ID"
  | (T 2) => "INT"
  | (T 3) => "STRING"
  | (T 4) => "COMMA"
  | (T 5) => "COLON"
  | (T 6) => "SEMICOLON"
  | (T 7) => "LPAREN"
  | (T 8) => "RPAREN"
  | (T 9) => "LBRACK"
  | (T 10) => "RBRACK"
  | (T 11) => "LBRACE"
  | (T 12) => "RBRACE"
  | (T 13) => "DOT"
  | (T 14) => "PLUS"
  | (T 15) => "MINUS"
  | (T 16) => "UMINUS"
  | (T 17) => "TIMES"
  | (T 18) => "DIVIDE"
  | (T 19) => "EQ"
  | (T 20) => "NEQ"
  | (T 21) => "LT"
  | (T 22) => "LE"
  | (T 23) => "GT"
  | (T 24) => "GE"
  | (T 25) => "AND"
  | (T 26) => "OR"
  | (T 27) => "ASSIGN"
  | (T 28) => "ARRAY"
  | (T 29) => "IF"
  | (T 30) => "THEN"
  | (T 31) => "ELSE"
  | (T 32) => "WHILE"
  | (T 33) => "FOR"
  | (T 34) => "TO"
  | (T 35) => "DO"
  | (T 36) => "LET"
  | (T 37) => "IN"
  | (T 38) => "END"
  | (T 39) => "OF"
  | (T 40) => "BREAK"
  | (T 41) => "NIL"
  | (T 42) => "FUNCTION"
  | (T 43) => "VAR"
  | (T 44) => "TYPE"
  | (T 45) => "LOWPREC"
  | (T 46) => "HIGHPREC"
  | _ => "bogus-term"
local open Header in
val errtermvalue=
fn (T 1) => MlyValue.ID(fn () => ("bogus")) | 
(T 2) => MlyValue.INT(fn () => (1)) | 
(T 3) => MlyValue.STRING(fn () => ("")) | 
_ => MlyValue.VOID
end
val terms : term list = nil
 $$ (T 46) $$ (T 45) $$ (T 44) $$ (T 43) $$ (T 42) $$ (T 41) $$ (T 40)
 $$ (T 39) $$ (T 38) $$ (T 37) $$ (T 36) $$ (T 35) $$ (T 34) $$ (T 33)
 $$ (T 32) $$ (T 31) $$ (T 30) $$ (T 29) $$ (T 28) $$ (T 27) $$ (T 26)
 $$ (T 25) $$ (T 24) $$ (T 23) $$ (T 22) $$ (T 21) $$ (T 20) $$ (T 19)
 $$ (T 18) $$ (T 17) $$ (T 16) $$ (T 15) $$ (T 14) $$ (T 13) $$ (T 12)
 $$ (T 11) $$ (T 10) $$ (T 9) $$ (T 8) $$ (T 7) $$ (T 6) $$ (T 5) $$ 
(T 4) $$ (T 0)end
structure Actions =
struct 
exception mlyAction of int
local open Header in
val actions = 
fn (i392,defaultPos,stack,
    (()):arg) =>
case (i392,stack)
of  ( 0, ( ( _, ( MlyValue.exp exp1, exp1left, exp1right)) :: rest671)
) => let val  result = MlyValue.program (fn _ => let val  (exp as exp1
) = exp1 ()
 in (exp)
end)
 in ( LrTable.NT 0, ( result, exp1left, exp1right), rest671)
end
|  ( 1, ( rest671)) => let val  result = MlyValue.decs (fn _ => (nil))
 in ( LrTable.NT 4, ( result, defaultPos, defaultPos), rest671)
end
|  ( 2, ( ( _, ( MlyValue.decs decs1, _, decs1right)) :: ( _, ( 
MlyValue.dec dec1, dec1left, _)) :: rest671)) => let val  result = 
MlyValue.decs (fn _ => let val  (dec as dec1) = dec1 ()
 val  (decs as decs1) = decs1 ()
 in ([dec] @ decs)
end)
 in ( LrTable.NT 4, ( result, dec1left, decs1right), rest671)
end
|  ( 3, ( ( _, ( MlyValue.vardec vardec1, vardec1left, vardec1right))
 :: rest671)) => let val  result = MlyValue.dec (fn _ => let val  (
vardec as vardec1) = vardec1 ()
 in (A.VarDec vardec)
end)
 in ( LrTable.NT 7, ( result, vardec1left, vardec1right), rest671)
end
|  ( 4, ( ( _, ( MlyValue.tydecs tydecs1, tydecs1left, tydecs1right))
 :: rest671)) => let val  result = MlyValue.dec (fn _ => let val  (
tydecs as tydecs1) = tydecs1 ()
 in (A.TypeDec tydecs)
end)
 in ( LrTable.NT 7, ( result, tydecs1left, tydecs1right), rest671)
end
|  ( 5, ( ( _, ( MlyValue.fundecs fundecs1, fundecs1left, 
fundecs1right)) :: rest671)) => let val  result = MlyValue.dec (fn _
 => let val  (fundecs as fundecs1) = fundecs1 ()
 in (A.FunctionDec fundecs)
end)
 in ( LrTable.NT 7, ( result, fundecs1left, fundecs1right), rest671)

end
|  ( 6, ( ( _, ( MlyValue.tydec tydec1, tydec1left, tydec1right)) :: 
rest671)) => let val  result = MlyValue.tydecs (fn _ => let val  (
tydec as tydec1) = tydec1 ()
 in ([tydec])
end)
 in ( LrTable.NT 10, ( result, tydec1left, tydec1right), rest671)
end
|  ( 7, ( ( _, ( MlyValue.tydec tydec1, _, tydec1right)) :: ( _, ( 
MlyValue.tydecs tydecs1, tydecs1left, _)) :: rest671)) => let val  
result = MlyValue.tydecs (fn _ => let val  (tydecs as tydecs1) = 
tydecs1 ()
 val  (tydec as tydec1) = tydec1 ()
 in ([tydec] @ tydecs)
end)
 in ( LrTable.NT 10, ( result, tydecs1left, tydec1right), rest671)
end
|  ( 8, ( ( _, ( MlyValue.ty ty1, _, ty1right)) :: _ :: ( _, ( 
MlyValue.ID ID1, _, _)) :: ( _, ( _, (TYPEleft as TYPE1left), _)) :: 
rest671)) => let val  result = MlyValue.tydec (fn _ => let val  (ID
 as ID1) = ID1 ()
 val  (ty as ty1) = ty1 ()
 in ({name=Symbol.symbol ID, ty=ty, pos=TYPEleft})
end)
 in ( LrTable.NT 9, ( result, TYPE1left, ty1right), rest671)
end
|  ( 9, ( ( _, ( MlyValue.ID ID1, (IDleft as ID1left), ID1right)) :: 
rest671)) => let val  result = MlyValue.ty (fn _ => let val  (ID as 
ID1) = ID1 ()
 in (A.NameTy(Symbol.symbol ID, IDleft))
end)
 in ( LrTable.NT 8, ( result, ID1left, ID1right), rest671)
end
|  ( 10, ( ( _, ( _, _, RBRACE1right)) :: ( _, ( MlyValue.tyfields 
tyfields1, _, _)) :: ( _, ( _, LBRACE1left, _)) :: rest671)) => let
 val  result = MlyValue.ty (fn _ => let val  (tyfields as tyfields1) =
 tyfields1 ()
 in (A.RecordTy(tyfields))
end)
 in ( LrTable.NT 8, ( result, LBRACE1left, RBRACE1right), rest671)
end
|  ( 11, ( ( _, ( MlyValue.ID ID1, _, ID1right)) :: _ :: ( _, ( _, (
ARRAYleft as ARRAY1left), _)) :: rest671)) => let val  result = 
MlyValue.ty (fn _ => let val  (ID as ID1) = ID1 ()
 in (A.ArrayTy(Symbol.symbol ID, ARRAYleft))
end)
 in ( LrTable.NT 8, ( result, ARRAY1left, ID1right), rest671)
end
|  ( 12, ( ( _, ( MlyValue.ID ID2, _, ID2right)) :: _ :: ( _, ( 
MlyValue.ID ID1, ID1left, _)) :: rest671)) => let val  result = 
MlyValue.tyfield (fn _ => let val  ID1 = ID1 ()
 val  ID2 = ID2 ()
 in (
{name=Symbol.symbol ID1, escape=(ref false), typ=Symbol.symbol ID2, pos=ID1left}
)
end)
 in ( LrTable.NT 14, ( result, ID1left, ID2right), rest671)
end
|  ( 13, ( rest671)) => let val  result = MlyValue.tyfields (fn _ => (
[]))
 in ( LrTable.NT 15, ( result, defaultPos, defaultPos), rest671)
end
|  ( 14, ( ( _, ( MlyValue.tyfields_tail tyfields_tail1, _, 
tyfields_tail1right)) :: ( _, ( MlyValue.tyfield tyfield1, 
tyfield1left, _)) :: rest671)) => let val  result = MlyValue.tyfields
 (fn _ => let val  (tyfield as tyfield1) = tyfield1 ()
 val  (tyfields_tail as tyfields_tail1) = tyfields_tail1 ()
 in ([tyfield] @ tyfields_tail)
end)
 in ( LrTable.NT 15, ( result, tyfield1left, tyfields_tail1right), 
rest671)
end
|  ( 15, ( rest671)) => let val  result = MlyValue.tyfields_tail (fn _
 => ([]))
 in ( LrTable.NT 16, ( result, defaultPos, defaultPos), rest671)
end
|  ( 16, ( ( _, ( MlyValue.tyfields_tail tyfields_tail1, _, 
tyfields_tail1right)) :: ( _, ( MlyValue.tyfield tyfield1, _, _)) :: (
 _, ( _, COMMA1left, _)) :: rest671)) => let val  result = 
MlyValue.tyfields_tail (fn _ => let val  (tyfield as tyfield1) = 
tyfield1 ()
 val  (tyfields_tail as tyfields_tail1) = tyfields_tail1 ()
 in ([tyfield] @ tyfields_tail)
end)
 in ( LrTable.NT 16, ( result, COMMA1left, tyfields_tail1right), 
rest671)
end
|  ( 17, ( ( _, ( MlyValue.exp exp1, _, exp1right)) :: _ :: ( _, ( 
MlyValue.ID ID1, ID1left, _)) :: ( _, ( _, VAR1left, _)) :: rest671))
 => let val  result = MlyValue.vardec (fn _ => let val  (ID as ID1) = 
ID1 ()
 val  (exp as exp1) = exp1 ()
 in (
{name = Symbol.symbol ID, escape = (ref true), typ = NONE, init=exp, pos = ID1left}
)
end)
 in ( LrTable.NT 11, ( result, VAR1left, exp1right), rest671)
end
|  ( 18, ( ( _, ( MlyValue.exp exp1, _, exp1right)) :: _ :: ( _, ( 
MlyValue.ID ID2, ID2left, _)) :: _ :: ( _, ( MlyValue.ID ID1, _, _))
 :: ( _, ( _, (VARleft as VAR1left), _)) :: rest671)) => let val  
result = MlyValue.vardec (fn _ => let val  ID1 = ID1 ()
 val  ID2 = ID2 ()
 val  (exp as exp1) = exp1 ()
 in (
{name = Symbol.symbol ID1, escape = (ref true), typ = SOME (Symbol.symbol ID2, ID2left), init = exp, pos = VARleft}
)
end)
 in ( LrTable.NT 11, ( result, VAR1left, exp1right), rest671)
end
|  ( 19, ( ( _, ( MlyValue.exp exp1, _, exp1right)) :: _ :: _ :: ( _, 
( MlyValue.tyfields tyfields1, _, _)) :: _ :: ( _, ( MlyValue.ID ID1,
 _, _)) :: ( _, ( _, (FUNCTIONleft as FUNCTION1left), _)) :: rest671))
 => let val  result = MlyValue.fundec (fn _ => let val  (ID as ID1) = 
ID1 ()
 val  (tyfields as tyfields1) = tyfields1 ()
 val  (exp as exp1) = exp1 ()
 in (
{name=Symbol.symbol ID, params=tyfields, result=NONE, body=exp, pos=FUNCTIONleft}
)
end)
 in ( LrTable.NT 12, ( result, FUNCTION1left, exp1right), rest671)
end
|  ( 20, ( ( _, ( MlyValue.exp exp1, _, exp1right)) :: _ :: ( _, ( 
MlyValue.ID ID2, ID2left, _)) :: _ :: _ :: ( _, ( MlyValue.tyfields 
tyfields1, _, _)) :: _ :: ( _, ( MlyValue.ID ID1, _, _)) :: ( _, ( _,
 (FUNCTIONleft as FUNCTION1left), _)) :: rest671)) => let val  result
 = MlyValue.fundec (fn _ => let val  (ID as ID1) = ID1 ()
 val  (tyfields as tyfields1) = tyfields1 ()
 val  ID2 = ID2 ()
 val  (exp as exp1) = exp1 ()
 in (
{name=Symbol.symbol ID, params=tyfields, result=SOME(Symbol.symbol ID2, ID2left), body=exp, pos=FUNCTIONleft}
)
end)
 in ( LrTable.NT 12, ( result, FUNCTION1left, exp1right), rest671)
end
|  ( 21, ( ( _, ( MlyValue.fundec fundec1, fundec1left, fundec1right))
 :: rest671)) => let val  result = MlyValue.fundecs (fn _ => let val 
 (fundec as fundec1) = fundec1 ()
 in ([fundec])
end)
 in ( LrTable.NT 13, ( result, fundec1left, fundec1right), rest671)

end
|  ( 22, ( ( _, ( MlyValue.fundec fundec1, _, fundec1right)) :: ( _, (
 MlyValue.fundecs fundecs1, fundecs1left, _)) :: rest671)) => let val 
 result = MlyValue.fundecs (fn _ => let val  (fundecs as fundecs1) = 
fundecs1 ()
 val  (fundec as fundec1) = fundec1 ()
 in ([fundec] @ fundecs)
end)
 in ( LrTable.NT 13, ( result, fundecs1left, fundec1right), rest671)

end
|  ( 23, ( ( _, ( MlyValue.ID ID1, (IDleft as ID1left), ID1right)) :: 
rest671)) => let val  result = MlyValue.lval (fn _ => let val  (ID as 
ID1) = ID1 ()
 in (A.SimpleVar(Symbol.symbol ID, IDleft))
end)
 in ( LrTable.NT 2, ( result, ID1left, ID1right), rest671)
end
|  ( 24, ( ( _, ( MlyValue.lval_not_id lval_not_id1, lval_not_id1left,
 lval_not_id1right)) :: rest671)) => let val  result = MlyValue.lval
 (fn _ => let val  (lval_not_id as lval_not_id1) = lval_not_id1 ()
 in (lval_not_id)
end)
 in ( LrTable.NT 2, ( result, lval_not_id1left, lval_not_id1right), 
rest671)
end
|  ( 25, ( ( _, ( MlyValue.ID ID1, _, ID1right)) :: _ :: ( _, ( 
MlyValue.lval lval1, (lvalleft as lval1left), _)) :: rest671)) => let
 val  result = MlyValue.lval_not_id (fn _ => let val  (lval as lval1)
 = lval1 ()
 val  (ID as ID1) = ID1 ()
 in (A.FieldVar(lval, Symbol.symbol ID, lvalleft))
end)
 in ( LrTable.NT 3, ( result, lval1left, ID1right), rest671)
end
|  ( 26, ( ( _, ( _, _, RBRACK1right)) :: ( _, ( MlyValue.exp exp1, _,
 _)) :: _ :: ( _, ( MlyValue.ID ID1, (IDleft as ID1left), _)) :: 
rest671)) => let val  result = MlyValue.lval_not_id (fn _ => let val 
 (ID as ID1) = ID1 ()
 val  (exp as exp1) = exp1 ()
 in (
A.SubscriptVar(A.SimpleVar(Symbol.symbol ID, IDleft), exp, IDleft))

end)
 in ( LrTable.NT 3, ( result, ID1left, RBRACK1right), rest671)
end
|  ( 27, ( ( _, ( _, _, RBRACK1right)) :: ( _, ( MlyValue.exp exp1, _,
 _)) :: _ :: ( _, ( MlyValue.lval_not_id lval_not_id1, (
lval_not_idleft as lval_not_id1left), _)) :: rest671)) => let val  
result = MlyValue.lval_not_id (fn _ => let val  (lval_not_id as 
lval_not_id1) = lval_not_id1 ()
 val  (exp as exp1) = exp1 ()
 in (A.SubscriptVar(lval_not_id, exp, lval_not_idleft))
end)
 in ( LrTable.NT 3, ( result, lval_not_id1left, RBRACK1right), rest671
)
end
|  ( 28, ( rest671)) => let val  result = MlyValue.arguments (fn _ =>
 ([]))
 in ( LrTable.NT 19, ( result, defaultPos, defaultPos), rest671)
end
|  ( 29, ( ( _, ( MlyValue.arguments_tail arguments_tail1, _, 
arguments_tail1right)) :: ( _, ( MlyValue.exp exp1, exp1left, _)) :: 
rest671)) => let val  result = MlyValue.arguments (fn _ => let val  (
exp as exp1) = exp1 ()
 val  (arguments_tail as arguments_tail1) = arguments_tail1 ()
 in (exp::arguments_tail)
end)
 in ( LrTable.NT 19, ( result, exp1left, arguments_tail1right), 
rest671)
end
|  ( 30, ( rest671)) => let val  result = MlyValue.arguments_tail (fn
 _ => ([]))
 in ( LrTable.NT 20, ( result, defaultPos, defaultPos), rest671)
end
|  ( 31, ( ( _, ( MlyValue.arguments_tail arguments_tail1, _, 
arguments_tail1right)) :: ( _, ( MlyValue.exp exp1, _, _)) :: ( _, ( _
, COMMA1left, _)) :: rest671)) => let val  result = 
MlyValue.arguments_tail (fn _ => let val  (exp as exp1) = exp1 ()
 val  (arguments_tail as arguments_tail1) = arguments_tail1 ()
 in (exp::arguments_tail)
end)
 in ( LrTable.NT 20, ( result, COMMA1left, arguments_tail1right), 
rest671)
end
|  ( 32, ( ( _, ( MlyValue.exp exp1, _, exp1right)) :: _ :: ( _, ( 
MlyValue.ID ID1, (IDleft as ID1left), _)) :: rest671)) => let val  
result = MlyValue.record_field (fn _ => let val  (ID as ID1) = ID1 ()
 val  (exp as exp1) = exp1 ()
 in (Symbol.symbol ID, exp, IDleft)
end)
 in ( LrTable.NT 21, ( result, ID1left, exp1right), rest671)
end
|  ( 33, ( rest671)) => let val  result = MlyValue.record_tail (fn _
 => ([]))
 in ( LrTable.NT 22, ( result, defaultPos, defaultPos), rest671)
end
|  ( 34, ( ( _, ( MlyValue.record_tail record_tail1, _, 
record_tail1right)) :: ( _, ( MlyValue.record_field record_field1, _,
 _)) :: ( _, ( _, COMMA1left, _)) :: rest671)) => let val  result = 
MlyValue.record_tail (fn _ => let val  (record_field as record_field1)
 = record_field1 ()
 val  (record_tail as record_tail1) = record_tail1 ()
 in ([record_field] @ record_tail)
end)
 in ( LrTable.NT 22, ( result, COMMA1left, record_tail1right), rest671
)
end
|  ( 35, ( ( _, ( MlyValue.ID ID1, (IDleft as ID1left), ID1right)) :: 
rest671)) => let val  result = MlyValue.exp (fn _ => let val  (ID as 
ID1) = ID1 ()
 in (A.VarExp(A.SimpleVar(Symbol.symbol ID, IDleft)))
end)
 in ( LrTable.NT 1, ( result, ID1left, ID1right), rest671)
end
|  ( 36, ( ( _, ( MlyValue.lval_not_id lval_not_id1, lval_not_id1left,
 lval_not_id1right)) :: rest671)) => let val  result = MlyValue.exp
 (fn _ => let val  (lval_not_id as lval_not_id1) = lval_not_id1 ()
 in (A.VarExp(lval_not_id))
end)
 in ( LrTable.NT 1, ( result, lval_not_id1left, lval_not_id1right), 
rest671)
end
|  ( 37, ( ( _, ( _, NIL1left, NIL1right)) :: rest671)) => let val  
result = MlyValue.exp (fn _ => (A.NilExp))
 in ( LrTable.NT 1, ( result, NIL1left, NIL1right), rest671)
end
|  ( 38, ( ( _, ( MlyValue.INT INT1, INT1left, INT1right)) :: rest671)
) => let val  result = MlyValue.exp (fn _ => let val  (INT as INT1) = 
INT1 ()
 in (A.IntExp(INT))
end)
 in ( LrTable.NT 1, ( result, INT1left, INT1right), rest671)
end
|  ( 39, ( ( _, ( MlyValue.STRING STRING1, (STRINGleft as STRING1left)
, STRING1right)) :: rest671)) => let val  result = MlyValue.exp (fn _
 => let val  (STRING as STRING1) = STRING1 ()
 in (A.StringExp(STRING, STRINGleft))
end)
 in ( LrTable.NT 1, ( result, STRING1left, STRING1right), rest671)
end
|  ( 40, ( ( _, ( MlyValue.exp exp1, _, exp1right)) :: ( _, ( _, (
MINUSleft as MINUS1left), _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  (exp as exp1) = exp1 ()
 in (
A.OpExp({left=A.IntExp(0), oper=A.MinusOp, right=exp, pos=MINUSleft}))

end)
 in ( LrTable.NT 1, ( result, MINUS1left, exp1right), rest671)
end
|  ( 41, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.PlusOp, right=exp2, pos=exp1left}))

end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 42, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.MinusOp, right=exp2, pos=exp1left}))

end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 43, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.DivideOp, right=exp2, pos=exp1left}))

end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 44, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.TimesOp, right=exp2, pos=exp1left}))

end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 45, ( ( _, ( _, _, RPAREN1right)) :: ( _, ( MlyValue.arguments 
arguments1, _, _)) :: _ :: ( _, ( MlyValue.ID ID1, (IDleft as ID1left)
, _)) :: rest671)) => let val  result = MlyValue.exp (fn _ => let val 
 (ID as ID1) = ID1 ()
 val  (arguments as arguments1) = arguments1 ()
 in (A.CallExp({func=Symbol.symbol ID, args=arguments, pos=IDleft}))

end)
 in ( LrTable.NT 1, ( result, ID1left, RPAREN1right), rest671)
end
|  ( 46, ( ( _, ( _, _, RPAREN1right)) :: ( _, ( MlyValue.exp exp1, _,
 _)) :: ( _, ( _, LPAREN1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  (exp as exp1) = exp1 ()
 in (exp)
end)
 in ( LrTable.NT 1, ( result, LPAREN1left, RPAREN1right), rest671)
end
|  ( 47, ( ( _, ( _, _, RPAREN1right)) :: ( _, ( _, LPAREN1left, _))
 :: rest671)) => let val  result = MlyValue.exp (fn _ => (A.SeqExp([])
))
 in ( LrTable.NT 1, ( result, LPAREN1left, RPAREN1right), rest671)
end
|  ( 48, ( ( _, ( _, _, RBRACE1right)) :: ( _, ( MlyValue.record_tail 
record_tail1, _, _)) :: ( _, ( MlyValue.record_field record_field1, _,
 _)) :: _ :: ( _, ( MlyValue.ID ID1, (IDleft as ID1left), _)) :: 
rest671)) => let val  result = MlyValue.exp (fn _ => let val  (ID as 
ID1) = ID1 ()
 val  (record_field as record_field1) = record_field1 ()
 val  (record_tail as record_tail1) = record_tail1 ()
 in (
A.RecordExp({fields= [record_field] @ record_tail, typ=Symbol.symbol ID , pos=IDleft})
)
end)
 in ( LrTable.NT 1, ( result, ID1left, RBRACE1right), rest671)
end
|  ( 49, ( ( _, ( _, _, NIL1right)) :: ( _, ( MlyValue.ID ID1, (IDleft
 as ID1left), _)) :: rest671)) => let val  result = MlyValue.exp (fn _
 => let val  (ID as ID1) = ID1 ()
 in (A.RecordExp({fields=[], typ=Symbol.symbol ID, pos=IDleft}))
end)
 in ( LrTable.NT 1, ( result, ID1left, NIL1right), rest671)
end
|  ( 50, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: _ :: ( _, 
( MlyValue.exp exp1, _, _)) :: _ :: ( _, ( MlyValue.ID ID1, (IDleft
 as ID1left), _)) :: rest671)) => let val  result = MlyValue.exp (fn _
 => let val  (ID as ID1) = ID1 ()
 val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (
A.ArrayExp({typ=Symbol.symbol ID, size=exp1, init=exp2, pos=IDleft}))

end)
 in ( LrTable.NT 1, ( result, ID1left, exp2right), rest671)
end
|  ( 51, ( ( _, ( MlyValue.exp exp1, _, exp1right)) :: _ :: ( _, ( 
MlyValue.lval lval1, (lvalleft as lval1left), _)) :: rest671)) => let
 val  result = MlyValue.exp (fn _ => let val  (lval as lval1) = lval1
 ()
 val  (exp as exp1) = exp1 ()
 in (A.AssignExp({var=lval, exp=exp, pos=lvalleft}))
end)
 in ( LrTable.NT 1, ( result, lval1left, exp1right), rest671)
end
|  ( 52, ( ( _, ( MlyValue.exp exp3, _, exp3right)) :: _ :: ( _, ( 
MlyValue.exp exp2, _, _)) :: _ :: ( _, ( MlyValue.exp exp1, _, _)) :: 
( _, ( _, (IFleft as IF1left), _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 val  exp3 = exp3 ()
 in (A.IfExp({test=exp1, then'=exp2, else'=SOME exp3, pos=IFleft}))

end)
 in ( LrTable.NT 1, ( result, IF1left, exp3right), rest671)
end
|  ( 53, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, _, _)) :: ( _, ( _, (IFleft as IF1left), _)) :: 
rest671)) => let val  result = MlyValue.exp (fn _ => let val  exp1 = 
exp1 ()
 val  exp2 = exp2 ()
 in (A.IfExp({test=exp1, then'=exp2, else'=NONE, pos=IFleft}))
end)
 in ( LrTable.NT 1, ( result, IF1left, exp2right), rest671)
end
|  ( 54, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, _, _)) :: ( _, ( _, (WHILEleft as WHILE1left), _))
 :: rest671)) => let val  result = MlyValue.exp (fn _ => let val  exp1
 = exp1 ()
 val  exp2 = exp2 ()
 in (A.WhileExp({test=exp1, body=exp2, pos=WHILEleft}))
end)
 in ( LrTable.NT 1, ( result, WHILE1left, exp2right), rest671)
end
|  ( 55, ( ( _, ( MlyValue.exp exp3, _, exp3right)) :: _ :: ( _, ( 
MlyValue.exp exp2, _, _)) :: _ :: ( _, ( MlyValue.exp exp1, _, _)) ::
 _ :: ( _, ( MlyValue.ID ID1, _, _)) :: ( _, ( _, (FORleft as FOR1left
), _)) :: rest671)) => let val  result = MlyValue.exp (fn _ => let
 val  (ID as ID1) = ID1 ()
 val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 val  exp3 = exp3 ()
 in (
A.ForExp({var=Symbol.symbol ID, escape=(ref true), lo=exp1, hi=exp2, body=exp3, pos=FORleft})
)
end)
 in ( LrTable.NT 1, ( result, FOR1left, exp3right), rest671)
end
|  ( 56, ( ( _, ( _, (BREAKleft as BREAK1left), BREAK1right)) :: 
rest671)) => let val  result = MlyValue.exp (fn _ => (
A.BreakExp(BREAKleft)))
 in ( LrTable.NT 1, ( result, BREAK1left, BREAK1right), rest671)
end
|  ( 57, ( ( _, ( _, _, END1right)) :: ( _, ( MlyValue.exp exp1, _, _)
) :: _ :: ( _, ( MlyValue.decs decs1, _, _)) :: ( _, ( _, (LETleft as 
LET1left), _)) :: rest671)) => let val  result = MlyValue.exp (fn _ =>
 let val  (decs as decs1) = decs1 ()
 val  (exp as exp1) = exp1 ()
 in (A.LetExp({decs=decs, body=exp, pos=LETleft}))
end)
 in ( LrTable.NT 1, ( result, LET1left, END1right), rest671)
end
|  ( 58, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (
A.IfExp({test=exp1, then'=exp2, else'=SOME (A.IntExp 0), pos=exp1left})
)
end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 59, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (
A.IfExp({test=exp1, then'=A.IntExp(1), else'=SOME exp2, pos=exp1left})
)
end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 60, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.EqOp, right=exp2, pos=exp1left}))
end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 61, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.NeqOp, right=exp2, pos=exp1left}))
end
)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 62, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.LeOp, right=exp2, pos=exp1left}))
end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 63, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.GeOp, right=exp2, pos=exp1left}))
end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 64, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.LtOp, right=exp2, pos=exp1left}))
end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 65, ( ( _, ( MlyValue.exp exp2, _, exp2right)) :: _ :: ( _, ( 
MlyValue.exp exp1, exp1left, _)) :: rest671)) => let val  result = 
MlyValue.exp (fn _ => let val  exp1 = exp1 ()
 val  exp2 = exp2 ()
 in (A.OpExp({left=exp1, oper=A.GtOp, right=exp2, pos=exp1left}))
end)
 in ( LrTable.NT 1, ( result, exp1left, exp2right), rest671)
end
|  ( 66, ( ( _, ( _, _, RPAREN1right)) :: ( _, ( MlyValue.exp_tail 
exp_tail1, _, _)) :: ( _, ( MlyValue.exp exp1, expleft, _)) :: ( _, (
 _, LPAREN1left, _)) :: rest671)) => let val  result = MlyValue.exp
 (fn _ => let val  (exp as exp1) = exp1 ()
 val  (exp_tail as exp_tail1) = exp_tail1 ()
 in (A.SeqExp((exp, expleft)::exp_tail))
end)
 in ( LrTable.NT 1, ( result, LPAREN1left, RPAREN1right), rest671)
end
|  ( 67, ( ( _, ( MlyValue.exp_can_be_empty exp_can_be_empty1, _, 
exp_can_be_empty1right)) :: ( _, ( MlyValue.exp exp1, expleft, _)) :: 
( _, ( _, SEMICOLON1left, _)) :: rest671)) => let val  result = 
MlyValue.exp_tail (fn _ => let val  (exp as exp1) = exp1 ()
 val  (exp_can_be_empty as exp_can_be_empty1) = exp_can_be_empty1 ()
 in ((exp, expleft)::exp_can_be_empty)
end)
 in ( LrTable.NT 17, ( result, SEMICOLON1left, exp_can_be_empty1right)
, rest671)
end
|  ( 68, ( ( _, ( MlyValue.exp_can_be_empty exp_can_be_empty1, _, 
exp_can_be_empty1right)) :: ( _, ( MlyValue.exp exp1, expleft, _)) :: 
( _, ( _, SEMICOLON1left, _)) :: rest671)) => let val  result = 
MlyValue.exp_can_be_empty (fn _ => let val  (exp as exp1) = exp1 ()
 val  (exp_can_be_empty as exp_can_be_empty1) = exp_can_be_empty1 ()
 in ((exp, expleft)::exp_can_be_empty)
end)
 in ( LrTable.NT 18, ( result, SEMICOLON1left, exp_can_be_empty1right)
, rest671)
end
|  ( 69, ( rest671)) => let val  result = MlyValue.exp_can_be_empty
 (fn _ => ([]))
 in ( LrTable.NT 18, ( result, defaultPos, defaultPos), rest671)
end
| _ => raise (mlyAction i392)
end
val void = MlyValue.VOID
val extract = fn a => (fn MlyValue.program x => x
| _ => let exception ParseInternal
	in raise ParseInternal end) a ()
end
end
structure Tokens : Tiger_TOKENS =
struct
type svalue = ParserData.svalue
type ('a,'b) token = ('a,'b) Token.token
fun EOF (p1,p2) = Token.TOKEN (ParserData.LrTable.T 0,(
ParserData.MlyValue.VOID,p1,p2))
fun ID (i,p1,p2) = Token.TOKEN (ParserData.LrTable.T 1,(
ParserData.MlyValue.ID (fn () => i),p1,p2))
fun INT (i,p1,p2) = Token.TOKEN (ParserData.LrTable.T 2,(
ParserData.MlyValue.INT (fn () => i),p1,p2))
fun STRING (i,p1,p2) = Token.TOKEN (ParserData.LrTable.T 3,(
ParserData.MlyValue.STRING (fn () => i),p1,p2))
fun COMMA (p1,p2) = Token.TOKEN (ParserData.LrTable.T 4,(
ParserData.MlyValue.VOID,p1,p2))
fun COLON (p1,p2) = Token.TOKEN (ParserData.LrTable.T 5,(
ParserData.MlyValue.VOID,p1,p2))
fun SEMICOLON (p1,p2) = Token.TOKEN (ParserData.LrTable.T 6,(
ParserData.MlyValue.VOID,p1,p2))
fun LPAREN (p1,p2) = Token.TOKEN (ParserData.LrTable.T 7,(
ParserData.MlyValue.VOID,p1,p2))
fun RPAREN (p1,p2) = Token.TOKEN (ParserData.LrTable.T 8,(
ParserData.MlyValue.VOID,p1,p2))
fun LBRACK (p1,p2) = Token.TOKEN (ParserData.LrTable.T 9,(
ParserData.MlyValue.VOID,p1,p2))
fun RBRACK (p1,p2) = Token.TOKEN (ParserData.LrTable.T 10,(
ParserData.MlyValue.VOID,p1,p2))
fun LBRACE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 11,(
ParserData.MlyValue.VOID,p1,p2))
fun RBRACE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 12,(
ParserData.MlyValue.VOID,p1,p2))
fun DOT (p1,p2) = Token.TOKEN (ParserData.LrTable.T 13,(
ParserData.MlyValue.VOID,p1,p2))
fun PLUS (p1,p2) = Token.TOKEN (ParserData.LrTable.T 14,(
ParserData.MlyValue.VOID,p1,p2))
fun MINUS (p1,p2) = Token.TOKEN (ParserData.LrTable.T 15,(
ParserData.MlyValue.VOID,p1,p2))
fun UMINUS (p1,p2) = Token.TOKEN (ParserData.LrTable.T 16,(
ParserData.MlyValue.VOID,p1,p2))
fun TIMES (p1,p2) = Token.TOKEN (ParserData.LrTable.T 17,(
ParserData.MlyValue.VOID,p1,p2))
fun DIVIDE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 18,(
ParserData.MlyValue.VOID,p1,p2))
fun EQ (p1,p2) = Token.TOKEN (ParserData.LrTable.T 19,(
ParserData.MlyValue.VOID,p1,p2))
fun NEQ (p1,p2) = Token.TOKEN (ParserData.LrTable.T 20,(
ParserData.MlyValue.VOID,p1,p2))
fun LT (p1,p2) = Token.TOKEN (ParserData.LrTable.T 21,(
ParserData.MlyValue.VOID,p1,p2))
fun LE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 22,(
ParserData.MlyValue.VOID,p1,p2))
fun GT (p1,p2) = Token.TOKEN (ParserData.LrTable.T 23,(
ParserData.MlyValue.VOID,p1,p2))
fun GE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 24,(
ParserData.MlyValue.VOID,p1,p2))
fun AND (p1,p2) = Token.TOKEN (ParserData.LrTable.T 25,(
ParserData.MlyValue.VOID,p1,p2))
fun OR (p1,p2) = Token.TOKEN (ParserData.LrTable.T 26,(
ParserData.MlyValue.VOID,p1,p2))
fun ASSIGN (p1,p2) = Token.TOKEN (ParserData.LrTable.T 27,(
ParserData.MlyValue.VOID,p1,p2))
fun ARRAY (p1,p2) = Token.TOKEN (ParserData.LrTable.T 28,(
ParserData.MlyValue.VOID,p1,p2))
fun IF (p1,p2) = Token.TOKEN (ParserData.LrTable.T 29,(
ParserData.MlyValue.VOID,p1,p2))
fun THEN (p1,p2) = Token.TOKEN (ParserData.LrTable.T 30,(
ParserData.MlyValue.VOID,p1,p2))
fun ELSE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 31,(
ParserData.MlyValue.VOID,p1,p2))
fun WHILE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 32,(
ParserData.MlyValue.VOID,p1,p2))
fun FOR (p1,p2) = Token.TOKEN (ParserData.LrTable.T 33,(
ParserData.MlyValue.VOID,p1,p2))
fun TO (p1,p2) = Token.TOKEN (ParserData.LrTable.T 34,(
ParserData.MlyValue.VOID,p1,p2))
fun DO (p1,p2) = Token.TOKEN (ParserData.LrTable.T 35,(
ParserData.MlyValue.VOID,p1,p2))
fun LET (p1,p2) = Token.TOKEN (ParserData.LrTable.T 36,(
ParserData.MlyValue.VOID,p1,p2))
fun IN (p1,p2) = Token.TOKEN (ParserData.LrTable.T 37,(
ParserData.MlyValue.VOID,p1,p2))
fun END (p1,p2) = Token.TOKEN (ParserData.LrTable.T 38,(
ParserData.MlyValue.VOID,p1,p2))
fun OF (p1,p2) = Token.TOKEN (ParserData.LrTable.T 39,(
ParserData.MlyValue.VOID,p1,p2))
fun BREAK (p1,p2) = Token.TOKEN (ParserData.LrTable.T 40,(
ParserData.MlyValue.VOID,p1,p2))
fun NIL (p1,p2) = Token.TOKEN (ParserData.LrTable.T 41,(
ParserData.MlyValue.VOID,p1,p2))
fun FUNCTION (p1,p2) = Token.TOKEN (ParserData.LrTable.T 42,(
ParserData.MlyValue.VOID,p1,p2))
fun VAR (p1,p2) = Token.TOKEN (ParserData.LrTable.T 43,(
ParserData.MlyValue.VOID,p1,p2))
fun TYPE (p1,p2) = Token.TOKEN (ParserData.LrTable.T 44,(
ParserData.MlyValue.VOID,p1,p2))
fun LOWPREC (p1,p2) = Token.TOKEN (ParserData.LrTable.T 45,(
ParserData.MlyValue.VOID,p1,p2))
fun HIGHPREC (p1,p2) = Token.TOKEN (ParserData.LrTable.T 46,(
ParserData.MlyValue.VOID,p1,p2))
end
end
