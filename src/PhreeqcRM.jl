module PhreeqcRM

using PhreeqcRM_jll

database_dir = joinpath(PhreeqcRM_jll.artifact_dir,"database")
export database_dir

# load the auto-generated library
include("../gen/phreeqcrm_library.jl")
export LibPhreeqcRM # this exports all functions from the library


end # module PhreeqcRM
