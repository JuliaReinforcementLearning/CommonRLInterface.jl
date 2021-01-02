@testset "wrappers" begin
    mutable struct WrapperTestEnv <: AbstractEnv
        state::Int
    end
    WrapperTestEnv() = WrapperTestEnv(1)
    function CommonRLInterface.reset!(env::WrapperTestEnv)
        env.state = 1
    end
    CommonRLInterface.actions(env::WrapperTestEnv) = [-1, 0, 1]
    CommonRLInterface.observe(env::WrapperTestEnv) = env.state
    CommonRLInterface.terminated(env::WrapperTestEnv) = false
    function CommonRLInterface.act!(env::WrapperTestEnv, a)
        env.state = clamp(env.state + a, 1, 10)
        return -o^2
    end
    @provide CommonRLInterface.render(env::WrapperTestEnv) = "WrapperTestEnv($(env.state))"

    using CommonRLInterface.Wrappers: Wrappers, AbstractWrapper

    struct MyWrapper{E} <: AbstractWrapper
        env::E
    end

    Wrappers.wrapped_env(w::MyWrapper) = w.env

    @provide CommonRLInterface.render(w::MyWrapper) = "Wrapper of $(w.env)"

    w = MyWrapper(WrapperTestEnv(1))
    @test provided(reset!, w)
    @test !provided(clone, w)

    @test !provided(state, w)
    @provide CommonRLInterface.state(env::WrapperTestEnv) = env.state
    @test provided(state, w)
    @test state(w) == 1

    @test provided(render, w)
    @test render(w) == "Wrapper of WrapperTestEnv(1)"
end
