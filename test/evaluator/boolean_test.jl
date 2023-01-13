@testset "Test evaluating BooleanLiteral" begin for (code, expected) in [
    ("true", true),
    ("false", false),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_boolean_object(evaluated, expected)
end end
