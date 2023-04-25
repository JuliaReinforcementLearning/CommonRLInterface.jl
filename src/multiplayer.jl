"""
    players(env::AbstractEnv)

Return an ordered iterable collection of integer indices for all players, starting with one.

This function is a *static property* of the environment; the value it returns should not change based on the state.

# Example

```julia
players(::MyEnv) = 1:2
```
"""
function players end

"""
    player(env::AbstractEnv) 

Return the index of the player who should play next in the environment.
"""
function player end

"""
    all_act!(env::AbstractEnv, actions::AbstractVector)

Take `actions` for all players and advance AbstractEnv `env` forward, and return rewards for all players.

Environments that support simultaneous actions by all players should implement this in addition to or instead of `act!`.
"""
function all_act! end

"""
    all_observe(env::AbstractEnv)

Return observations from the environment for all players.

Environments that support simultaneous actions by all players should implement this in addition to or instead of `observe`.
"""
function all_observe end

"""
    UtilityStyle(env)

Trait that allows an environment to declare certain properties about the relative utility for the players.

Possible returns are:
- `ZeroSum()`
- `ConstantSum()`
- `GeneralSum()`
- `IdenticalUtility()`

See the docstrings for each for more details.
"""
abstract type UtilityStyle end

"""
If `UtilityStyle(env) == ZeroSum()` then the sum of the rewards returned by `act!` is always zero.
"""
struct ZeroSum <: UtilityStyle end
"""
If `UtilityStyle(env) == ConstantSum()` then the sum of the rewards returned by `act!` will always be the same constant.
"""
struct ConstantSum <: UtilityStyle end
"""
If `UtilityStyle(env) == GeneralSum()`, the sum of rewards over a trajectory can take any form.
"""
struct GeneralSum <: UtilityStyle end
"""
If `UtilityStyle(env) == IdenticalUtility()`, all entries of the reward returned by `act!` will be identical for all players.
"""
struct IdenticalUtility <: UtilityStyle end
