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

provided(f, args...) = provided(f, typeof(args))
provided(f, ::Type{<:Tuple}) = false

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

# Initially, clone is not provided
@assert !provided(clone, MyEnv(1))

@provide CommonRLInterface.clone(env::MyEnv) = MyEnv(env.s)

@assert provided(clone, MyEnv(1))

clone(MyEnv(1))

# output

MyEnv(1)

```
"""
macro provide(f)
    def = splitdef(f) # TODO: probably give a better error message that mentions @provide if this fails
    @assert isempty(def[:kwargs]) "@provide does not support keyword args yet."
    
    func = esc(def[:name])

    argtypes = []
    for arg in def[:args]
        if @capture(arg, name_::T_ | ::T_)
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

export
    players,
    player,
    all_act!,
    all_observe,
    UtilityStyle,
    ZeroSum,
    ConstantSum,
    GeneralSum,
    IdenticalUtility
include("multiplayer.jl")
