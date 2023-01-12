@testset "Test parsing invalid IntegerLiteral" begin for (code, expected_error) in [
    ("foo", "parser error: could not parse foo as integer")
]
    l = m.Lexer(code)
    p = m.Parser(l)
    m.parse_integer_literal!(p)
    @test split(check_parser_errors(p), '\n')[2] == expected_error
end end

@testset "Test parsing valid IntegerLiteral" begin for (code, value) in [
    ("5;", 5)
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    il = stmt.expression
    test_literal_expression(il, value)
end end

@testset "Test parsing FunctionLiteral" begin for (code) in [("fn(x, y) { x + y; }")]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    fn = stmt.expression
    @test fn isa m.FunctionLiteral
    @test length(fn.parameters) == 2

    test_literal_expression(fn.parameters[1], "x")
    test_literal_expression(fn.parameters[2], "y")

    @test length(fn.body.statements) == 1

    body_stmt = fn.body.statements[1]
    @test body_stmt isa m.ExpressionStatement

    test_infix_expression(body_stmt.expression, "x", "+", "y")
end end

@testset "Test parsing FunctionLiteral parameters" begin for (code, expected) in [
    ("fn() {};", []),
    ("fn(x) {};", ["x"]),
    ("fn(x, y, z) {};", ["x", "y", "z"]),
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    fn = stmt.expression
    @test length(fn.parameters) == length(expected)

    for (parameter, expected_parameter) in zip(fn.parameters, expected)
        test_literal_expression(parameter, expected_parameter)
    end
end end
