# Multiplayer Interface

CommonRLInterface provides a basic interface for multiplayer games.

## Sequential games

Sequential games should implement the optional function [`players`](@ref) to return a range of player ids, and [`player`](@ref) to indicate which player's turn it is. There is no requirement that players play in the order returned by the `players` function. Only the action for the current player should be supplied to [`act!`](@ref), but rewards for all players should be returned. [`observe`](@ref) returns the observation for only the current player.

## Simultaneous Games/Multi-agent (PO)MDPs

Environments in which all players take actions at once should implement the [`all_act!`](@ref) and [`all_observe`](@ref) optional functions which take a collection of actions for all players and return observations for each player, respectively.

## Indicating reward properties

The [`UtilityStyle`](@ref) trait can be used to indicate that the rewards will meet properties, for example that rewards for all players are identical or that the game is zero-sum.


```@docs
players
player
all_act!
all_observe
UtilityStyle
ZeroSum
ConstantSum
GeneralSum
IdenticalUtility
```
