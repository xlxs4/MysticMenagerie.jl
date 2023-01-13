@testset "Test BANG operator PrefixExpression" begin for (code, expected) in [
    ("!true", false),
    ("!false", true),
    ("!5", false),
    ("!!true", true),
    ("!!false", false),
    ("!!5", true),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end

@testset "Test IfExpression" begin for (code, expected) in [
    ("if (true) { 10 }", 10),
    ("if (false) { 10 }", nothing),
    ("if (1) { 10 }", 10),
    ("if (1 < 2) { 10 }", 10),
    ("if (1 > 2) { 10 }", nothing),
    ("if (1 < 2) { 10 } else { 20 }", 10),
    ("if (1 > 2) { 10 } else { 20 }", 20),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end
