signature ENV =
sig
  type access
  type level
  
  type ty
  datatype enventry = 
      VarEntry of {access: access,
                   ty: ty}
    | FunEntry of {level: level,
                    label: Temp.label,
                    formals: ty list, 
                    result : ty}

  val base_tenv : ty Symbol.table (* predefined types*)
  val base_venv : enventry Symbol.table (* predefined functions*)
end