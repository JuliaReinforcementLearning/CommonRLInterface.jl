@testset "@provide" begin
    @provide f(x) = x^2
    @test provided(f, 2)
end
