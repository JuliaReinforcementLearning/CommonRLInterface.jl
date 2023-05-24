"""
    clone(env)

Create a clone of CommonEnv `env` at the current state.

Two clones are assumed to be completely independent of each other - no action applied to one will affect the other.
"""
function clone end

"""
    render(env)

Return a showable object that visualizes the environment at the current state.

Implementing this function will facilitate visualization through the [Julia Multimedia I/O system](https://docs.julialang.org/en/v1/base/io-network/#Multimedia-I/O-1), for example, calling `display(render(env))` will cause the visualization to pop up in a Jupyter notebook, the Juno plot pane, or an ElectronDisplay.jl window. `render` should return an object that has `Base.show` methods for many MIME types. Good examples include a Plots.jl plot, a Compose.jl `Context` graphic produced by Cairo, or a custom type with `show` methods.

# Example
```julia
using CommonRLInterface
using Plots

struct MyEnv <: AbstractEnv
    state::Tuple{Int, Int}
end

CommonRLInterface.render(env::MyEnv) = scatter(env.state[1], env.state[2])
```
"""
function render end

"""
    state(env::AbstractEnv)

Return the state of the environment.

See setstate! for more information about the state.
"""
function state end

"""
    setstate!(env::AbstractEnv, s)

Set the state of the environment to s.

If two environments have the same state, future outputs (observations and rewards) should be statistically identical given the same sequence of actions.
"""
function setstate! end
