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
    @test haskey(env.rewards, state(env))
    
    env2 = GW.GridWorld()
    @test state(clone(env2)) == state(env2)
    setstate!(env, state(env2))
    @test state(env) == state(env2)
    @test observe(env) == observe(env2)
    @test observations(env) == observations(env2)
end
