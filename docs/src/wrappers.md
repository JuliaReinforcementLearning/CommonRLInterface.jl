# Environment Wrappers

Wrappers provide a convenient way to alter the behavior of an environment. [`QuickWrapper`](@ref) provides the simplest way to override the behavior of a CommonRLInterface function. For example,
```julia
QuickWrapper(env, actions=[-1, 1])
```
will behave just like environment `env`, except that the action space will only consist of `-1` and `1` instead of the original action space of `env`. The keyword arguments may be functions or static objects.

It is also possible to easily create custom wrapper types by subtyping [`AbstractWrapper`].

```@docs
QuickWrapper
AbstractWrapper
```
