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

    test_boolean_object(evaluated, expected)
end end
