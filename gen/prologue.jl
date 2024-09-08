#
# START OF PROLOGUE
#
using MAGEMin_C, PhreeqcRM_jll
const HASH_JEN = 0;


function __init__()
    global libPhreeqcRM = PhreeqcRM_jll.libPhreeqcRM
    println("Using libPhreeqcRM.dylib from PhreeqcRM_jll")
end

#
# END OF PROLOGUE
#