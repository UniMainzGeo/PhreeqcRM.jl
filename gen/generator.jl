using Clang.Generators
using Clang.LibClang.Clang_jll
using Pkg
using Pkg.Artifacts
using PhreeqcRM_jll

cd(@__DIR__)

# Exclude a few things

# headers 
PhreeqcRM_toml = joinpath(dirname(pathof(PhreeqcRM_jll)), "..", "Artifacts.toml")
PhreeqcRM_dir = Pkg.Artifacts.ensure_artifact_installed("PhreeqcRM", PhreeqcRM_toml)

# include dir
PhreeqcRM_include_dir = joinpath(PhreeqcRM_dir,"include")

# wrapper generator options
options = load_options(joinpath(@__DIR__, "generator.toml"))

# add compiler flags, e.g. "-DXXXXXXXXX"
args = get_default_args()
push!(args, "-I$PhreeqcRM_include_dir")

# Process necessary header files for the C interface in the include directory:
header_files = [joinpath(PhreeqcRM_include_dir, "RM_interface_C.h"),
                joinpath(PhreeqcRM_include_dir, "BMI_interface_C.h"),
                joinpath(PhreeqcRM_include_dir, "IPhreeqc.h")       ]


# create context
ctx = create_context(header_files, args, options)

# run generator
build!(ctx)