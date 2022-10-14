# Another testset should be in the file test/wolf.jl 
# and veryfiy that the function eat!(::Wolf, ::Sheep, ::World) works correctly.

@testset "Wolf tests" begin

    @testset "Base.show" begin
        w = Animal{Wolf}(3, 1, 1, 1, 1, female)
        @test repr(w) == "🐺♀ #3 E=1.0 ΔE=1.0 pr=1.0 pf=1.0"
    end

    @testset "eat!" begin
        # Create a Wolf with food probability pf=1p_f=1pf​=1
        w = Wolf(1, pf=1.0)
        # Create a Sheep and a World with the two agents.
        s = Sheep(2)
        world = World([w, s])
        # Execute `eat!(::Wolf, ::Sheep, ::World)
        eat!(w, s, world)
        # @test that the World only has one agent left in the agents dictionary
        @test length(world.agents) == 1
    end
end