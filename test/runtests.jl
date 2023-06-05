using CommonRLInterface
using Test
using Documenter: doctest

doctest(CommonRLInterface)

mutable struct LQREnv <: AbstractEnv
    s::Float64
end

@testset "from README" begin

    function CommonRLInterface.reset!(m::LQREnv)
        m.s = 0.0
    end

    CommonRLInterface.actions(m::LQREnv) = [-1.0, 0.0, 1.0]
    CommonRLInterface.observe(m::LQREnv) = m.s
    CommonRLInterface.terminated(m::LQREnv) = false

    function CommonRLInterface.act!(m::LQREnv, a)
        r = -m.s^2 - a^2
        m.s = m.s + a + randn()
        return r
    end

    env = LQREnv(0.0)
    reset!(env)
    acts = actions(env)
    rsum = 0.0
    step = 1
    while !terminated(env) && step <= 10
        rsum += act!(env, rand(acts)) 
        step += 1
    end
    @show rsum
end

# a reference MDP Env
mutable struct MyEnv <: AbstractEnv
    state::Int
end
MyEnv() = MyEnv(1)
function CommonRLInterface.reset!(env::MyEnv)
    env.state = 1
end
CommonRLInterface.actions(env::MyEnv) = [-1, 0, 1]
CommonRLInterface.observe(env::MyEnv) = env.state
CommonRLInterface.terminated(env::MyEnv) = false
function CommonRLInterface.act!(env::MyEnv, a)
    env.state = clamp(env.state + a, 1, 10)
    return -o^2
end
env = MyEnv(1)

# a reference Game Env
mutable struct MyGame <: AbstractEnv
    state::Int
end
MyGame() = MyGame(1)
function CommonRLInterface.reset!(env::MyGame)
    env.state = 1
end
CommonRLInterface.actions(env::MyGame) = [-1, 1]
CommonRLInterface.observe(env::MyGame) = env.state
CommonRLInterface.terminated(env::MyGame) = false
function CommonRLInterface.act!(env::MyGame, a)
    env.state = clamp(env.state + a, 1, 10)
    return -o^2
end
CommonRLInterface.player(env::MyGame) = 1 + iseven(env.state)
CommonRLInterface.UtilityStyle(env::MyGame) = GeneralSum()
game = MyGame()

function f end

# h needs to be out here for the inference to work for some reason
function h(x)
    if provided(f, x)
        return f(x)
    else
        return sin(x)
    end
end

@testset "providing" begin
    global f, h

    @test_throws MethodError f(2)
    @test provided(f, 2) == false

    f(x::Int) = x^2

    @test provided(f, 2) == true
    @test provided(f, Tuple{Int}) == true
    @test f(2) == 4

    function f(s::String)
        s*"^2"
    end
    @test provided(f, "2") == true
    @test provided(f, Tuple{String}) == true
    @test f("2") == "2^2"

    @test provided(f, 2.0) == false
    @test provided(f, Tuple{Float64}) == false

    f(x::AbstractArray{N}) where {N<:Number} = x.^2

    @test provided(f, Tuple{Vector{Float64}})
    @test f([1,2]) == [1, 4]

    @test @inferred(h(2)) == f(2)::Int

    g() = nothing

    g(a, b::AbstractVector{<:Number}) = a.*b

    @test provided(g, 1, [1.0]) == true
    @test provided(g, typeof((1, [1.0]))) == true
    @test g(1, [1.0]) == [1.0]
    @test provided(g, 1, ["one"]) == false

    @test provided(reset!, MyEnv())
    @test !provided(clone, MyEnv())
    @test !provided(player, MyEnv())
    @test !provided(actions, MyEnv(), 1)
    @test !provided(UtilityStyle, MyEnv())

    @test provided(player, MyGame())
    @test provided(UtilityStyle, MyGame())
end

@testset "environment" begin
    Base.:(==)(a::MyEnv, b::MyEnv) = a.state == b.state
    Base.hash(x::MyEnv, h=zero(UInt)) = hash(x.state, h)
    CommonRLInterface.clone(env::MyEnv) = MyEnv(env.state)
    @test provided(clone, env)
    @test clone(env) == MyEnv(1)

    CommonRLInterface.render(env::MyEnv) = "MyEnv with state $(env.state)"
    @test provided(render, MyEnv(1))
    @test render(MyEnv(1)) == "MyEnv with state 1"

    CommonRLInterface.state(env::MyEnv) = env.state
    function CommonRLInterface.setstate!(env::MyEnv, s) env.state = s end
    @test provided(state, MyEnv(1))
    @test state(MyEnv(1)) == 1
    env1 = MyEnv(0)
    setstate!(env1, 1)
    @test state(env1) == 1

    @test !provided(UtilityStyle, MyEnv(0))
end

@testset "spaces" begin
    CommonRLInterface.valid_actions(env::MyEnv) = [0, 1]
    @test provided(valid_actions, env)
    @test issubset(valid_actions(env), actions(env))

    CommonRLInterface.valid_action_mask(env::MyEnv) = [false, true, true]
    @test provided(valid_action_mask, env)
    va = valid_actions(env)
    vam = actions(env)[valid_action_mask(env)]
    @test issubset(va, vam)
    @test issubset(vam, va)

    CommonRLInterface.observations(env::MyEnv) = 1:10
    @test provided(observations, env)
    @test observations(env) == 1:10
end

include("examples/gridworld.jl")
include("examples/tictactoe.jl")
include("examples/rock_paper_scissors.jl")

include("default.jl")

include("wrappers.jl")
include("deprecated.jl")
