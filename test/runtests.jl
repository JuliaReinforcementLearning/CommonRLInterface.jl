using CommonRLInterface
using Test

function f end

# h needs to be out here for the inference to work for some reason
function h(x)
    if provided(f, x)
        return f(x)
    else
        return sin(x)
    end
end

@testset "providing" begin

global f, h

@test_throws MethodError f(2)
@test provided(f, 2) == false

@provide f(x::Int) = x^2

@test provided(f, 2) == true
@test provided(f, Tuple{Int}) == true
@test f(2) == 4

@provide function f(s::String)
    s*"^2"
end
@test provided(f, "2") == true
@test provided(f, Tuple{String}) == true
@test f("2") == "2^2"

@test provided(f, 2.0) == false
@test provided(f, Tuple{Float64}) == false

@test @inferred(h(2)) == f(2)::Int

g() = nothing

@provide g(a, b::AbstractVector{<:Number}) = a.*b

@test provided(g, 1, [1.0]) == true
@test provided(g, typeof((1, [1.0]))) == true
@test g(1, [1.0]) == [1.0]
@test provided(g, 1, ["one"]) == false

struct MyCommonEnv <: CommonEnv end

@test provided(reset!, MyCommonEnv())
@test !provided(clone, MyCommonEnv())
@provide CommonRLInterface.clone(::MyCommonEnv) = MyCommonEnv()
@test provided(clone, MyCommonEnv())
@test clone(MyCommonEnv()) == MyCommonEnv()

end
