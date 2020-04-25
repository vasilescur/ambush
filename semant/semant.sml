functor Semant (R : TRANSLATE) : SEMANT =
struct
  (* Shortcuts *)
  structure A = Absyn
  structure E = Env (R)
  structure S = Symbol
  structure T = Types


  type exp = R.exp

  type frag = R.frag

  exception TypeCheckFailure of string (* An internal failure that should never be reached *)
  exception TypeCheckError of frag list

  type venv = E.enventry S.table
  type tenv = E.ty S.table

  type expty = {exp: R.exp, ty: T.ty}

  fun reset () = (ErrorMsg.reset(); R.reset ())

  (* Return value for cases where type checking failed *)
  val err_result = {exp = R.unfinished, ty = T.UNIT}

  fun err pos msg = (ErrorMsg.error pos ("Type Checking Error: " ^ msg))

  (* Gets the name of a type as a string *)
  fun type_str (T.NIL) = "nil"
    | type_str (T.UNIT) = "unit"
    | type_str (T.INT) = "int"
    | type_str (T.STRING) = "string"
    | type_str (T.NAME (sym, _)) = "name of " ^ S.name sym
    | type_str (T.ARRAY (ty, _)) = "array of " ^ type_str ty
    | type_str (T.RECORD ([], _)) = "record"
    | type_str (T.RECORD (fields, _)) = "{ " ^ foldl (fn ((sym, ty), str) => 
                                                                str ^ S.name sym ^ " : " ^ (type_str ty) ^ ", ") 
                                                         "" fields
                                               ^ " }"

  (* Generates a type mismatch message with an expected and actual *)
  fun typeMismatch (ty1, ty2, errMsg) = 
       errMsg ^ "\n"
              ^ "    Expected: " ^ (type_str ty1) ^ "\n"
              ^ "    Actual:   " ^ (type_str ty2)

  (* Shortcut function for type errors *)
  fun type_err (ty1, ty2, errMsg, pos) =
    ((err pos (typeMismatch (ty1, ty2, errMsg))); 
     err_result)

  (* Gets the *actual* type from NAME or ARRAY *)
  fun actual_ty (ty, pos) = 
    case ty of 
        T.NAME (sym, tyref) => (case (!tyref) of
                                    NONE => (err pos ("unknown type " ^ S.name sym); T.UNIT)
                                  | SOME (ty) => actual_ty (ty, pos))
      | T.ARRAY (ty, unique) => T.ARRAY(actual_ty (ty, pos), unique)
      | _ => ty

  (* Check if an expression is an integer *)
  fun checkInt ({exp = expInt, ty = T.INT}, errMsg, pos) : exp = expInt
    | checkInt ({exp = expInt, ty = t}, errMsg, pos) : exp = (type_err (T.INT, t, errMsg, pos); expInt)

  (* Checks if two types are equal and if so, prints an error *)
  fun checkTypesEq (ty1, ty2, pos, errMsg) = if (T.eq (ty1, ty2))
                                             then ()
                                             else err pos (typeMismatch (ty1, ty2, errMsg))

  (* Finds a type in the tenv or returns unit *)
  fun findType (typ, tenv) = let val optType = S.look (tenv, typ)
                             in case optType of 
                                  NONE => T.UNIT
                                | SOME(found) => found
                             end
    
  type env = {tenv: tenv, venv: venv}
  val base_env : env = {tenv=E.base_tenv, venv=E.base_venv}

  fun transDec (level, breakLabel, venv, tenv, A.VarDec {name, escape, typ=NONE, init, pos}) = 
      let
          val {exp, ty : E.ty} = (transExp(level, breakLabel, venv, tenv)) init
          val accessVar = R.allocateLocal level (!escape)
        in {exps=[R.assignIR (R.simpleVarIR (accessVar, level), exp)], tenv=tenv,
            venv=S.enter(venv,name,E.VarEntry{ty = ty, access = accessVar})}
        end
    | transDec (level, breakLabel, venv, tenv, A.VarDec {name, escape, typ=SOME(symbol, posType), init, pos}) = 
      let val {exp, ty} = (transExp(level, breakLabel, venv, tenv)) init
          val eTyp = S.look(tenv, symbol)
          val accessVar = R.allocateLocal level (!escape)
      in case eTyp of
         NONE => (err posType "Unrecognized type"; {exps=[R.assignIR (R.simpleVarIR (accessVar, level), exp)], tenv=tenv,
            venv=S.enter(venv,name,E.VarEntry{ty=ty, access=accessVar})})
       | SOME(tTyp) => {exps=[R.assignIR (R.simpleVarIR (accessVar, level), exp)], tenv=tenv,
            venv=S.enter(venv,name,E.VarEntry{ty=tTyp, access=accessVar})}
      end
    | transDec (level, breakLabel, venv, tenv, A.TypeDec (types)) =
        let fun checkAbstract ({name, ty, pos}, check) = case (ty) of
                                              A.NameTy (symbol, pos) => check
                                            | A.RecordTy (fields) => false
                                            | A.ArrayTy (symbol, pos) => false
            fun addName ({name, ty, pos}, tenv) = S.enter(tenv, name, T.UNIT)
            fun transTypeDec ({name, ty, pos}, tenv) = case ty of
                                                    A.NameTy (symbol, pos)  => 
                                                      let val optType = S.look(tenv, symbol)
                                                      in case optType of
                                                          NONE => (err pos "Unrecognized type"; S.enter(tenv, name, T.UNIT))
                                                        | SOME(oldType) => S.enter(tenv, name, oldType)
                                                      end
                                                  | A.RecordTy (fields)    =>
                                                      let fun transRecTy ({name, escape, typ, pos}, fieldTypes) = 
                                                          let val optType = S.look (tenv, typ)
                                                          in case optType of
                                                            NONE => (name, T.UNIT)::fieldTypes
                                                          | SOME(fieldType) => (name, fieldType)::fieldTypes
                                                          end
                                                      in S.enter(tenv, name, T.RECORD(List.foldl transRecTy [] fields, ref ()))
                                                      end
                                                  | A.ArrayTy (symbol, pos) =>
                                                      let val optType = S.look(tenv, symbol)
                                                      in case optType of 
                                                          NONE => (err pos "Unrecognized type"; S.enter (tenv, name, T.ARRAY(T.UNIT, ref ())))
                                                        | SOME(arrayType) => S.enter(tenv, name, T.ARRAY (arrayType, ref ()))
                                                      end
            val {name, ty, pos} = List.nth (types, 0)
            val newTenv = ((if (List.foldl checkAbstract true types)
                            then err pos "No concrete type declared in recursive type declaration"
                            else ());
                            List.foldl addName tenv types)
        in
          {exps=[], tenv=List.foldl transTypeDec newTenv types, venv=venv}
        end
    | transDec (level, breakLabel, venv, tenv, A.FunctionDec (functions)) = 
        let fun paramsToEscapes ([], escapes) = escapes
              | paramsToEscapes ({name, escape, typ, pos}::params, escapes) = (!escape)::escapes
            fun addFuncSig ({name, params, result, body, pos}, venv) = 
                  let fun paramToFormal ({name, escape, typ, pos}, formals) = 
                            let val optType = S.look (tenv, typ)
                                val formal = case optType of
                                               NONE => T.UNIT
                                             | SOME (formalType) => formalType
                            in formals@[formal]
                            end
                      val formals = List.foldl paramToFormal [] params
                      val newLabel = Temp.newlabel ()
                  in case result of 
                      NONE => S.enter(venv, name, E.FunEntry {level=R.nextLevel (level, newLabel, paramsToEscapes (params, [])), label=newLabel, formals=formals, result=ref T.UNIT})
                    | SOME (resultVal, resultPos) => 
                              let val resultTy = S.look (tenv, resultVal)
                              in case resultTy of
                                  NONE => 
                                        (err resultPos "Unrecognized type"; 
                                         S.enter (venv, name,
                                                  E.FunEntry {level=R.nextLevel (level, newLabel, paramsToEscapes (params, [])), label=newLabel, formals=formals, result=ref T.UNIT}))
                                | SOME(resultTyVal) => 
                                        S.enter(venv, name, 
                                                E.FunEntry {level=R.nextLevel (level, newLabel, paramsToEscapes (params, [])), label=newLabel, formals=formals, result=ref resultTyVal})
                                  
                              end
                  end
            fun transFunDec ({name, params, result, body, pos}, {tenv, venv}) =
                  let fun paramToFormal ({name, escape, typ, pos}, formals) = 
                            let val optType = S.look (tenv, typ)
                                val formal = case optType of
                                               NONE => T.UNIT
                                             | SOME (formalType) => formalType
                            in formal::formals
                            end
                      fun addParam ({name, escape, typ, pos}, {tenv, venv}) = 
                            let val paramType = findType (typ, tenv)
                                val newVenv = S.enter (venv, name, E.VarEntry {ty=paramType, access=R.allocateLocal level (!escape)})
                            in {tenv=tenv, venv=newVenv}
                            end
                      val formals = (List.foldl paramToFormal [] params)
                      val newVenv = #venv (List.foldl addParam {tenv=tenv, venv=venv} params)
                      val bodyExpty = transExp (level, breakLabel, newVenv, tenv) body
                      val newVenv = case S.look (venv, name) of 
                                NONE => venv
                              | SOME(E.FunEntry {level, label, formals, result}) => (R.procedureEntryExit (level, #exp bodyExpty, label); 
                                                                                     result := (#ty bodyExpty); 
                                                                                     venv)
                              | SOME(_) => raise TypeCheckFailure "Found variable name when looking for function signature"
                  in case result of 
                      NONE => {tenv=tenv, venv=newVenv}
                    | SOME (resultSym, resultPos) => (checkTypesEq (#ty bodyExpty, findType (resultSym, tenv), resultPos, "Function return type does not match body type check"); {tenv=tenv, venv=venv})
                    (* Need procedureEntryExit call? *)
                  end
            val newVenv = List.foldl addFuncSig venv functions
            val funDecs = (List.foldl transFunDec {tenv=tenv, venv=newVenv} functions)
        in {exps= [], tenv=tenv, venv= #venv funDecs}
        end

    and transExp(level, breakLabel, venv, tenv) = 
    let val env : env = {venv = venv, tenv = tenv}
        fun trexp (A.IntExp (int)) = {exp=(R.intIR int), ty=T.INT}
          | trexp (A.StringExp (string, pos)) = {exp=(R.stringIR (string)), ty=T.STRING}
          | trexp (A.NilExp) = {exp=(R.nilIR ()), ty=T.NIL}
          | trexp (A.CallExp ({func, args, pos})) = 
              let val exptyArgs = map trexp args
                  fun checkArgs ([], []) = true
                    | checkArgs (formals, []) = false
                    | checkArgs ([], args) = false
                    | checkArgs (formal::formals, {ty=ty, exp=exp}::args) =
                        let val match = Types.eq (formal, ty)
                        in checkArgs (formals, args) andalso match
                        end

                  val optFunc = S.look (venv, func)
              in case optFunc of 
                                NONE => (err pos "Function undefined"; {exp=R.nilIR (), ty=T.UNIT})
                              | SOME (entry) => case entry of 
                                              E.FunEntry ({formals, result, level=funlevel, label}) => 
                                                  let val _ = ()
                                                      val errMsg = "Function signature does not match\n"
                                                            ^ "    Operator: " ^ "( " ^ List.foldl (fn ({ty, exp}, str) => str ^ (type_str ty) ^ " * ") 
                                                                              "" exptyArgs
                                                                     ^ " )" ^ " -> " ^ (type_str (!result)) ^ "\n"
                                                            ^ "    Operand:  " ^ "( " ^ List.foldl (fn (formal, str) => str ^ (type_str formal)^ " * ") 
                                                                              "" formals
                                                                     ^ " )" ^ " -> " ^ (type_str (!result)) ^ "\n"
                                                            ^ "    Function: " ^ S.name func
                                                      val _ = if checkArgs (formals, exptyArgs) then () else err pos (errMsg)
                                                  in {exp=R.callIR (funlevel, level, label, map #exp exptyArgs), ty= (!result)}
                                                  end
                                            | E.VarEntry ({ty, access}) => (err pos "Function undefined"; {exp=R.nilIR (), ty=T.UNIT})
              end
          | trexp (A.RecordExp ({fields, typ, pos})) = 
              let val (reqFields, recordType) = case (S.look (tenv, typ)) of
                                    NONE => (err pos "Record undefined"; ([], T.UNIT))
                                  | SOME (T.RECORD (reqFields, unique)) => (reqFields, T.RECORD (reqFields, unique))
                                  | SOME (_) => (err pos "Record expression requires a record type"; ([], T.UNIT))
                  fun checkFields (fields, reqFields) =
                        let val match = ref true
                            val errormsg = "Record does not match record type\n"
                            val expected = foldl (fn ((sym, ty), table)=> S.enter (table, sym, ty)) S.empty reqFields
                            val expectedStr = (foldl (fn ((sym, ty), str) => str ^ (S.name sym )^ " : " ^ (type_str ty) ^ ", ") "" reqFields)
                            val actualStr = ref ""
                            val checkMatch = foldl (fn ((sym, exp, pos), table) => 
                                                        let val actualTy = #ty (trexp exp)
                                                            val found = case S.look (table, sym) of
                                                                          NONE => (match := false; false)
                                                                        | SOME (typ) => (if Types.eq (typ, actualTy)
                                                                                        then ()
                                                                                        else match := false; true)
                                                            val _ = actualStr := ((!actualStr) ^ (S.name sym) ^ " : " ^ (type_str actualTy) ^ ", ")
                                                        in if found then S.remove (table, sym) else table
                                                        end)
                                            expected fields
                        in if !match then () else err pos (errormsg ^ "    Expected: {" ^ (expectedStr) ^ "}\n"
                                                                    ^ "    Actual:   {" ^ (!actualStr)  ^ "}\n")
                        end
                  fun getExps ([]) = []
                    | getExps ((sym, exp, pos)::fields) = (#exp (trexp exp))::(getExps fields)
              in (checkFields (fields, reqFields) ; {exp=R.recordIR (getExps fields), ty=recordType})
              end
          | trexp (A.SeqExp (seq)) = 
              let fun checkExp ((exp, pos)) = trexp exp
                  fun getType ({ty=ty, exp=exp}) = ty
                  fun getExp ({ty=ty, exp=exp}) = exp
                  val seqExp = List.map checkExp seq
                  val seqType = if (List.length seqExp = 0) then T.NIL
                                else #ty (List.last seqExp)
              in {exp=R.seqIR (List.map getExp seqExp), ty= seqType}
              end
          | trexp (A.AssignExp ({var, exp, pos})) = 
              let val trVar = trvar var
                  val trExp = trexp exp
                  val errMsg = "Assignment mismatch\n"
                       ^ "    Expected: " ^ type_str (#ty trVar) ^ "\n"
                       ^ "    Actual:   " ^ type_str (#ty trExp) ^ "\n"
                  val _ = checkTypesEq (#ty trVar, #ty trExp, pos, errMsg)
              in {exp=R.assignIR (#exp trVar, #exp trExp), ty=T.NIL}
              end
          | trexp (A.IfExp ({test, then', else', pos})) = 
                let val {exp=thenExp, ty=thenType} = (trexp then')
                    val testExp = trexp test
                    val testCheck = checkInt (testExp, "If condition requires int expression", pos)
                in case else' of
                      NONE => {exp=R.ifIR (#exp testExp, thenExp, NONE), ty=thenType}
                    | SOME (elseSome) => let val {exp=elseExp, ty=elseType} = trexp elseSome
                                        in (checkTypesEq (thenType, elseType,
                                                      pos, "Type of then and else do not match");
                                                      {exp=R.ifIR (#exp testExp, thenExp, SOME(elseExp)), ty=thenType})
                                        end
                end
          | trexp (A.WhileExp ({test, body, pos})) = 
                let val joinLabel = Temp.newlabel ()
                    val transExpWhile = (transExp (level, joinLabel, venv, tenv))
                    val testTrexp = transExpWhile test
                    val bodyTrexp = transExpWhile body
                    val testCheck = checkInt (testTrexp, "While test requires int expression", pos)
                    val testBody = checkTypesEq (#ty bodyTrexp, T.NIL, pos,
                                                 "While body does not evaluate to nil")
                in {exp=R.whileIR (#exp testTrexp, #exp bodyTrexp, joinLabel), ty=T.NIL}
                end
          | trexp (A.ForExp ({var, escape, lo, hi, body, pos})) = 
                let val loTrexp = trexp lo
                    val hiTrexp = trexp hi
                    val joinLabel = Temp.newlabel ()
                    val bodyTrexp = (transExp (level, joinLabel, S.enter (venv, var, E.VarEntry {ty=T.INT, access=R.allocateLocal level (!escape)}), tenv)) body 
                    val checkLo = checkInt (loTrexp, "Low value must be an integer", pos)
                    val checkHi = checkInt (hiTrexp, "High value must be an integer", pos)
                    val checkBody = checkTypesEq (#ty bodyTrexp, 
                                                  T.NIL, pos, "For body does not evaluate to nil")

                in {exp=R.forIR (R.newVar (), #exp loTrexp, #exp hiTrexp, #exp bodyTrexp, joinLabel), ty=T.NIL}
                end
          | trexp (A.BreakExp (pos)) = {exp=R.breakIR (breakLabel), ty=T.NIL}
          | trexp (A.OpExp {left, oper, right, pos}) =
                let
                  val leftExp = checkInt(trexp left, pos)
                  val rightExp = checkInt(trexp right, pos)
                in {exp=R.opIR (leftExp, oper, rightExp), ty=T.INT}
                end
          | trexp (A.VarExp (var)) = trvar var
          | trexp (A.ArrayExp {typ, size, init, pos}) =
              let val sizeExp = trexp size
                  val initExp = trexp init
                  val _ = checkInt (sizeExp, pos)
                  val optType = S.look (tenv, typ)
              in case optType of
                  NONE => (err pos "Unrecognized type of array"; {exp=R.unfinished, ty=T.ARRAY(#ty (trexp init), ref ())})
                | SOME(T.ARRAY(ty, _)) => (checkTypesEq(ty, (#ty initExp), pos, "Initialized with incorrect type expected " 
                                                                                  ^ type_str (ty) ^ " got " ^ type_str (#ty (trexp init))); 
                                      {exp=R.arrayIR (#exp sizeExp, #exp initExp), ty=T.ARRAY(ty, ref ())})
                | SOME(_) => (err pos "Not an array type"; {exp=R.nilIR (), ty=T.UNIT})
              end
          | trexp (A.LetExp ({decs, body, pos})) =
              let fun transDecs (exps, venv, tenv, dec::decs) =
                      let val letEnv = transDec (level, breakLabel, venv, tenv, dec)
                      in
                        transDecs (exps@(#exps letEnv), #venv letEnv, #tenv letEnv, decs)
                      end
                  | transDecs (exps, venv, tenv, []) = {exps=exps, venv=venv, tenv=tenv}

                val letEnv = transDecs ([], venv, tenv, decs)
                val bodyTrexp = transExp (level, breakLabel, #venv letEnv, #tenv letEnv) body
              in {exp=R.letIR (#exps letEnv, #exp bodyTrexp), ty= #ty bodyTrexp}
              end
        and trvar (A.SimpleVar (id, pos)) =
          (case S.look (venv, id)
           of   SOME (E.VarEntry {access, ty}) => {exp = R.simpleVarIR (access, level),
                                                   ty = actual_ty (ty, pos)}
              | SOME (_) => (err pos "expected variable, got function"; err_result)
              | NONE => (err pos ("unknown variable: " ^ S.name id); err_result))
          | trvar (A.FieldVar (v, id, pos)) = 
              let val {exp, ty} = trvar v
              in  case ty of
                    T.RECORD (fieldList, _) =>
                        let 
                        in (case (List.find (fn x => (#1 x) = id) fieldList) of
                                                  NONE => let val errMsg = "Could not find field " ^ S.name id ^ "\n"
                                                                    ^ "    Expected: " ^ "{ " ^ S.name id ^ " : 'a, ...}\n"
                                                                    ^ "    Actual:   " ^ type_str ty
                                                          in (err pos errMsg;
                                                              err_result)
                                                           end
                                                | SOME (retValue) => {exp = R.unfinished,
                                                                      ty = actual_ty (#2retValue, pos)})
                        end
                   | t => (type_err (T.RECORD ([], ref ()), t, "Field access requires record type", pos); err_result)
              end
          | trvar (A.SubscriptVar (v, e, pos)) =
              let val {exp, ty} = trvar v
              in  case actual_ty (ty, pos) of
                      T.ARRAY (t, _) => let val {exp = exp1, ty = ty1} = trexp e
                                        in  case ty1 of
                                                T.INT => {exp = R.unfinished, ty = t}
                                              | t => (type_err (T.INT, t, "Subscript value must be an integer", pos); err_result)
                                        end
                    | t => type_err (T.ARRAY (T.UNIT, ref ()), t, "Must subscript an array", pos)
              end
    in trexp
    end

  fun transProg (absyn : Absyn.exp) =
    let val _ = ()
        (* Create the tenv and venv *)
        val venv : venv = E.base_venv
        val tenv : tenv = E.base_tenv
        val mainLabel = Temp.newlabel ()

        val mainLevel = R.nextLevel (R.outermost, mainLabel, [])

        (* Recurse through the abstract syntax tree *)
        val ir = #exp ((transExp (mainLevel, mainLabel, venv, tenv)) absyn)

        val _ = if (!ErrorMsg.anyErrors) then (raise TypeCheckError ([])) else ()
        val result = R.result ()
        val _ = reset ()

    in R.procedureEntryExit (mainLevel, ir, mainLabel); result
    end
    handle e => raise e
end