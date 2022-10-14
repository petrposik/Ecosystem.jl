# One testset should be contained in a file test/sheep.jl 
# and verify that the function eat!(::Sheep, ::Grass, ::World) works correctly.

@testset "Sheep tests" begin

    @testset "Base.show" begin
        s = Animal{Sheep}(2, 1, 1, 1, 1, male)
        @test repr(s) == "🐑♂ #2 E=1.0 ΔE=1.0 pr=1.0 pf=1.0"
    end

    @testset "eat!" begin
        # Create a Sheep with food probability pf=1
        s = Sheep(1, pf=1.0)
        # Create fully grown Grass and a World with the two agents.
        g = Grass(2, 10, 10)
        w = World([s, g])
        # Execute `eat!(::Sheep, ::Grass, ::World)
        eat!(s, g, w)
        # @test that the size of the Grass now has size == 0
        @test g.size == 0
    end

end