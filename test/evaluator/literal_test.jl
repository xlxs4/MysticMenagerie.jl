@testset "Test evaluating IntegerLiteral" begin for (code, expected) in [
    ("5", 5),
    ("10", 10),
    ("-5", -5),
    ("-10", -10),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_integer_object(evaluated, expected)
end end

@testset "Test evaluating BooleanLiteral" begin for (code, expected) in [
    ("true", true),
    ("false", false),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_boolean_object(evaluated, expected)
end end
