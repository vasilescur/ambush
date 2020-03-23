structure Types =
struct
  type unique = unit ref

  datatype ty = 
            RECORD of (Symbol.symbol * ty) list * unique
          | NIL
          | INT
          | STRING
          | ARRAY of ty * unique
          | NAME of Symbol.symbol * ty option ref
          | UNIT
          | BOTTOM

  fun eq (INT, INT) = true
    | eq (STRING, STRING) = true
    | eq (ARRAY (_, unique1), ARRAY (_, unique2)) = (unique1 = unique2)
    | eq (RECORD(_, unique1), RECORD(_, unique2)) = (unique1 = unique2)
    | eq (NIL, NIL) = true 
    | eq (_, UNIT) = true
    | eq (UNIT, _) = true 
    | eq (NIL, RECORD(_)) = true 
    | eq (RECORD(_), NIL) = true
    | eq (NAME(symb1, _), NAME(symb2, _)) = (String.compare(Symbol.name symb1, 
                                                            Symbol.name symb2) = EQUAL)  
    | eq (_, _) = false


end