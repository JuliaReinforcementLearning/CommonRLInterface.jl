module AutomaticDefault

using CommonRLInterface

const RL = CommonRLInterface

export
    clone,
    actions,
    valid_actions,
    valid_action_mask,
    players,
    player,
    UtilityStyle
    
# Environment

function clone(env)
    if provided(RL.clone, env)
        return RL.clone(env)
    else
        return deepcopy(env)
    end
end

# Spaces

function actions(env, player)
    if provided(RL.actions, env, player)
        return RL.actions(env, player)
    else
        return RL.actions(env)
    end
end

function valid_actions(env)
    if provided(RL.valid_actions, env)
        return RL.valid_actions(env)
    elseif provided(RL.valid_action_mask, env)
        return actions(env)[RL.valid_action_mask(env)]
    elseif provided(RL.actions, env, player(env))
        return RL.actions(env, player(env))
    else
        return RL.actions(env)
    end
end

function valid_action_mask(env)
    if provided(RL.valid_action_mask, env)
        return RL.valid_action_mask(env)
    elseif provided(RL.valid_actions, env)
        return map(in(RL.valid_actions(env)), actions(env))
    elseif provided(RL.actions, env, player(env))
        return map(in(RL.actions(env, player(env))), RL.actions(env))
    else
        return trues(length(RL.actions(env)))
    end
end

# Multiplayer
function players(env)
    if provided(RL.players, env)
        return RL.players(env)
    else
        return 1
    end
end

function player(env)
    if provided(RL.player, env)
        return RL.player(env)
    else
        return 1
    end
end

function UtilityStyle(env)
    if provided(RL.UtilityStyle, env)
        return RL.UtilityStyle(env)
    else
        return GeneralSum()
    end
end

end
