CM.make "sources.cm";

fun runTest (testCount) =
    let val filename = (concat ["testcases/test", Int.toString testCount ,".tig"])
    in
      Main.main filename;
      ()
    end;

runTest 1;