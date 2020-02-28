structure Semant : SEMANT =
struct
    (* Shortcuts *)
  structure A = Absyn
  structure E = Env
  structure S = Symbol
  structure T = Types 
  structure R = Translate

  type venv = E.enventry S.table
  type tenv = E.ty S.table

  type expty = {exp: R.exp, ty: T.ty}

  (* Return value for cases where type checking failed *)
  val err_result = {exp = () (*R.errexp*), ty = T.NIL}

  val err = ErrorMsg.error

  (* Shortcut function for type errors *)
  fun type_err (exp, act, pos) =
    ((err pos ("expected " ^ exp ^ ", found " ^ act)); 
     err_result)

  (* 
  val transVar: venv * tenv * Absyn.var -> expty
  val transExp: venv * tenv * Absyn.exp -> expty
  val transDec: venv * tenv * Absyn.dec -> {venv: venv, tenv: tenv}
  val transTy: tenv * Absyn.ty -> Types.ty
  *)
  

  (* Gets the name of a type as a string *)
  fun type_str T.NIL = "nil"
    | type_str T.UNIT = "unit"
    | type_str T.INT = "int"
    | type_str T.STRING = "string"
    | type_str T.NAME (sym, _) = "name of " ^ S.name sym
    | type_str T.ARRAY (ty, _) = "array of " ^ type_str ty
    | type_str T.RECORD (_, _) = "record"

  (* Gets the *actual* type from NAME or ARRAY *)
  fun actual_ty (ty, pos) = 
    case ty of 
        T.NAME (sym, tyref) => (case (!tyref) of
                                    NONE => (err pos ("unknown type " ^ S.name sym); T.NIL)
                                  | SOME (ty) => actual_ty (ty, pos))
      | T.ARRAY (ty, unique) => T.ARRAY(actual_ty (ty, pos), unique)
      | _ => ty


  (* Check if an expression is an integer *)
  fun checkInt ({exp = _, ty = Types.INT}, pos) = ()
    | checkInt ({exp = _, ty = t}, pos) = (type_err ("int", type_str t, pos); ());

  fun checkTypesEq (ty1, ty2, pos, errMsg) = if (Types.eq (ty1, ty2))
                                             then ()
                                             else (err pos errMsg)
    
  type env = {tenv: tenv, venv: venv}
  val base_env : env = {tenv=Env.base_tenv, venv=Env.base_venv}

  fun transExp(venv, tenv) =
    let val env : env = {venv = venv, tenv = tenv}
        fun trexp (A.OpExp {left, oper, right, pos}) =
                    (checkInt(trexp left, pos);
                    checkInt(trexp right, pos);
                    {exp=(), ty=Types.INT})
          | trexp (A.VarExp (var)) = trvar var
          | trexp (A.LetExp ({decs, body, pos})) = 
              let
                  val letEnv = transDecs(venv,tenv,decs)
              in
                {exp=(), ty=transExp(letEnv.venv, letEnv.tenv) body}
              end
          | trexp (_) = (err 0 "EXPRESSION UNSUPPORTED: NEEDS TO BE IMPLEMENTED";
                    {exp=(), ty=Types.NIL})
        and trvar (A.SimpleVar (id, pos)) =
          (case S.lookup (venv, id)
           of   SOME (E.VarEntry {access, ty}) => {exp = (),
                                                   ty = actual_ty (ty, pos)}
              | SOME (_) => (err pos "expected variable, got function"; err_result)
              | NONE => (err pos "unknown variable: " ^ S.name id; err_result))
          | trvar (A.FieldVar (v, id, pos)) = 
              let val {exp, ty} = trvar v
              in  case ty of
                    T.RECORD (fieldList, _) => (case (List.find (fn x => (#1x) = id) fieldList) of
                                                  NONE => (err pos ("identifier not found: " ^ S.name id);
                                                           err_result)
                                                | SOME (retValue) => {exp = (),
                                                                      ty = actual_ty (#2retValue, pos)})
                   | t => (err pos ("expected record type, found " ^ type_str t); err_result)
              end
          | trvar (A.SubscriptVar (v, e, pos)) =
              let val {exp, ty} = trvar v
              in  case actual_ty (ty, pos) of
                      T.ARRAY (t, _) => let val {exp = exp1, ty = ty1} = trexp e
                                        in  case ty1 of
                                                T.INT => {exp = (), ty = t}
                                              | t => (err pos ("expected int in array subscript, found " ^ type_str t); err_result)
                                        end
                    | t => type_err ("array", type_str t, pos)
              end
        
    in  trexp
    end

    fun transDec (venv, tenv, A.VarDec{name, typ=NONE, init,...}) = 
        let val {exp, ty} = (transExp(venv, tenv)) init
          in {tenv=tenv,
              venv=S.enter(venv,name,E.VarEntry{ty=ty})}
          end
      | transDec (venv, tenv, A.TypeDec[{name,ty}]) = 
          {venv=venv,
           tenv=S.enter(tenv, name, transTy(tenv,ty))}
     (* Also need function declarations here. Book has code for 
       non-recursive functions, pg 17/21, ch5*)

  (* transProg : Absyn.exp -> unit *)
  fun transProg (absyn : Absyn.exp) : unit =
    let
      val _ = ()

      (* Create the tenv and venv *)
      val venv : venv = Env.base_venv
      val tenv : tenv = Env.base_tenv

      (* Recurse through the abstract syntax tree *)
      val ir : expty = (transExp (venv, tenv)) absyn

    in
      ()
    end
end