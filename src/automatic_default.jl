"""
The `CommonRLInterface.AutomaticDefault` module contains a complete copy of all of the functions in `CommonRLInterface`, with the crucial difference that each of the functions will try as hard as possible to return a default value.

For example, if the environment does not have [`CommonRLInterface.clone`](@ref) implemented for it, `AutomaticDefault.clone` will fall back to `deepcopy`, and if [`CommonRLInterface.valid_actions`](@ref) is implemented, then `AutomaticDefault.valid_action_mask` will automatically work consistently.

Environment *implementers* should implement new methods for functions in `CommonRLInterface` and should not deal with `AutomaticDefault`; environment *users* (e.g. RL algorithm implementers) should use [`AutomaticDefault`](@ref) for the widest compatibility possible with different environments (or use [`CommonRLInterface.provided`](@ref) to manually adapt to the environment's capabilities).

# Example
```jldoctest
import CommonRLInterface
using CommonRLInterface.AutomaticDefault
using Test

struct ExampleEnv <: CommonRLInterface.AbstractEnv end

CommonRLInterface.actions(::ExampleEnv) = 1:2

# CommonRLInterface.valid_actions will not work, because valid_actions was not defined 
@test_throws MethodError CommonRLInterface.valid_actions(ExampleEnv())

# But, this version from AutomaticDefault will work by falling back to `actions`:
valid_actions(ExampleEnv())

# output

1:2
```
"""
module AutomaticDefault

using CommonRLInterface

const RL = CommonRLInterface

export
    reset!,
    actions,
    observe,
    act!,
    terminated

export
    clone,
    render,
    state,
    setstate!

export
    observations,
    valid_actions,
    valid_action_mask

export
    players,
    player,
    all_act!,
    all_observe,
    UtilityStyle
    
# Required

reset! = RL.reset!
actions(env) = RL.actions(env)
function actions(env, player)
    if provided(RL.actions, env, player)
        return RL.actions(env, player)
    else
        return RL.actions(env)
    end
end
observe = RL.observe
act! = RL.act!
terminated = RL.terminated

# Environment

function clone(env)
    if provided(RL.clone, env)
        return RL.clone(env)
    else
        return deepcopy(env)
    end
end

render = RL.render
state = RL.state
setstate! = RL.setstate!

# Spaces

observations = RL.observations

function valid_actions(env)
    if provided(RL.valid_actions, env)
        return RL.valid_actions(env)
    elseif provided(RL.valid_action_mask, env)
        return RL.actions(env)[RL.valid_action_mask(env)]
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

all_act! = RL.all_act!
all_observe = RL.all_observe

function UtilityStyle(env)
    if provided(RL.UtilityStyle, env)
        return RL.UtilityStyle(env)
    else
        return GeneralSum()
    end
end

end
