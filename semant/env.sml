structure Env : ENV =
struct
  type access = unit
  type level = unit
  type ty = Types.ty

  datatype enventry = VarEntry of {ty: ty, access: unit}
                    | FunEntry of {formals: ty list, result: ty}
  
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