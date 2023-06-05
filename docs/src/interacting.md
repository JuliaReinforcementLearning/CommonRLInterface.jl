# Interacting with Environments

Users who wish to run simulations or implement reinforcement learning algorithms with environments that others have defined should interact with environments using functions from the [Required Interface](@ref) and [Optional Interface](@ref).

In order to achieve compatibility with the widest possible set of environments, it is critical to handle environments with incomplete implementations of the [Optional Interface](@ref) gracefully. The [`AutomaticDefault`](@ref) module provides functions that have default implementations based on other functions when possible, so users can call them without worrying about which optional functions the environment implements. For this reason, RL algorithm implementers should use [`AutomaticDefault`](@ref) unless there is a compelling reason not to.

```@docs
AutomaticDefault
```
