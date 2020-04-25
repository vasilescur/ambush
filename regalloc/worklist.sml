functor Worklist (F : FRAME) =
struct

  type color = F.register

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

  val empty = {init=Temp.Set.empty,
               simplify=Temp.Set.empty,
               freeze=Temp.Set.empty,
               spill=Temp.Set.empty,
               spilled=Temp.Set.empty,
               coalesced=Temp.Set.empty,
               colored=Temp.Map.empty,
               select=Temp.Set.empty}

  fun create (inits : Temp.temp list, initialColoring : color Temp.map) =
        let val {init, simplify, freeze, spill, spilled, coalesced, colored, select} = empty
            val init' = List.foldl Temp.Set.add' init inits
            fun removePrecolored (temp, reg, set) = if   Temp.Set.member (set, temp)
                                                    then Temp.Set.delete (set, temp)
                                                    else set
            val init' = Temp.Map.foldli removePrecolored init' initialColoring
            val recordNew = {init=init', 
                             simplify=simplify, 
                             freeze=freeze, 
                             spill=spill, 
                             spilled=spilled, 
                             coalesced=coalesced, 
                             colored=initialColoring, 
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
        let
            val _ = print ("Trying to W.add " ^ Temp.makestring temp ^ "\n")
            val init' = Temp.Set.delete (init, temp)
            val simplify' = Temp.Set.add (simplify, temp)
            val recordNew = {init=init, 
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
        let 
            val _ = print ("Trying to W.add " ^ Temp.makestring temp ^ "\n")
            val init' = Temp.Set.delete (init, temp)
            val simplify' = Temp.Set.add (simplify, temp)
            val recordNew = {init=init, 
                             simplify=simplify', 
                             freeze=freeze, 
                             spill=spill, 
                             spilled=spilled, 
                             coalesced=coalesced, 
                             colored=colored, 
                             select=select}
        in recordNew
        end

  fun stack (temp, {init, simplify, freeze, spill, spilled, coalesced, colored, select}) =
        let (*val simplify' = Temp.Set.delete (simplify, temp)*)
            val select' = Temp.Set.add (select, temp)
            val recordNew = {init=init, 
                             simplify=simplify, 
                             freeze=freeze, 
                             spill=spill, 
                             spilled=spilled, 
                             coalesced=coalesced, 
                             colored=colored, 
                             select=select'}
        in recordNew
        end

  fun color ({init, simplify, freeze, spill, spilled, coalesced, colored, select},
             temp, color : color) =
        let val select' = if Temp.Set.member (select, temp)
                          then Temp.Set.delete (select, temp)
                          else (print "Temp not in select"; select)
            val colored' : color Temp.map = Temp.Map.insert (colored, temp, color)
            val recordNew = {init=init,
                             simplify=simplify,
                             freeze=freeze,
                             spill=spill,
                             spilled=spilled,
                             coalesced=coalesced,
                             colored=colored',
                             select=select}
        in recordNew
        end

  (* Getter methods *)
  fun colored ({init, simplify, freeze, spill, spilled, coalesced, colored, select}) = colored
  fun init ({init, simplify, freeze, spill, spilled, coalesced, colored, select}) = init
  fun select ({init, simplify, freeze, spill, spilled, coalesced, colored, select}) = select
  fun simplify ({init, simplify, freeze, spill, spilled, coalesced, colored, select}) = simplify

end
