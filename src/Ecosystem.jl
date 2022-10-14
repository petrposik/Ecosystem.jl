module Ecosystem

using StatsBase

export World
export Species, PlantSpecies, AnimalSpecies, Grass, Sheep, Wolf
export Agent, Plant, Animal
export agent_step!, eat!, eats, find_food, reproduce!, world_step!, agent_count

abstract type Species end
abstract type Agent{S<:Species} end

include("animals.jl")
include("plants.jl")
include("world.jl")

end