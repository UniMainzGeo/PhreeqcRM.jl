using Test

@testset verbose = true "PhreeqcRM.jl" begin
    @testset "Gas" begin
       include("../examples/Gas.jl")
       @test sum(gas_moles) ≈ 9.816410771596727
    end

    @testset "SimpleAdvect" begin
        include("../examples/SimpleAdvect.jl")
        @test sum(c) ≈ 3320.5095765320457
     end
 
end