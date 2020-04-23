structure Worklist =
struct
  structure TempSet = Temp.Set
  structure TempMap = Temp.Map
  type color = int

  datatype add = LOW | HIGH | MOVE

  exception SpillException

  type worklist = {init: Temp.set,
                   simplify: Temp.set,
                   freeze: Temp.set,
                   spill: Temp.set,
                   spilled: Temp.set,
                   coalesced: Temp.set,
                   colored: color Temp.map,
                   select: Temp.set}

  val empty = {init=TempSet.empty,
               simplify=TempSet.empty,
               freeze=TempSet.empty,
               spill=TempSet.empty,
               spilled=TempSet.empty,
               coalesced=TempSet.empty,
               colored=TempMap.empty,
               select=TempSet.empty}

  fun init (inits) =
        let val {init, simplify, freeze, spill, spilled, coalesced, colored, select} = empty
            val init' = List.foldl TempSet.add' init inits
            val recordNew = {init=init', 
                             simplify=simplify, 
                             freeze=freeze, 
                             spill=spill, 
                             spilled=spilled, 
                             coalesced=coalesced, 
                             colored=colored, 
                             select=select}
        in recordNew
        end

  (* Adds temps based on whether they are non-move low-degree (LOW),
   * high-degree (HIGH), or low-degree move (MOVE) temps
   * Currently, move temps are treated like LOW temps because coalesce
   * is not implemented, and since spill is not implemented, adding a HIGH
   * temp results in an exception.
   *)
  fun add ({init, simplify, freeze, spill, spilled, coalesced, colored, select}, LOW, temp) = 
        let val init' = TempSet.delete (init, temp)
            val simplify' = TempSet.add (simplify, temp)
            val recordNew = {init=init', 
                             simplify=simplify', 
                             freeze=freeze, 
                             spill=spill, 
                             spilled=spilled, 
                             coalesced=coalesced, 
                             colored=colored, 
                             select=select}
        in recordNew
        end
    | add ({init, simplify, freeze, spill, spilled, coalesced, colored, select}, HIGH, temp) = raise SpillException
    | add ({init, simplify, freeze, spill, spilled, coalesced, colored, select}, MOVE, temp) = 
        let val init' = TempSet.delete (init, temp)
            val simplify' = TempSet.add (simplify, temp)
            val recordNew = {init=init', 
                             simplify=simplify', 
                             freeze=freeze, 
                             spill=spill, 
                             spilled=spilled, 
                             coalesced=coalesced, 
                             colored=colored, 
                             select=select}
        in recordNew
        end

  fun stack ({init, simplify, freeze, spill, spilled, coalesced, colored, select}, temp) =
        let val simplify' = TempSet.delete (simplify, temp)
            val select' = TempSet.add (select, temp)
            val recordNew = {init=init, 
                             simplify=simplify', 
                             freeze=freeze, 
                             spill=spill, 
                             spilled=spilled, 
                             coalesced=coalesced, 
                             colored=colored, 
                             select=select'}
        in recordNew
        end

  fun color ({init, simplify, freeze, spill, spilled, coalesced, colored, select},
             temp, color) =
        let val select' = TempSet.delete (select, temp)
            val colored' = TempMap.insert (colored, temp, color)
            val recordNew = {init=init,
                             simplify=simplify,
                             freeze=freeze, 
                             spill=spill, 
                             spilled=spilled, 
                             coalesced=coalesced, 
                             colored=colored', 
                             select=select'}
        in recordNew
        end

  (* Getter methods *)
  fun colored ({init, simplify, freeze, spill, spilled, coalesced, colored, select}) = colored

end
