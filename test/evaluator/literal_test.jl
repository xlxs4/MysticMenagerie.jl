@testset "Test evaluating IntegerLiteral" begin for (code, expected) in [
    ("5", 5),
    ("10", 10),
    ("-5", -5),
    ("-10", -10),
    ("5 + 5 + 5 + 5 - 10", 10),
    ("2 * 2 * 2 * 2 * 2", 32),
    ("-50 + 100 + -50", 0),
    ("5 * 2 + 10", 20),
    ("5 + 2 * 10", 25),
    ("20 + 2 * -10", 0),
    ("50 / 2 * 2 + 10", 60),
    ("2 * (5 + 10)", 30),
    ("3 * 3 * 3 + 10", 37),
    ("3 * (3 * 3) + 10", 37),
    ("(5 + 10 * 2 + 15 / 3) * 2 + -10", 50),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end

@testset "Test evaluating BooleanLiteral" begin for (code, expected) in [
    ("true", true),
    ("false", false),
    ("1 < 2", true),
    ("1 > 2", false),
    ("1 < 1", false),
    ("1 > 1", false),
    ("1 == 1", true),
    ("1 != 1", false),
    ("1 == 2", false),
    ("1 != 2", true),
    ("true == true", true),
    ("false == false", true),
    ("true == false", false),
    ("true != false", true),
    ("false != true", true),
    ("(1 < 2) == true", true),
    ("(1 < 2) == false", false),
    ("(1 > 2) == true", false),
    ("(1 > 2) == false", true),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end

@testset "Test evaluating StringLiteral" begin for (code, expected) in [
    ("\"Hello world!\"", "Hello world!")
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.StringObj

    test_object(evaluated, expected)
end end

@testset "Test evaluating FunctionLiteral" begin for (code, expected_parameter, expected_body) in [
    ("fn(x) { x + 2; };", "x", "(x + 2)")
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    @test evaluated isa m.FunctionObj
    test_object(evaluated, expected_parameter, expected_body)
end end
