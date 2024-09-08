using Test

@testset verbose = true "PhreeqcRM.jl" begin
    @testset "Gas" begin
       include("../examples/Gas.jl")
       @test sum(gas_moles) ≈ 9.816410771596727
    end

end