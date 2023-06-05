#XXX not finished yet
using CommonRLInterface

const RL = CommonRLInterface

mutable struct TicTacToe <: AbstractEnv
    board::Matrix{Int} # 0 = untaken, 1 = x, 2 = o
end

TicTacToe() = TicTacToe(zeros(Int, 3, 3))

iswinner(b, p) = any(all(b[i,:].==p) for i in 1:3) ||
                 any(all(b[:,i].==p) for i in 1:3) ||
                 all(b[i,i]==p for i in 1:3) ||
                 all(b[i,4-i]==p for i in 1:3)

other(p) = mod1(p+1,2)

RL.reset!(env::TicTacToe) = fill!(env.board, 0)
RL.actions(env::TicTacToe) = vec([(i, j) for i in 1:3, j in 1:3])
# symmetrical observations for both players: +1 for your square, -1 for other square
RL.observe(env::TicTacToe) = zeros(Int, 3, 3) + (env.board.==player(env)) - (env.board.==other(player(env)))
RL.terminated(env::TicTacToe) = any(iswinner(env.board, p) for p in 1:2) || all(env.board .!= 0)

function RL.act!(env::TicTacToe, a)
    p = player(env)
    winner = 0
    if env.board[a...] == 0
        env.board[a...] = p
        for pp in players(env)
            if iswinner(env.board, pp)
                winner = pp
            end
        end
    else
        # if you take an illegal action, you lose
        winner = other(p)
    end

    if winner == 1
        return (1, -1)
    elseif winner == 2
        return (-1, 1)
    end
    return (0, 0)
end

RL.players(env::TicTacToe) = 1:2
function RL.player(env::TicTacToe)
    if sum(env.board)%3 == 0
        return 1
    else
        return 2
    end
end

RL.render(env::TicTacToe) = env

function Base.show(io::IO, ::MIME"text/plain", env::TicTacToe)
    chars = [' ', 'x', 'o']
    for i in 1:3
        for j in 1:3
            print(io, '|'*chars[env.board[i,j]+1])
        end
        println(io, '|')
    end
end

RL.UtilityStyle(::TicTacToe) = ZeroSum()
