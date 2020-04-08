functor Env (T : Translate) : ENV =
struct
  type access = T.access
  type ty = Types.ty

  datatype enventry = VarEntry of {ty: ty, access: access}
                    | FunEntry of {level: Translate.level,
                                   label: Temp.label,
                                   formals: ty list, 
                                   result: ty}
  
  (* Base type environment -- built in types "int" and "string" *)
  val base_tenv = Symbol.enter (
                    Symbol.enter (
                      Symbol.empty,
                      Symbol.symbol("int"),
                      Types.INT),
                    Symbol.symbol("string"),
                    Types.STRING)


  val base_venv = Symbol.empty
end