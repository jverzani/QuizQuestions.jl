using QuizQuestions
using Test

@testset "QuizQuestions.jl" begin
    @test numericq(1).tol == 0
    @test numericq(1, 1e-3; hint="hint").hint == "hint"

    @test stringq(r"abc").re == r"abc"
    @test_throws MethodError stringq("abc") # need regular expression

    @test radioq(["one","two", "three"], 1, keep_order=true).answer == 1
    @test radioq(1:3, 1, keep_order=true).answer == 1

    @test buttonq(["one","two", "three"], 1).answer == ["correct", "incorrect", "incorrect"]

    @test multiq(("one","two","three"), (2, 3), label="Primes?").label == "Primes?"

    @test fillblankq("question ____", r"1", label="one").label == "one"
    @test fillblankq("question ____", ("1","2","3"), 1, label="one").label == "one"
    @test fillblankq("question ____", 1, label="one").label == "one"

    d = Dict("Select a Volvo" => "XC90", "Select a Mercedes" => "GLE 350",
             "Select an Audi" => "A4")
    r = matchq(d)
    i = rand(1:3)
    @test d[r.questions[i]] == r.choices[r.answer[i]]

    r = hotspotq("empty", (0,0), (1,1); explanation="XXX")
    @test r.explanation == "XXX"

    r = plotlylightq("empty"; label="XXX")
    @test r.label == "XXX"

end
