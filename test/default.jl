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
    @test D.UtilityStyle(env) == GeneralSum() # don't understand this one - it is not broken if I just include this file
end
