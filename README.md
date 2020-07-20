# CommonRLInterface

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl/dev)
[![Build Status](https://travis-ci.com/JuliaReinforcementLearning/CommonRLInterface.jl.svg?branch=master)](https://travis-ci.com/JuliaReinforcementLearning/CommonRLInterface.jl)
[![Coverage](https://codecov.io/gh/JuliaReinforcementLearning/CommonRLInterface.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaReinforcementLearning/CommonRLInterface.jl)

This package is designed for two reasons:
1. to provide compatibility between different reinforcement learning (RL) environment interfaces - for example, an algorithm that uses `YourRLInterface` should be able to use an environment from `MyRLInterface` *without* depending on `MyRLInterface` as long as they both support `CommonRLInterface`.
2. to provide a very basic interface for users to write their own RL environments and algorithms.

## Required Interface

To accomplish this, there are two abstract environment types:
- `AbstractMarkovEnv`, which represents a (PO)MDP with a single player
- `AbstractZeroSumEnv`, which represents a two-player zero sum game

`AbstractEnv` is a base type for all environments.

The interface has five required functions for all `AbstractEnv`s:
```julia
reset!(env)     # returns nothing
actions(env)    # returns the set of all possible actions for the environment
observe(env)    # returns an observation
act!(env, a)    # steps the environment forward and returns a reward
terminated(env) # returns true or false indicating whether the environment has finished
```

For `AbstractZeroSumEnv`, there is an additional required function,
```julia
player(env)     # returns the index of the current player
```

## Optional Interface

There are several additional functions that are currently optional:
- `clone`
- `render`
- `state`
- `setstate!`
- `valid_actions`
- `valid_action_mask`
- `observations`

To see documentation for one of these functions, use [Julia's built-in help system](https://docs.julialang.org/en/v1/manual/documentation/index.html#Accessing-Documentation-1).

To indicate that an environment that you created implements one of these optional functions, use the `@provide` macro, e.g.
```julia
@provide CommonRLInterface.clone(env::MyEnv) = deepcopy(env)
```

To check whether an optional function has been implemented for an environment, use `provided`, e.g.
```julia
if provided(valid_actions, env)
    acts = valid_actions(env)
else
    acts = actions(env)
end
```

To propose adding a new function to the interface, please file an issue with the "candidate interface function" label.

## Additional info

### What does an environment implementation look like?

A 1-D LQR problem with discrete actions might look like this:
```julia
mutable struct LQREnv <: AbstractEnv
    s::Float64
end

function CommonRLInterface.reset!(m::LQREnv)
    m.s = 0.0
end

CommonRLInterface.actions(m::LQREnv) = (-1.0, 0.0, 1.0)
CommonRLInterface.observe(m::LQREnv) = m.s
CommonRLInterface.terminated(m::LQREnv) = false

function CommonRLInterface.act!(m::LQREnv, a)
    r = -m.s^2 - a^2
    m.s = m.s + a + randn()
    return r, false, NamedTuple()
end

# from version 0.2 on, you can implement optional functions like this:
# @provide CommonRLInterface.clone(m::LQREnv) = LQREnv(m.s)
```

### What does a simulation with a random policy look like?

```julia
env = YourEnv()
reset!(env)
rsum = 0.0
while !terminated(env)
    rsum += act!(env, rand(actions(env))) 
end
@show rsum
```


### What does it mean for an RL Framework to "support" CommonRLInterface?

Suppose you have an abstract environment type in your package called `YourEnv`. Support for `AbstractEnv` means:

1. You provide a convert methods
    ```julia
    convert(Type{YourEnv}, ::AbstractEnv)
    convert(Type{AbstractEnv}, ::YourEnv)
    ```
    If there are additional options in the conversion, you are encouraged to create and document constructors with additional arguments.

2. You provide an implementation of the interface functions from your framework only using functions from CommonRLInterface

4. You implement at minimum the required interface and as many optional functions as you'd like to support, where `YourCommonEnv` is the concrete type returned by `convert(Type{AbstractEnv}, ::YourEnv)`

### What does it mean for an algorithm to "support" CommonRLInterface?

You should have a method of your solver or algorithm that accepts a `AbstractEnv`, perhaps handling it by converting it to your framework first, e.g.
```
solve(env::AbstractEnv) = solve(convert(YourEnv, env))
```
