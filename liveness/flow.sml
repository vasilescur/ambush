structure Flow  =
struct
  structure G = FuncGraph (NodeKey)
  structure T = IntMapTable (type key = int
                             fun getInt(n) = n)
  type node = string * Temp.temp list * Temp.temp list * (Temp.temp * Temp.temp) option * Temp.label list option
  type graph = node G.graph

  fun printNode (nid, (assem, def, use, ismove, jump)) = Int.toString nid ^ ": " ^ assem
  fun printNodeForVis (nid, (assem, def, use, ismove, jump)) = 
    Int.toString nid ^ ": " ^ String.translate (fn (c) => (case c of 
                                                            #"\n" => "|"
                                                          | _ => Char.toString c)) (let val format0 = (* Assem.format(Temp.makestring) *) (fn x => x)
                                                                                    in  (format0 assem)
                                                                                    end)
end