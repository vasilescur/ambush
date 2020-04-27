signature TEMP = 
sig
  eqtype temp
  val reset : unit -> unit
  val start : unit -> unit
  val newtemp : unit -> temp
  val compare : temp * temp -> order
  val makestring: temp -> string
  type label = Symbol.symbol
  val newlabel : unit -> label
  val namedlabel : string -> label
  structure Set : ORD_SET sharing type Set.Key.ord_key = temp
  structure Map : ORD_MAP sharing type Map.Key.ord_key = temp
  type ord_key = temp
  type set = Set.set
  type 'a map = 'a Map.map
  val tempSetToString : set -> string
end