module PhreeqcRM

using PhreeqcRM_jll

database_dir = joinpath(PhreeqcRM_jll.artifact_dir,"share","phreeqcrm","database")
export database_dir

testfile_dir = joinpath(PhreeqcRM_jll.artifact_dir,"share","phreeqcrm","test_input")
export testfile_dir

# load the auto-generated library
include("../gen/phreeqcrm_library.jl")
export LibPhreeqcRM # this exports all functions from the library


end # module PhreeqcRM
