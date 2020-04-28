functor Env (T : TRANSLATE) : ENV =
struct
  structure Ty = Types
  structure S = Symbol
  type access = T.access
  type level = T.level
  type ty = Ty.ty

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
    let fun addToVenv ((s, t), table) = Symbol.enter (table, S.symbol s, t)
        val library_funs = [
            ("print", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_print", formals=[Ty.STRING], result=ref Ty.UNIT})),
            ("print_int", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_print_int", formals=[Ty.INT], result=ref Ty.UNIT})),
            ("flush", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_flush", formals=[], result=ref Ty.UNIT})),
            ("getchar", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_getchar", formals=[], result=ref Ty.STRING})),
            (* ("ord", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_ord", formals=[Ty.STRING], result=ref Ty.INT})), *)
            ("chr", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_chr", formals=[Ty.INT], result=ref Ty.STRING})),
            ("size", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_size", formals=[Ty.STRING], result=ref Ty.INT})),
            (* ("substring", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_substring", formals=[Ty.STRING, Ty.INT, Ty.INT], result=ref Ty.STRING})), *)
            (* ("concat", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_concat", formals=[Ty.STRING, Ty.STRING], result=ref Ty.STRING})), *)
            ("not", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_not", formals=[Ty.INT], result=ref Ty.INT})),
            ("exit", FunEntry ({level=T.outermost, label=Temp.namedlabel "tig_exit", formals=[Ty.INT], result=ref Ty.UNIT}))
        ] 
        
    in  foldl addToVenv Symbol.empty library_funs
    end
end