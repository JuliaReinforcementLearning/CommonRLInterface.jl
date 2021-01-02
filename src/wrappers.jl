module Wrappers

using CommonRLInterface

export AbstractWrapper

abstract type AbstractWrapper end

function wrapped_env end

macro forward_to_wrapped(f)
    return :($f(w::AbstractWrapper, args...; kwargs...) = $f(wrapped_env(w), args...; kwargs...))
end

@forward_to_wrapped CommonRLInterface.reset!
@forward_to_wrapped CommonRLInterface.actions
@forward_to_wrapped CommonRLInterface.observe
@forward_to_wrapped CommonRLInterface.act!
@forward_to_wrapped CommonRLInterface.terminated

@forward_to_wrapped CommonRLInterface.player

@forward_to_wrapped CommonRLInterface.render
@forward_to_wrapped CommonRLInterface.state
@forward_to_wrapped CommonRLInterface.setstate!
@forward_to_wrapped CommonRLInterface.valid_actions
@forward_to_wrapped CommonRLInterface.valid_action_mask
@forward_to_wrapped CommonRLInterface.observations
# not straightforward to provide clone

CommonRLInterface.provided(f::Function, w::AbstractWrapper, args...) = provided(f, wrapped_env(w), args...)
CommonRLInterface.provided(::typeof(clone), w::AbstractWrapper, args...) = false

include("quick_wrapper.jl")

end
