"""
@provide is deprecated. See `provided`.
"""
macro provide(f)
    Base.depwarn("@provide is deprecated. It is no longer needed. The compiler will automatically infer `provided` by using `Tricks.static_hasmethod`. You can still override `provided` if you need more control.", :provide)
    return esc(f)
end
