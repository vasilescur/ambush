functor Env (T : TRANSLATE) : ENV =
struct
  type access = unit
  type level = T.level
  type ty = Types.ty

  datatype enventry = VarEntry of {access: access,
                                   ty: ty}
                    | FunEntry of {level: level,
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