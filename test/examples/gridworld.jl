module GW
    include("../../examples/gridworld.jl")
end

@testset "gridworld" begin

    env = GW.GridWorld()
    reset!(env)
    while !terminated(env)
        act!(env, rand(actions(env)))
        render(env)
    end
end
