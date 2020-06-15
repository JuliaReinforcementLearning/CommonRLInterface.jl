# CommonRLInterface

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl/dev)
[![Build Status](https://travis-ci.com/JuliaReinforcementLearning/CommonRLInterface.jl.svg?branch=master)](https://travis-ci.com/JuliaReinforcementLearning/CommonRLInterface.jl)
[![Coverage](https://codecov.io/gh/JuliaReinforcementLearning/CommonRLInterface.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaReinforcementLearning/CommonRLInterface.jl)

This package is designed for two reasons:
1. to provide compatibility between different reinforcement learning (RL) environment interfaces - for example, an algorithm that uses `YourRLInterface` should be able to use an environment from `MyRLInterface` *without* depending on `MyRLInterface` as long as they both support `CommonEnv`.
2. to provide a very basic interface for users to write their own RL environments and algorithms.

To accomplish this, there is a single abstract environment type, `CommonEnv`, a small required interface, and a larger optional interface.

## Required Interface

The interface has only three required functions:
```julia
step!(env, a)   # returns an observation, reward, done, and info
reset!(env)     # returns an observation
actions(env)    # returns the set of all possible actions for the environment
```

## Optional Interface

A number of other functions are available to provide additional functionality.

For example, if an algorithm needs to create an independent copy of the environment at the current state, it can use `clone(env)`. The algorithm can check if `clone(env)` is available for an environment with
```julia
provided(clone, env)
```
and give an appropriate error message if it is not.

A particular `CommonEnv` can opt-in to providing the `clone` function with the `@provide` macro, for example
```julia
@provide CommonRLInterface.clone(env::MyCommonEnv) = deepcopy(env)
```

## Additional info

(This will eventually go in the Documenter.jl-generated docs)

### What does it mean for an RL Framework to "support" CommonEnv?

Suppose you have an abstract environment type in your package called `YourEnv`. Support for CommonEnv means:

1. You provide a constructor method
    ```julia
    YourEnv(env::CommonEnv) # might require extra args and keyword args in some cases
    ```

2. You provide an implementation of the interface functions in `YourEnv` only using functions from CommonRLInterface

3. You provide `CommonEnv` constructor method
    ```julia
    CommonEnv(env::YourEnv) # might require extra args and keyword args
    ```
    which returns a `YourCommonEnv <: CommonEnv`

4. You implement at minimum
    - `CommonRL.reset!(::YourCommonEnv)`
    - `CommonRL.step!(::YourCommonEnv, a)`
    - `CommonRL.actions(::YourCommonEnv)`
    and as many optional functions as you'd like to support.

### What does an environment implementation look like?

A 1-D LQR problem with discrete actions might look like this:
```julia
mutable struct LQREnv <: CommonEnv
    s::Float64
end

function CommonRLInterface.reset!(m::LQREnv)
    m.s = 0.0
end

function CommonRLInterface.step!(m::LQREnv, a)
    r = -s^2 - a^2
    sp = m.s = m.s + a + randn()
    return sp, r, false, NamedTuple()
end

CommonRLInterface.actions(m::LQREnv) = (-1.0, 0.0, 1.0)

@provide CommonRLInterface.clone(m::LQREnv) = LQREnv(m.s)
```

### What does a simulation with a random policy look like?

```julia
env = YourEnv(0.0)
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

### What does it mean for an algorithm to "support" CommonEnv?

You should have a method of your solver or algorithm that accepts a `CommonEnv`, perhaps handling it by converting it to your framework first, e.g.
```
solve(env::CommonEnv) = solve(YourEnv(env))
```
