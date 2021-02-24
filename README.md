# CommonRLInterface

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl/dev)
[![Build status](https://github.com/JuliaReinforcementLearning/CommonRLInterface.jl/workflows/CI/badge.svg)](https://github.com/JuliaReinforcementLearning/CommonRLInterface.jl/actions)
[![Coverage](https://codecov.io/gh/JuliaReinforcementLearning/CommonRLInterface.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaReinforcementLearning/CommonRLInterface.jl)
<!--[![Build Status](https://travis-ci.com/JuliaReinforcementLearning/CommonRLInterface.jl.svg?branch=master)](https://travis-ci.com/JuliaReinforcementLearning/CommonRLInterface.jl)-->

## Purpose

The CommonRLInterface package provides an interface for defining and interacting with [Reinforcement Learning Environments](http://incompleteideas.net/book/first/ebook/node28.html).

An important goal is to provide compatibility between different reinforcement learning (RL) environment interfaces - for example, an algorithm that uses `YourRLInterface` should be able to use an environment from `MyRLInterface` *without* depending on `MyRLInterface` as long as they both support `CommonRLInterface`.

By design, this package is only concerned with environments and *not* with policies or agents.

## Documentation

A few simple examples can be found in the examples directory. Detailed documentation can be found here: [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaReinforcementLearning.github.io/CommonRLInterface.jl/stable). A brief overview is given below:

### Required Interface

`AbstractEnv` is a base type for all environments.

The interface has five required functions for all `AbstractEnv`s:
```julia
reset!(env)     # returns nothing
actions(env)    # returns the set of all possible actions for the environment
observe(env)    # returns an observation
act!(env, a)    # steps the environment forward and returns a reward
terminated(env) # returns true or false indicating whether the environment has finished
```

### Optional Interface

Additional behavior for an environment can be specified with the optional interface outlined in the documentation. The `provided` function can be used to check whether optional behavior is provided by the environment.

### Multiplayer Environments

Optional functions allow implementation of both sequential and simultaneous games and multi-agent (PO)MDPs

### Wrappers

A wrapper system described in the documentation allows for easy modification of environments.

### Compatible Packages

These packages are compatible with CommonRLInterface:

- [ReinforcementLearning.jl](https://github.com/JuliaReinforcementLearning/ReinforcementLearning.jl)
- [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl)
- [AlphaZero.jl](https://github.com/jonathan-laurent/AlphaZero.jl)
