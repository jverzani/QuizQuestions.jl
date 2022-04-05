using QuizQuestions
using Test

@testset "QuizQuestions.jl" begin
    @test numericq(1).tol == 0
    @test numericq(1, 1e-3; hint="hint").hint == "hint"

    @test stringq(r"abc").re == r"abc"
    @test_throws MethodError stringq("abc") # need regular expression

    @test radioq(["one","two", "three"], 1, keep_order=true).answer == 1
    @test radioq(1:3, 1, keep_order=true).answer == 1

    @test multiq(("one","two","three"), (2, 3), label="Primes?").label == "Primes?"
end
