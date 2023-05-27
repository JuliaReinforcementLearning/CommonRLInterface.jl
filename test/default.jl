@testset "default" begin
    struct DefaultTestEnv <: AbstractEnv end

    CommonRLInterface.actions(::DefaultTestEnv) = (1,2)

    import .AutomaticDefault

    D = AutomaticDefault

    env = DefaultTestEnv()

    @test D.clone(env) == env
    @test D.actions(env, 1) == actions(env)
    @test D.valid_actions(env) == actions(env)
    @test actions(env)[D.valid_action_mask(env)] == actions(env)
    @test D.players(env) == 1
    @test D.player(env) == 1
    @test D.UtilityStyle(env) == GeneralSum()

    struct DefaultActionMaskTestEnv <: AbstractEnv
        state::Int
    end

    CommonRLInterface.actions(::DefaultActionMaskTestEnv) = 1:3
    CommonRLInterface.valid_actions(env::DefaultActionMaskTestEnv) = filter(!=(env.state), actions(env))
    @test D.valid_actions(DefaultActionMaskTestEnv(1)) == 2:3
    @test D.valid_action_mask(DefaultActionMaskTestEnv(1)) == [0,1,1]
end
