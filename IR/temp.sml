structure Temp :> TEMP =
struct
    type temp = int
    type ord_key = temp

    val labelCount = ref 0
    val temps = ref 0

    fun reset () = 
        let val () = temps := 0
            val () = labelCount := 0
        in
            ()
        end


    fun newtemp() = 
        let val t  = !temps 
            val () = temps := t+1
        in 
            t
        end
        
    fun makestring t = "t" ^ Int.toString t
		       
    type label = Symbol.symbol
    val compare = Int.compare
    structure TempOrd =
    struct 
      type ord_key = temp
      val compare = compare
    end

    structure Set = SplaySetFn(TempOrd)
    structure Map = SplayMapFn(TempOrd)

    type 'a map = 'a Map.map 
    type set = Set.set

    fun tempSetToString (ts) = 
      (Set.foldl (fn (item, s) => s ^ ", " ^ (makestring item)) "" ts)
			 
    fun newlabel() = 
	let 
	    val x  = !labelCount
	    val _ = labelCount := x + 1
	in
	    Symbol.symbol ("L" ^ Int.toString x)
	end
    val namedlabel = Symbol.symbol


end

