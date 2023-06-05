# Optional Interface

Some environments can provide additional information or behavior beyond what can be expressed with the [Required Interface](@ref). For this reason, CommonRLInterface has an interface of optional functions.

## Determining what an environment has: `provided`

!!! tip 
    The [`AutomaticDefault`](@ref) module provides a convenient way to access optional functions that is an alternative to calling `provided` manually.

When other code interacts with an environment, it is common to adjust behavior based on the capabilities that environment provides. The [`provided`](@ref) function is a programmatic way to determine whether the environment author has implemented certain optional behavior. For instance, an algorithm author might only want to consider the valid subset of actions at the current state if the `valid_actions` optional function is implemented. This can be accomplished with the following code:
```julia
if provided(valid_actions, env)
    acts = valid_actions(env)
else
    acts = actions(env)
end
```
(or by using [`AutomaticDefault`](@ref)`.valid_actions`). In most cases, `provided` can be statically optimized out, so it will have no performance impact.

## Optional Function List

The optional interface currently contains the following functions:

- [`clone`](@ref)
- [`render`](@ref)
- [`state`](@ref)
- [`setstate!`](@ref)
- [`valid_actions`](@ref)
- [`valid_action_mask`](@ref)
- [`observations`](@ref)

Additional optional functions for multiplayer environments are contained in the [Multiplayer Interface](@ref)

To propose adding a new function to the interface, please file an issue with the "candidate interface function" label.

------

```@docs
provided
clone
render
state
setstate!
valid_actions
valid_action_mask
observations
```
