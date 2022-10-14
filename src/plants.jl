abstract type PlantSpecies <: Species end
abstract type Grass <: PlantSpecies end

mutable struct Plant{P<:PlantSpecies} <: Agent{P}
    const id::Int
    size::Int
    const max_size::Int
end

# constructor for all Plant{<:PlantSpecies} callable as PlantSpecies(...)
(A::Type{<:PlantSpecies})(id, s, m) = Plant{A}(id, s, m)
(A::Type{<:PlantSpecies})(id, m) = (A::Type{<:PlantSpecies})(id, rand(1:m), m)

# default specific for Grass
# Grass(id; size, max_size) = Grass(id, size, max_size)
Grass(id; max_size=10) = Grass(id, rand(1:max_size), max_size)

function Base.show(io::IO, p::Plant{P}) where {P}
    x = p.size / p.max_size * 100
    print(io, "$P  #$(p.id) $(round(Int,x))% grown")
end

Base.show(io::IO, ::Type{Grass}) = print(io, "🌿")
