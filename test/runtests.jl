using Ecosystem
using Ecosystem: male, female
using Test

@testset "Ecosystem.jl" begin

    @testset "Grass" begin

        @testset "Base.show" begin
            g = Grass(1, 1, 1)
            @test repr(g) == "🌿  #1 100% grown"
        end

    end

    include("test_sheep.jl")
    include("test_wolf.jl")
end
