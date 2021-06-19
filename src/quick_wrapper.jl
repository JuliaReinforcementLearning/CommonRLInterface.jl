struct QuickWrapper{E<:AbstractEnv, D<:NamedTuple} <: AbstractWrapper
    env::E
    data::D
end

"""
    QuickWrapper(env; kwargs...)

Create a wrapper to override specific behavior of the environment with keywords.

Each keyword argument corresponds to a CommonRLInterface function to be overridden. The keyword arguments can either be static objects or functions. If a keyword argument is a function, the arguments will be the wrapped environment and any other arguments. `provided` is automatically handled.

# Examples

Override the action space statically:
```julia
w = QuickWrapper(env; actions=[-1, 1])
observe(w) # returns the observation from env
actions(w) # returns [-1, 1]
```

Override the `act!` function to return the reward squared:
```julia
w = QuickWrapper(env; act! = (env, a) -> act!(env, a).^2)
act!(w, a) # returns the squared reward for taking action a in env
```
"""
QuickWrapper(e; kwargs...) = QuickWrapper(e, values(kwargs))

wrapped_env(w::QuickWrapper) = w.env

macro quick_forward(f)
    quote
        function $f(w::QuickWrapper, args...)
            if haskey(w.data, nameof($f))
                _call(w.data[nameof($f)], w.env, args...)
            else
                $f(w.env, args...)
            end
        end

        function CommonRLInterface.provided(::typeof($f), w::QuickWrapper, args...)
            if haskey(w.data, nameof($f))
                return true
            else
                return provided($f, w.env, args...)
            end
        end

        function CommonRLInterface.provided(::typeof($f), TT::Type{<:Tuple{QuickWrapper{E,D}, Vararg}}) where {E,D}
            if hasfield(D, nameof($f))
                return true
            else
                return provided($f, Tuple{E, TT.parameters[2:end]...})
            end
        end
    end
end

_call(f::Function, args...) = f(args...)
_call(other, args...) = other

@quick_forward CommonRLInterface.reset!
@quick_forward CommonRLInterface.actions
@quick_forward CommonRLInterface.observe
@quick_forward CommonRLInterface.act!
@quick_forward CommonRLInterface.terminated

@quick_forward CommonRLInterface.render
@quick_forward CommonRLInterface.state
@quick_forward CommonRLInterface.setstate!
@quick_forward CommonRLInterface.valid_actions
@quick_forward CommonRLInterface.valid_action_mask
@quick_forward CommonRLInterface.observations

@quick_forward CommonRLInterface.players
@quick_forward CommonRLInterface.player
@quick_forward CommonRLInterface.all_act!
@quick_forward CommonRLInterface.all_observe
@quick_forward CommonRLInterface.UtilityStyle

function CommonRLInterface.clone(w::QuickWrapper, args...)
    if haskey(w.data, :clone)
        QuickWrapper(_call(w.data[:clone], w.env), w.data)
    else
        QuickWrapper(clone(w.env), deepcopy(w.data))
    end
end

function CommonRLInterface.provided(f::typeof(CommonRLInterface.clone), w::QuickWrapper, args...)
    if haskey(w.data, :clone)
        return true
    else
        return provided(f, w.env, args...)
    end
end

function CommonRLInterface.provided(f::typeof(CommonRLInterface.clone), TT::Type{<:Tuple{QuickWrapper{E,D}, Vararg}}) where {E,D}
    if hasfield(D, :clone)
        return true
    else
        return provided(f, Tuple{E, TT.parameters[2:end]...})
    end
end
