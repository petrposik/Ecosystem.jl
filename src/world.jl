
mutable struct World{A<:Agent}
    agents::Dict{Int,A}
    max_id::Int
end

function World(agents::Vector{<:Agent})
    max_id = maximum(a.id for a in agents)
    World(Dict(a.id => a for a in agents), max_id)
end

function Base.show(io::IO, w::World)
    println(io, typeof(w))
    for (_, a) in w.agents
        println(io, "  $a")
    end
end

function eat!(wolf::Animal{Wolf}, sheep::Animal{Sheep}, w::World)
    wolf.energy += sheep.energy * wolf.Δenergy
    kill_agent!(sheep, w)
end
function eat!(sheep::Animal{Sheep}, grass::Plant{Grass}, ::World)
    sheep.energy += grass.size * sheep.Δenergy
    grass.size = 0
end
eat!(::Animal, ::Nothing, ::World) = nothing

kill_agent!(a::Agent, w::World) = delete!(w.agents, a.id)

function find_mate(a::Animal, w::World)
    ms = filter(x -> mates(x, a), w.agents |> values |> collect)
    isempty(ms) ? nothing : sample(ms)
end
mates(a::Animal{A}, b::Animal{A}) where {A<:AnimalSpecies} = a.sex != b.sex
mates(::Agent, ::Agent) = false

function reproduce!(a::Animal{A}, w::World) where {A}
    m = find_mate(a, w)
    if !isnothing(m)
        a.energy = a.energy / 2
        vals = [getproperty(a, n) for n in fieldnames(Animal) if n ∉ [:id, :sex]]
        new_id = w.max_id + 1
        ŝ = Animal{A}(new_id, vals..., randsex())
        w.agents[ŝ.id] = ŝ
        w.max_id = new_id
    end
end

# finding food / who eats who
function find_food(a::Animal, w::World)
    as = filter(x -> eats(a, x), w.agents |> values |> collect)
    isempty(as) ? nothing : sample(as)
end
eats(::Animal{Sheep}, g::Plant{Grass}) = g.size > 0
eats(::Animal{Wolf}, ::Animal{Sheep}) = true
eats(::Agent, ::Agent) = false


##########  Stepping through time  #############################################

# At the beginning of each step an animal looses energy. 
# Afterwards it tries to find some food, which it will subsequently eat. 
# If the animal then has less than zero energy it dies and is removed from the world. 
# If it has positive energy it will try to reproduce.
function agent_step!(a::Animal, w::World)
    a.energy -= 1
    if rand() <= a.foodprob
        dinner = find_food(a, w)
        eat!(a, dinner, w)
    end
    if a.energy <= 0
        kill_agent!(a, w)
        return
    end
    if rand() <= a.reprprob
        reproduce!(a, w)
    end
    return a
end

# Plants have a simpler life. 
# They simply grow if they have not reached their maximal size.
function agent_step!(p::Plant, ::World)
    if p.size < p.max_size
        p.size += 1
    end
end

function world_step!(world::World)
    # make sure that we only iterate over IDs that already exist in the
    # current timestep this lets us safely add agents
    ids = copy(keys(world.agents))

    for id in ids
        # agents can be killed by other agents, so make sure that we are
        # not stepping dead agents forward
        !haskey(world.agents, id) && continue

        a = world.agents[id]
        agent_step!(a, world)
    end
end


##########  Counting agents  ####################################################

agent_count(p::Plant) = p.size / p.max_size
agent_count(::Animal) = 1
agent_count(as::Vector{<:Agent}) = sum(agent_count, as)

function agent_count(w::World)
    function op(d::Dict, a::A) where {A<:Agent}
        if A in keys(d)
            d[A] += agent_count(a)
        else
            d[A] = agent_count(a)
        end
        return d
    end
    foldl(op, w.agents |> values |> collect, init=Dict())
end

