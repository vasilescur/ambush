CM.make "sources.cm";

fun runTest (testCount) =
    let val filename = (concat ["testcases/test", Int.toString testCount])
    in
      Main.compile filename;
      ()
    end;

(* runTest 1; *)