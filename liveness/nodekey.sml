structure NodeKey : ORD_KEY =
struct
  type ord_key = int
  val compare = Int.compare
end