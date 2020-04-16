functor Env (T : TRANSLATE) : ENV =
struct
  type access = T.access
  type level = T.level
  type ty = Types.ty

  datatype enventry = VarEntry of {access: T.access,
                                   ty: ty}
                    | FunEntry of {level: level,
                                   label: Temp.label,
                                   formals: ty list, 
                                   result: ty ref}
  
  (* Base type environment -- built in types "int" and "string" *)
  val base_tenv = Symbol.enter (
                    Symbol.enter (
                      Symbol.empty,
                      Symbol.symbol("int"),
                      Types.INT),
                    Symbol.symbol("string"),
                    Types.STRING)


  val base_venv = 
    (* let val _ = ()
        (* let fun addToVenv ((s, t), table) = S.enter (table, S.symbol s, t) *)
        (* val library_funs = [
            ("print", FunEntry ({level=T.outermost, label=Temp.namedlabel "__print", formals=[T.STRING], result=T.UNIT})),

        ]       *)
    in  Symbol.empty
    end *)
    Symbol.empty
end