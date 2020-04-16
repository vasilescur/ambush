(* signature MAKEGRAPH =
sig
  type flowgraph
  type node
  (* val instrs2graph: Assem.instr list -> 'a flowgraph * 'a node list *)
end *)

structure MakeGraph =
struct
  structure G = Flow.G
  structure A = Assem
  structure S = Symbol
  structure Err = ErrorMsg

  exception NoneJump of string

  type flowgraph = Flow.graph
  type node = Flow.node

  (* Converts an instruction to one node
      Returns: a node *)
  fun makenode (A.OPER {assem, dst, src, jump}) = (assem, dst, src, false, jump)
    | makenode (A.LABEL {assem, lab}) = (assem, [], [], false, NONE)
    | makenode (A.MOVE {assem, dst, src}) = (assem, [dst], [src], true, NONE)


  (* Adds all of the instructions as nodes to the graph
      Returns: (graph * label map) *)
  fun addnodes (graph, [], map, id) = (graph, map)
    | addnodes (graph, A.LABEL {assem, lab}::instrs, map, id) = let val nodeInfo = makenode (A.LABEL {assem=assem, lab=lab})
                                                                    val (graph, node) = G.addNode' (graph, id, nodeInfo)
                                                                in (addnodes (graph, instrs, S.enter (map, lab, node), id + 1))
                                                                end
    | addnodes (graph, instr::instrs, map, id) = (addnodes (G.addNode (graph, id, makenode (instr)), instrs, map, id + 1))

  (* Makes edge from prev to node
        Returns graph *)
  fun addnextedge (graph, node, prev) = (case prev of
                                              NONE => graph
                                            | SOME (prevnode) => G.addEdge (graph, {from=G.getNodeID (prevnode), 
                                                                                    to=G.getNodeID (node)}))

  fun addjumps (graph, labelmap, node, jumps) = 
    foldl (fn (lbl, graph) => let val nodeOption = S.look (labelmap, lbl)
                                  val nodeValue = case nodeOption of 
                                                      SOME (nodeVal) => nodeVal
                                                    | NONE => (Err.error 0 ("name = " ^ Symbol.name lbl); raise NoneJump ("name = " ^ Symbol.name lbl))
                              in  G.addEdge (graph, {from=G.getNodeID (node), 
                                                     to=G.getNodeID (valOf (S.look (labelmap, lbl)))})
                              end)
          graph 
          jumps
                              

  (* Adds edges to the control flow graph
      Returns: graph *)
  fun addedges (graph, labelmap, [], prev) = graph
    | addedges (graph, labelmap, node::nodes, prev) = 
        let val (_,_,_,_,jump) = G.nodeInfo (node)
        in  (case jump of
                NONE => addedges (addnextedge (graph, node, prev), 
                                  labelmap, nodes, SOME (node))
              | SOME (jumps) => addedges (addnextedge (addjumps (graph, labelmap, node, jumps), node, prev), labelmap, nodes, SOME(node)))
        end

  fun instrs2graph (instrs) = let val (nodeGraph, labelmap) = addnodes (G.empty, instrs, S.empty, 0)
                                  val edgeGraph = addedges (nodeGraph, labelmap, G.nodes (nodeGraph), NONE)

                              in  (edgeGraph, G.nodes (edgeGraph))
                              end
end