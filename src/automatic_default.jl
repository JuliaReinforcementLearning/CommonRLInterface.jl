module AutomaticDefault

using CommonRLInterface

export
    clone,
    valid_actions,
    valid_action_mask
    
# Environment

function clone(env)
    if provided(CommonRLInterface.clone, env)
        return CommonRLInterface.clone(env)
    else
        return deepcopy(env)
    end
end

# Spaces

function actions(env, player)
    if provided(CommonRLInterface.actions, env, player)
        return CommonRLInterface.actions(env, player)
    else
        return CommonRLInterface.actions(env)
    end
end

function valid_actions(env)
    if provided(CommonRLInterface.valid_actions, env)
        return CommonRLInterface.valid_actions(env)
    elseif provided(CommonRLInterface.valid_action_mask, env)
        return actions(env)[CommonRLInterface.valid_action_mask(env)]
    elseif provided(CommonRLInterface.actions, env, player(env))
        return CommonRLInterface.actions(env, player(env))
    else
        return actions(env)
    end
end

function valid_action_mask(env)
    if provided(CommonRLInterface.valid_action_mask, env)
        return CommonRLInterface.valid_action_mask(env)
    elseif provided(CommonRLInterface.valid_actions, env)
        return map(in(CommonRLInterface.valid_actions(env)), actions(env))
    else
        return trues(length(actions(env)))
    end
end

# Multiplayer
function players(env)
    if provided(CommonRLInterface.players, env)
        return CommonRLInterface.players(env)
    else
        return 1
    end
end

function player(env)
    if provided(CommonRLInterface.player, env)
        return CommonRLInterface.player(env)
    else
        return 1
    end
end

function UtilityStyle(env)
    if provided(CommonRLInterface.UtilityStyle, env)
        return CommonRLInterface.UtilityStyle(env)
    else
        return GeneralSum()
    end
end

end
