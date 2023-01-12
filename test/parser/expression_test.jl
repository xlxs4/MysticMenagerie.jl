@testset "Test parsing Identifier Expression" begin for (code, value) in [
    ("foobar;", "foobar")
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    ident = stmt.expression
    test_literal_expression(ident, value)
end end

@testset "Test parsing Boolean Expression" begin for (code, value) in [
    ("true;", true),
    ("false;", false),
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    boolean = stmt.expression
    test_literal_expression(boolean, value)
end end

@testset "Test parsing invalid PrefixExpression" begin for (code, expected_error) in [
    ("#;", "parser error: no prefix parse function for ILLEGAL found")
]
    _, p, _ = parse_from_code!(code)
    @test split(check_parser_errors(p), '\n')[2] == expected_error
end end

@testset "Test parsing valid PrefixExpression" begin

for (code, operator, right_value) in [
    ("!5;", "!", 5),
    ("-15;", "-", 15),
    ("!true;", "!", true),
    ("!false;", "!", false),
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    expr = stmt.expression
    @test expr isa m.PrefixExpression
    @test expr.operator == operator

    test_literal_expression(expr.right, right_value)
end end

@testset "Test parsing InfixExpression" begin for (code, left, operator, right) in [
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

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    expr = stmt.expression
    test_infix_expression(expr, left, operator, right)
end end

@testset "Test parsing if-only IfExpression" begin for (code) in [("if (x < y) { x }")]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    expr = stmt.expression
    @test expr isa m.IfExpression

    test_infix_expression(expr.condition, "x", "<", "y")

    @test length(expr.consequence.statements) == 1

    consequence = expr.consequence.statements[1]
    @test consequence isa m.ExpressionStatement

    test_identifier(consequence.expression, "x")

    @test isnothing(expr.alternative)
end end

@testset "Test parsing if-else IfExpression" begin for (code) in [("if (x < y) { x } else { y }")]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    expr = stmt.expression
    @test expr isa m.IfExpression

    test_infix_expression(expr.condition, "x", "<", "y")

    @test length(expr.consequence.statements) == 1

    consequence = expr.consequence.statements[1]
    @test consequence isa m.ExpressionStatement

    test_identifier(consequence.expression, "x")

    @test length(expr.alternative.statements) == 1

    alternative = expr.alternative.statements[1]
    @test alternative isa m.ExpressionStatement

    test_identifier(alternative.expression, "y")
end end

@testset "Test parsing empty CallExpression" begin for (code, expected_ident) in [
    ("foo()", "foo")
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    expr = stmt.expression
    @test expr isa m.CallExpression

    test_identifier(expr.fn, expected_ident)
    @test isempty(expr.arguments)
end end

@testset "Test parsing CallExpression with arguments" begin for (code, expected_ident, left, operator, right) in [
    ("add(1, 2 * 3, 4 + 5)",
     "add",
     (2, 4),
     ("*", "+"),
     (3, 5))
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    expr = stmt.expression
    @test expr isa m.CallExpression

    test_identifier(expr.fn, expected_ident)

    @test length(expr.arguments) == 3

    test_literal_expression(expr.arguments[1], 1)

    test_infix_expression(expr.arguments[2], left[1], operator[1], right[1])
    test_infix_expression(expr.arguments[3], left[2], operator[2], right[2])
end end
