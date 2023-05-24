module CommonRLInterface

import Tricks

export
    AbstractEnv,
    reset!,
    actions,
    observe,
    act!,
    terminated

abstract type AbstractEnv end

"""
    reset!(env::AbstractEnv)

Reset `env` to its initial state and return `nothing`.

This is a *required function* that must be provided by every AbstractEnv.
"""
function reset! end

"""
    actions(env::AbstractEnv)

Return a collection of all of the actions available for AbstractEnv `env`. If the environment has multiple agents, this function should return the union of all of their actions.

This is a *required function* that must be provided by every AbstractEnv.

This function is a *static property* of the environment; the value it returns should not change based on the state.

---

    actions(env::AbstractEnv, player_index)

Return a collection of all the actions available to a given player.

This function is a *static property* of the environment; the value it returns should not change based on the state.
"""
function actions end

"""
    observe(env::AbstractEnv)

Return an observation from the environment for the current player.

This is a *required function* that must be provided by every AbstractEnv.
"""
function observe end

"""
    r = act!(env::AbstractEnv, a)

Take action `a` and advance AbstractEnv `env` forward one step, and return rewards for all players.

This is a *required function* that must be provided by every AbstractEnv.

If the environment has a single player, it is acceptable to return a scalar number. If there are multiple players, it should return a container with all rewards indexed by player number.

# Example

## Single Player
```julia
function act!(env::MyMDPEnv, a)
    env.state += a + randn()
    return env.s^2
end
```

## Two Player

```julia
function act!(env::MyMDPEnv, a)
    env.positions[player(env)] += a   # In this game, each player has a position that is updated by his or her action
    rewards = in_goal.(env.positions) # Rewards are +1 for being in a goal region, 0 otherwise
    return rewards                    # returns a vector of rewards for each player
end
```
"""
function act! end

"""
    terminated(env::AbstractEnv)

Determine whether an environment has finished executing.

If `terminated(env)` is true, no further actions should be taken and it is safe to assume that no further rewards will be received.
"""
function terminated end

export provided

"""
    provided(f, args...)

Test whether an implementation for `f(args...)` has been provided.

If this returns false, you should assume that the environment does not support the function `f`.

Usage is identical to `Base.applicable`. The default implementation should be correct for most cases. It should only be implemented by the user in exceptional cases where very fine control is needed.

---

    provided(f, types::Type{<:Tuple})

Alternate version of `provided` with syntax similar to `Base.hasmethod`.

If this returns true, it means that the function is provided for any set of arguments with the given types. If it returns false, it may be provided for certain objects. For this reason, algorithm writers should call the `provided(f, args...)` version when possible.
"""
function provided end

provided(f::Union{Function, DataType}, args...) = provided(f, typeof(args))
provided(f::Union{Function, DataType}, T::Type{<:Tuple}) = Tricks.static_hasmethod(f, T)

export
    clone,
    render,
    state,
    setstate!
include("environment.jl")

export
    observations,
    valid_actions,
    valid_action_mask
include("spaces.jl")

export
    players,
    player,
    all_act!,
    all_observe,
    UtilityStyle,
    ZeroSum,
    ConstantSum,
    GeneralSum,
    IdenticalUtility
include("multiplayer.jl")

export
    AutomaticDefault
include("automatic_default.jl")

export
    Wrappers
include("wrappers.jl")

export
    @provide
include("deprecated.jl")

end
