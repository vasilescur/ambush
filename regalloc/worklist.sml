structure Worklist =
struct
  structure TempSet = Temp.Set
  structure TempMap = Temp.Map
  type color = int
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

  fun simplify ({init, simplify, freeze, spill, spilled, coalesced, colored, select}, temp) =
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
