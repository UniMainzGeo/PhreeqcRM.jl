module PhreeqcRM

using PhreeqcRM_jll

# load the auto-generated library
include("../gen/phreeqcrm_library.jl")
export LibPhreeqcRM # this exports all functions from the library


end # module PhreeqcRM
