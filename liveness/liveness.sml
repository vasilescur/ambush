signature LIVENESS =
sig
  type igraph
  type node
  (* val interferenceGraph : Flow.flowgraph -> igraph * (node -> Temp.temp list)
  val show : outstream * igraph -> unit *)
end

structure Liveness : LIVENESS =
struct
  structure G = FuncGraph (NodeKey)
  type igraph = G.graph
  type node = Flow.node
  datatype igraph = IGRAPH of {graph: igraph,
                               tnode: Temp.temp -> node,
                               gtemp: node -> Temp.temp,
                               moves: (node * node) list}
end