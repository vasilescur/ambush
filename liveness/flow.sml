structure Flow  =
struct
  structure G = FuncGraph (NodeKey)
  structure T = IntMapTable (type key = int
                             fun getInt(n) = n)
  type node = string * Temp.temp list * Temp.temp list * bool * Temp.label list option
  type graph = node G.graph
  datatype flowgraph = FGRAPH of {control: graph,
                                  def: Temp.temp list T.table,
                                  use: Temp.temp list T.table,
                                  ismove: bool T.table}

  fun printNode (nid, (assem, def, use, ismove, jump)) = Int.toString nid ^ ": " ^ assem
end