# Frequently Asked Questions

## What does an environment implementation look like?

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
    return r
end

# Optional functions can be added like this:
CommonRLInterface.clone(m::LQREnv) = LQREnv(m.s)
```

## What does a simulation with a random policy look like?

```julia
env = YourEnv()
reset!(env)
rsum = 0.0
while !terminated(env)
    rsum += act!(env, rand(actions(env))) 
end
@show rsum
```


## What does it mean for an RL Framework to "support" CommonRLInterface?

Suppose you have an abstract environment type in your package called `YourEnv`. Support for `AbstractEnv` means:

1. You provide a convert methods
    ```julia
    convert(::Type{YourEnv}, ::AbstractEnv)
    convert(::Type{AbstractEnv}, ::YourEnv)
    ```
    If there are additional options in the conversion, you are encouraged to create and document constructors with additional arguments.

2. You provide an implementation of the interface functions from your framework only using functions from CommonRLInterface

4. You implement at minimum the required interface and as many optional functions as you'd like to support, where `YourCommonEnv` is the concrete type returned by `convert(Type{AbstractEnv}, ::YourEnv)`

## What does it mean for an algorithm to "support" CommonRLInterface?

You should have a method of your solver or algorithm that accepts a `AbstractEnv`, perhaps handling it by converting it to your framework first, e.g.
```
solve(env::AbstractEnv) = solve(convert(YourEnv, env))
```
