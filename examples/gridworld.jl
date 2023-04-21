# A simple grid world MDP
# All cells with reward are also terminal

using CommonRLInterface
using StaticArrays
using Compose
import ColorSchemes

const RL = CommonRLInterface

mutable struct GridWorld <: AbstractEnv
    size::SVector{2, Int}
    rewards::Dict{SVector{2, Int}, Float64}
    state::SVector{2, Int}
end

function GridWorld()
    rewards = Dict(SA[9,3]=> 10.0,
                   SA[8,8]=>  3.0,
                   SA[4,3]=>-10.0,
                   SA[4,6]=> -5.0)
    return GridWorld(SA[10, 10], rewards, SA[rand(1:10), rand(1:10)])
end

RL.reset!(env::GridWorld) = (env.state = SA[rand(1:env.size[1]), rand(1:env.size[2])])
RL.actions(env::GridWorld) = (SA[1,0], SA[-1,0], SA[0,1], SA[0,-1])
RL.observe(env::GridWorld) = env.state
RL.terminated(env::GridWorld) = haskey(env.rewards, env.state)

function RL.act!(env::GridWorld, a)
    if rand() < 0.4 # 40% chance of going in a random direction (=30% chance of going in a wrong direction)
        a = rand(actions(env))
    end

    env.state = clamp.(env.state + a, SA[1,1], env.size)

    return get(env.rewards, env.state, 0.0)
end

# optional functions
RL.observations(env::GridWorld) = [SA[x, y] for x in 1:env.size[1], y in 1:env.size[2]]
RL.clone(env::GridWorld) = GridWorld(env.size, copy(env.rewards), env.state)
RL.state(env::GridWorld) = env.state
RL.setstate!(env::GridWorld, s) = (env.state = s)

function RL.render(env::GridWorld)
    nx, ny = env.size
    cells = []
    for s in observations(env)
        r = get(env.rewards, s, 0.0)
        clr = get(ColorSchemes.redgreensplit, (r+10.0)/20.0)
        cell = context((s[1]-1)/nx, (ny-s[2])/ny, 1/nx, 1/ny)
        compose!(cell, rectangle(), fill(clr), stroke("gray"))
        push!(cells, cell)
    end
    grid = compose(context(), linewidth(0.5mm), cells...)
    outline = compose(context(), linewidth(1mm), rectangle(), stroke("gray"))

    s = env.state
    agent_ctx = context((s[1]-1)/nx, (ny-s[2])/ny, 1/nx, 1/ny)
    agent = compose(agent_ctx, circle(0.5, 0.5, 0.4), fill("orange"))

    sz = min(w,h)
    return compose(context((w-sz)/2, (h-sz)/2, sz, sz), agent, grid, outline)
end
