using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

@testset "Test Identifier" begin for (code, value) in [
    ("foobar;", "foobar")
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    ident = statement.expression
    test_literal_expression(ident, value)
end end

@testset "Test Boolean Keyword" begin for (code, value) in [
    ("true;", true),
    ("false;", false),
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    boolean = statement.expression
    test_literal_expression(boolean, value)
end end

@testset "Test ILLEGAL PrefixExpression" begin for (code, expected_error) in [
    ("#;", "parser error: no prefix parse function for ILLEGAL found")
]
    _, p, _ = parse_from_code!(code)
    @test split(check_parser_errors(p), '\n')[2] == expected_error
end end

@testset "Test PrefixExpression" begin for (code, operator, right_value) in [
    ("!5;", "!", 5),
    ("-15;", "-", 15),
    ("!true;", "!", true),
    ("!false;", "!", false),
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    expression = statement.expression
    @test expression isa m.PrefixExpression
    @test expression.operator == operator

    test_literal_expression(expression.right, right_value)
end end

@testset "Test InfixExpression" begin for (code, left, operator, right) in [
    ("5 + 5;", 5, "+", 5),
    ("5 - 5;", 5, "-", 5),
    ("5 * 5;", 5, "*", 5),
    ("5 / 5;", 5, "/", 5),
    ("5 > 5;", 5, ">", 5),
    ("5 < 5;", 5, "<", 5),
    ("5 == 5;", 5, "==", 5),
    ("5 != 5;", 5, "!=", 5),
    ("true == true", true, "==", true),
    ("true != false", true, "!=", false),
    ("false == false", false, "==", false),
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    expression = statement.expression
    test_infix_expression(expression, left, operator, right)
end end

@testset "Test If" begin for (code) in [("if (x < y) { x }")]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    expression = statement.expression
    @test expression isa m.IfExpression

    test_infix_expression(expression.condition, "x", "<", "y")

    @test length(expression.consequence.statements) == 1

    consequence = expression.consequence.statements[1]
    @test consequence isa m.ExpressionStatement

    test_identifier(consequence.expression, "x")

    @test isnothing(expression.alternative)
end end

@testset "Test If Else" begin for (code) in [("if (x < y) { x } else { y }")]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    expression = statement.expression
    @test expression isa m.IfExpression

    test_infix_expression(expression.condition, "x", "<", "y")

    @test length(expression.consequence.statements) == 1

    consequence = expression.consequence.statements[1]
    @test consequence isa m.ExpressionStatement

    test_identifier(consequence.expression, "x")

    @test length(expression.alternative.statements) == 1

    alternative = expression.alternative.statements[1]
    @test alternative isa m.ExpressionStatement

    test_identifier(alternative.expression, "y")
end end

@testset "Test CallExpression" begin for (code, expected_ident) in [
    ("foo()", "foo")
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    expression = statement.expression
    @test expression isa m.CallExpression

    test_identifier(expression.fn, expected_ident)
    @test isempty(expression.arguments)
end end

@testset "Test CallExpression with Arguments" begin for (code, expected_ident, left, operator, right) in [
    ("add(1, 2 * 3, 4 + 5)",
     "add",
     (2, 4),
     ("*", "+"),
     (3, 5))
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    expression = statement.expression
    @test expression isa m.CallExpression

    test_identifier(expression.fn, expected_ident)

    @test length(expression.arguments) == 3

    test_literal_expression(expression.arguments[1], 1)

    test_infix_expression(expression.arguments[2], left[1], operator[1],
                          right[1])
    test_infix_expression(expression.arguments[3], left[2], operator[2],
                          right[2])
end end

@testset "Test IndexExpression" begin for (code, left, operator, right) in [
    ("myArray[1 + 1]", 1, "+", 1)
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    expression = statement.expression
    @test expression isa m.IndexExpression

    test_identifier(expression.left, "myArray")
    test_infix_expression(expression.index, left, operator, right)
end end
