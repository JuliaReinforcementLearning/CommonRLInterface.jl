struct QuickWrapper{E<:AbstractEnv, D<:NamedTuple} <: AbstractWrapper
    env::E
    data::D
end

QuickWrapper(e; kwargs...) = QuickWrapper(e, kwargs)

macro quick_forward(f)
    quote
        function $f(w::QuickWrapper, args...)
            if haskey(w.data, nameof($f))
                _call(w.data[nameof($f)], w.env, args...)
            else
                $f(w.env, args...)
            end
        end

        function CommonRLInterface.provided($f, w::QuickWrapper, args...)
            if haskey(w.data, nameof($f))
                return true
            else
                return provided($f, w.env, args...)
            end
        end

        function CommonRLInterface.provided($f, TT::Type{<:Tuple{QuickWrapper{E,D}, Vararg}}) where E,D
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

@quick_forward CommonRLInterface.clone
@quick_forward CommonRLInterface.render
@quick_forward CommonRLInterface.state
@quick_forward CommonRLInterface.setstate!
@quick_forward CommonRLInterface.valid_actions
@quick_forward CommonRLInterface.valid_action_mask
@quick_forward CommonRLInterface.observations
@quick_forward CommonRLInterface.player
