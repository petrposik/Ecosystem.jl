using Plots
using Ecosystem

n_grass = 1_000
n_sheep = 40
n_wolves = 4

gs = [Grass(id) for id in 1:n_grass]
ss = [Sheep(id) for id in (n_grass+1):(n_grass+n_sheep)]
ws = [Wolf(id) for id in (n_grass+n_sheep+1):(n_grass+n_sheep+n_wolves)]
w = World(vcat(gs, ss, ws))

counts = Dict(n => [c] for (n, c) in agent_count(w))
for _ in 1:100
    world_step!(w)
    for (n, c) in agent_count(w)
        push!(counts[n], c)
    end
end

using Plots
plt = plot(yaxis=:log)
tolabel(::Type{Animal{Sheep}}) = "Sheep"
tolabel(::Type{Animal{Wolf}}) = "Wolf"
tolabel(::Type{Plant{Grass}}) = "Grass"
for (A, c) in counts
    plot!(plt, c, label=tolabel(A), lw=2)
end
plt