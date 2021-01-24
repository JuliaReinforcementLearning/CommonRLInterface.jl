using CommonRLInterface

const RL = CommonRLInterface

mutable struct RockPaperScissors <: AbstractEnv
    status::Symbol # either :start, the play of the first player, or :done
end

RockPaperScissors() = RockPaperScissors(:start)

beats(a, b) = (a==:rock && b==:scissors) || (a==:scissors && b==:paper) || (a==:paper && b==:rock)

# Really all_act!, actions, terminated, players, and reset! are all that's needed to describe the game

@provide function RL.all_act!(env::RockPaperScissors, as)
    env.status = :done
    if beats(as[1], as[2]) 
        return (1, -1)
    elseif beats(as[2], as[1])
        return (-1, 1)
    else
        return (0, 0)
    end
end

RL.actions(env::RockPaperScissors, player=0) = (:rock, :paper, :scissors)
RL.terminated(env::RockPaperScissors) = env.status == :done
RL.reset!(env::RockPaperScissors) = env.status = :start
@provide RL.players(env::RockPaperScissors) = 1:2

# We may also wish to implement the rest of the required interface

RL.observe(env::RockPaperScissors) = [0]

function RL.act!(env::RockPaperScissors, a)
    if env.status == :start
        env.status = a
        return (0, 0)
    else
        return all_act!(env, (env.status, a))
    end
end

@provide RL.player(env::RockPaperScissors) = env.status == :start ? 1 : 2
@provide RL.UtilityStyle(env::RockPaperScissors) = ZeroSum()
