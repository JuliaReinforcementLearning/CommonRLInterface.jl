#XXX not finished yet
using CommonRLInterface

const RL = CommonRLInterface

mutable struct TicTacToe <: AbstractEnv
    board::Matrix{Int} # 0 = untaken, 1 = x, 2 = o
end

TicTacToe() = TicTacToe(1, zeros(Int, 3, 3))

iswinner(b, p) = any(all(b[i,:].==p) for i in 1:3) ||
                 any(all(b[:,i]) for i in 1:3) ||
                 all(b[i,i]==p for i in 1:3) ||
                 all(b[i,4-i] == p for i in 1:3)

other(p) = mod1(p+1,2)

RL.reset!(env::TicTacToe) = fill!(env.board, 0)
RL.actions(env::TicTacToe, player=0) = vec([(i, j) for i in 1:3, j in 1:3])
RL.observe(env::TicTacToe) = env.board
RL.terminated(env::TicTacToe) = any(iswinner(env.board, p) for p in 1:2) || all(env.board .!= 0)

function RL.act!(env::TicTacToe, a)
    p = player(env)
    r = [0, 0]
    if env.board[a] == 0
        
    else
        # if you take an illegal action, you lose
        rewards[p] = -1
        rewards[other(p)] = 1
    end
    return rewards
end

@provide RL.player_indices(env::TicTacToe) = 1:2
@provide function RL.player(env::TicTacToe)
    if sum(env.board == 3)
        
    else

    end
end

RL.render(env::TicTacToe) = env

function Base.show(::IO, ::MIME"text/plain", env::TicTacToe)
    chars = [' ', 'x', 'o']
    for i in 1:3
        for j in 1:3
            print(io, '|'*chars[env.board[i,j]])
        end
        println(io, '|')
    end
end
