module CommonRLInterface

# using MacroTools

export
    AbstractEnv,
    step!,
    reset!,
    actions

abstract type AbstractEnv end

"""
    o, r, done, info = step!(env, a)

Advance CommonEnv `env` forward one step with action `a`.

This function should be provided by every CommonEnv and should return an observation, reward, Boolean done signal, and any extra information (typically in a NamedTuple).
"""
function step! end

"""
    o = reset!(env)

Reset CommonEnv `env` to its initial state and return an initial observation.
"""
function reset! end

"""
    actions(env)

Return a container of all of the actions available to the agent in CommonEnv `env`.

TODO: document concept of a set.
"""
function actions end

export
    provided,
    @provide

"""
    provided(f, args...)

Test whether an implementation for `f(args...)` has been provided.

If this returns false, you should assume that the environment does not support the function `f`.

Usage is identical to `Base.applicable`, but unlike `Base.applicable`, `provided` can usually be inferred at compile time. This function is usually automatically implemented by the @provide macro. It should only be implemented by the user in exceptional cases where very fine control is needed.

---

    provided(f, types::Type{<:Tuple})

Alternate version of provided with syntax similar to `Base.hasmethod`.
"""
function provided end

provided(f::Function, args...) = provided(f, typeof(args))
provided(f::Function, ::Type{<:Tuple}) = false

provided(::typeof(step!), ::Type{<:Tuple{CommonEnv, Any}}) = true
provided(::typeof(reset!), ::Type{<:Tuple{CommonEnv}}) = true
provided(::typeof(actions), ::Type{<:Tuple{CommonEnv}}) = true

macro provide(f)
    def = splitdef(f) # TODO: probably give a better error message that mentions @provide if this fails
    @assert isempty(def[:kwargs]) "@provide does not support keyword args yet."
    @assert isempty(def[:whereparams]) "@provide does not support `where` parameter syntax yet."

    func = esc(def[:name])

    argtypes = []
    for arg in def[:args]
        if @capture(arg, name_::T_)
            push!(argtypes, esc(T))
        else
            push!(argtypes, :Any)
        end
    end
    
    quote
        CommonRLInterface.provided(::typeof($func), ::Type{<:Tuple{$(argtypes...)}}) = true

        $(esc(f))
    end
end

export
    clone,
    render
include("environment.jl")

export
    observations,
    valid_actions,
    valid_action_mask
include("spaces.jl")


end
