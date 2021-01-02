module CommonRLInterface

using MacroTools

export
    AbstractEnv,
    reset!,
    actions,
    observe,
    act!,
    player,
    terminated

abstract type AbstractEnv end

"""
    reset!(env::AbstractEnv)

Reset `env` to its initial state and return `nothing`.

This is a *required function* that must be provided by every AbstractEnv.
"""
function reset! end

"""
    actions(env::AbstractEnv)

Return a collection of all of the actions available for AbstractEnv `env`. If the environment has multiple agents, this function should return the union of all of their actions.

This is a *required function* that must be provided by every AbstractEnv.

This function is a *static property* of the environment; the value it returns should not change based on the state.

---

    actions(env::AbstractEnv, i::Integer)

Return a collection of all the actions available to player i.

This function is a *static property* of the environment; the value it returns should not change based on the state.
"""
function actions end

"""
    observe(env::AbstractEnv)

Return an observation from the environment for the current player.

This is a *required function* that must be provided by every AbstractEnv.
"""
function observe end

"""
    r = act!(env::AbstractEnv, a)

Take action `a` for the current player, advance AbstractEnv `env` forward one step, and return rewards for all players.

This is a *required function* that must be provided by every AbstractEnv.
"""
function act! end

"""
    player(env::AbstractEnv) 

Return the index of the player who should play next in the environment.
"""
function player end

"""
    terminated(env::AbstractEnv)

Determine whether an environment has finished executing.

If `terminated(env)` is true, no further actions should be taken and it is safe to assume that no further rewards will be received.
"""
function terminated end

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

If this returns true, it means that the function is provided for any set of arguments with the given types. If it returns false, it may be provided for certain objects. For this reason, algorithm writers should call the `provided(f, args...)` version when possible.
"""
function provided end

provided(f::Function, args...) = provided(f, typeof(args))
provided(f::Function, ::Type{<:Tuple}) = false

provided(::typeof(reset!), ::Type{<:Tuple{AbstractEnv}}) = true
provided(::typeof(actions), ::Type{<:Tuple{AbstractEnv}}) = true
provided(::typeof(observe), ::Type{<:Tuple{AbstractEnv}}) = true
provided(::typeof(act!), ::Type{<:Tuple{AbstractEnv, Any}}) = true

"""
    @provide f(x::X) = x^2

Indicate that function `f` has been implemented for arguments of type `X`.

This will automatically implement the appropriate methods of `provided`. Both the long and short function definition forms will work.

# Example
```jldoctest
using CommonRLInterface

struct MyEnv <: AbstractEnv
    s::Int
end

@assert provided(clone, MyEnv(1)) == false

@provide CommonRLInterface.clone(env::MyEnv) = MyEnv(env.s)

@assert provided(clone, MyEnv(1)) == true
@assert clone(MyEnv(1)) == MyEnv(1)
"""
macro provide(f)
    def = splitdef(f) # TODO: probably give a better error message that mentions @provide if this fails
    @assert isempty(def[:kwargs]) "@provide does not support keyword args yet."
    
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
        CommonRLInterface.provided(::typeof($func), ::Type{<:Tuple{$(argtypes...)}}) where {$(map(esc, def[:whereparams])...)} = true

        $(esc(f))
    end
end

export
    clone,
    render,
    state,
    setstate!
include("environment.jl")

export
    observations,
    valid_actions,
    valid_action_mask
include("spaces.jl")

include("wrappers.jl")

end
