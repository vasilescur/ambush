structure Env : ENV =
struct
  type ty = Types.ty
  datatype enventry = VarEntry of {ty: ty}
                    | FunEntry of {formals: ty list, result: ty}
  
  val base_tenv = Symbol.empty
  val base_venv = Symbol.empty
end