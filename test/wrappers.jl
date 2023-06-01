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
    CommonRLInterface.render(env::WrapperTestEnv) = "WrapperTestEnv($(env.state))"

    using CommonRLInterface.Wrappers: Wrappers, AbstractWrapper

    struct MyWrapper{E} <: AbstractWrapper
        env::E
    end

    Wrappers.wrapped_env(w::MyWrapper) = w.env

    CommonRLInterface.render(w::MyWrapper) = "Wrapper of $(w.env)"

    w = MyWrapper(WrapperTestEnv(1))
    @test provided(reset!, w)
    @test !provided(clone, w)

    @test !provided(state, w)
    CommonRLInterface.state(env::WrapperTestEnv) = env.state
    @test provided(state, w)
    @test state(w) == 1

    @test provided(render, w)
    @test render(w) == "Wrapper of WrapperTestEnv(1)"

    @testset "QuickWrapper" begin
        using CommonRLInterface.Wrappers: QuickWrapper

        env = WrapperTestEnv()
        w = QuickWrapper(env)
        @test provided(reset!, w)
        @test provided(render, w)
        @test render(w) == render(env)
        @test !provided(observations, w)
        @test !provided(valid_actions, w)
        @test !provided(clone, w)

        # static object keyword arg
        w2 = QuickWrapper(env;
                          valid_actions = env->filter(!=(0), actions(env)),
                          observations = 1:10,
                          clone = deepcopy
                         )

        @test provided(observations, w2)
        @test observations(w2) == 1:10
        @test provided(valid_actions, w2)
        @test valid_actions(w2) == filter(!=(0), actions(env))
        @test provided(clone, w2)
        @test clone(w2) isa QuickWrapper
        @test state(clone(w2)) == state(env)

        w3 = QuickWrapper(env)
        CommonRLInterface.clone(env::WrapperTestEnv) = WrapperTestEnv(env.state)
        @test provided(clone, w3)
        @test clone(w2) isa QuickWrapper
        @test state(clone(w3)) == state(env)
    end

    @testset "unwrapped" begin
        base_env = WrapperTestEnv()
        wrapped_1 = MyWrapper(base_env)
        wrapped_2 = Wrappers.QuickWrapper(wrapped_1)
        @test Wrappers.wrapped_env(wrapped_1) === base_env
        @test Wrappers.wrapped_env(wrapped_2) === wrapped_1
        @test Wrappers.unwrapped(wrapped_2) === base_env
        @test Wrappers.unwrapped(base_env) === base_env
    end
end
