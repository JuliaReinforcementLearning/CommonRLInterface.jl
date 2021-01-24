module RPS 
    include("../../examples/rock_paper_scissors.jl")
end

@testset "rock paper scissors" begin
    g = RPS.RockPaperScissors()
    reset!(g)
    while !terminated(g)
        @test sum(act!(g, rand(actions(g)))) == 0
    end
end
