# CommonRLInterface

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl/dev)
[![Build Status](https://travis-ci.com/JuliaReinforcementLearning/CommonRLInterface.jl.svg?branch=master)](https://travis-ci.com/JuliaReinforcementLearning/CommonRLInterface.jl)
[![Coverage](https://codecov.io/gh/JuliaReinforcementLearning/CommonRLInterface.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaReinforcementLearning/CommonRLInterface.jl)

This package is designed for two reasons:
1. to provide compatibility between different reinforcement learning (RL) environment interfaces - for example, an algorithm that uses `YourRLInterface` should be able to use an environment from `MyRLInterface` *without* depending on `MyRLInterface` as long as they both support `CommonRLInterface`.
2. to provide a very basic interface for users to write their own RL environments and algorithms.

To accomplish this, there is a single abstract environment type, `AbstractEnv`, a small required interface, and a larger optional interface will be added soon.

## Required Interface

The interface has only three required functions:
```julia
step!(env, a)   # returns an observation, reward, done, and info
reset!(env)     # returns an observation
actions(env)    # returns the set of all possible actions for the environment
```

## Optional Interface

There are several additional functions that are currently optional:
- `clone`
- `render`
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

### What does it mean for an RL Framework to "support" CommonRLInterface?

Suppose you have an abstract environment type in your package called `YourEnv`. Support for `AbstractEnv` means:

1. You provide a convert methods
    ```julia
    convert(Type{YourEnv}, ::AbstractEnv)
    convert(Type{AbstractEnv}, ::YourEnv)
    ```
    If there are additional options in the conversion, you are encouraged to create and document constructors with additional arguments.

2. You provide an implementation of the interface functions from your framework only using functions from CommonRLInterface

4. You implement at minimum
    - `CommonRLInterface.reset!(::YourCommonEnv)`
    - `CommonRLInterface.step!(::YourCommonEnv, a)`
    - `CommonRLInterface.actions(::YourCommonEnv)`
    and as many optional functions as you'd like to support, where `YourCommonEnv` is the concrete type returned by `convert(Type{AbstractEnv}, ::YourEnv)`

### What does an environment implementation look like?

A 1-D LQR problem with discrete actions might look like this:
```julia
mutable struct LQREnv <: AbstractEnv
    s::Float64
end

function CommonRLInterface.reset!(m::LQREnv)
    m.s = 0.0
end

function CommonRLInterface.step!(m::LQREnv, a)
    r = -m.s^2 - a^2
    sp = m.s = m.s + a + randn()
    return sp, r, false, NamedTuple()
end

CommonRLInterface.actions(m::LQREnv) = (-1.0, 0.0, 1.0)

# from version 0.2 on, you can implement optional functions like this:
# @provide CommonRLInterface.clone(m::LQREnv) = LQREnv(m.s)
```

### What does a simulation with a random policy look like?

```julia
env = YourEnv()
done = false
o = reset!(env)
acts = actions(env)
rsum = 0.0
while !done
    o, r, done, info = step!(env, rand(acts)) 
    r += rsum
end
@show rsum
```

### What does it mean for an algorithm to "support" CommonRLInterface?

You should have a method of your solver or algorithm that accepts a `AbstractEnv`, perhaps handling it by converting it to your framework first, e.g.
```
solve(env::AbstractEnv) = solve(convert(YourEnv, env))
```
