module Wrappers

using CommonRLInterface

export
    AbstractWrapper,
    QuickWrapper,
    wrapped_env,
    unwrapped

"""
    AbstractWrapper

Abstract base class for environment wrappers. For a subtype of `AbstractWrapper`, all CommonRLInterface functions will be forwarded to the wrapped environment defined by `wrapped_env`.

Interface functions can be selectively overridden for the new wrapper type. `provided` and optional functions will be handled correctly by default.

# Example

```julia
struct MyActionWrapper{E} <: AbstractWrapper
    env::E
end
    
# Any subclass of AbstractWrapper MUST implement wrapped_env
Wrappers.wrapped_env(w::MyActionWrapper) = w.env

# Now all CommonRLFunctions functions are forwarded
w = MyActionWrapper(env)
observe(w) # will return an observation from env
actions(w) # will return the action space from env

# The actions function for the wrapper can be overridden
CommonRLInterface.actions(w::MyActionWrapper) = [-1, 1]
actions(w) # will now return [-1, 1]
```
"""
abstract type AbstractWrapper <: AbstractEnv end

"""
    wrapped_env(env)

Return the wrapped environment for an AbstractWrapper.

This is a *required function* that must be provided by every AbstractWrapper.

See also [`unwrapped`](@ref).
"""
function wrapped_env end

"""
    unwrapped(env)

Return the environment underneath all layers of wrappers.

See also [wrapped_env`](@ref).
"""
unwrapped(env::AbstractWrapper) = unwrapped(wrapped_env(env))
unwrapped(env::AbstractEnv) = env


macro forward_to_wrapped(f)
    return :($f(w::AbstractWrapper, args...; kwargs...) = $f(wrapped_env(w), args...; kwargs...))
end

@forward_to_wrapped CommonRLInterface.reset!
@forward_to_wrapped CommonRLInterface.actions
@forward_to_wrapped CommonRLInterface.observe
@forward_to_wrapped CommonRLInterface.act!
@forward_to_wrapped CommonRLInterface.terminated


@forward_to_wrapped CommonRLInterface.render
@forward_to_wrapped CommonRLInterface.state
@forward_to_wrapped CommonRLInterface.setstate!
@forward_to_wrapped CommonRLInterface.valid_actions
@forward_to_wrapped CommonRLInterface.valid_action_mask
@forward_to_wrapped CommonRLInterface.observations
# not straightforward to provide clone

@forward_to_wrapped CommonRLInterface.players
@forward_to_wrapped CommonRLInterface.player
@forward_to_wrapped CommonRLInterface.all_act!
@forward_to_wrapped CommonRLInterface.all_observe
@forward_to_wrapped CommonRLInterface.UtilityStyle

CommonRLInterface.provided(f::Function, w::AbstractWrapper, args...) = provided(f, wrapped_env(w), args...)
CommonRLInterface.provided(::typeof(clone), w::AbstractWrapper, args...) = false

include("quick_wrapper.jl")

end
