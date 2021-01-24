module TTT
    include("../../examples/tictactoe.jl")
end

@testset "tictactoe" begin
    g = TTT.TicTacToe()
    reset!(g)
    while !terminated(g)
        @test sum(act!(g, rand(actions(g)))) == 0
        render(g)
    end
end
