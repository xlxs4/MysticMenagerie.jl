using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

for (code, expected_error) in [
    ("foo", "parser error: could not parse foo as integer")
]
    l = m.Lexer(code)
    p = m.Parser(l)
    m.parse_integer_literal!(p)
    @test split(check_parser_errors(p), '\n')[2] == expected_error
end

for (code, value) in [
    ("5;", 5)
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    il = statement.expression
    test_literal_expression(il, value)
end

for (code, value) in [
    ("\"hello world\";", "hello world")
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    expression = statement.expression
    @test expression isa m.StringLiteral
    @test expression.value == value
end

for (code) in [("fn(x, y) { x + y; }")]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    fn = statement.expression
    @test fn isa m.FunctionLiteral
    @test length(fn.params) == 2

    test_literal_expression(fn.params[1], "x")
    test_literal_expression(fn.params[2], "y")

    @test length(fn.body.statements) == 1

    body_statement = fn.body.statements[1]
    @test body_statement isa m.ExpressionStatement

    test_infix_expression(body_statement.expression, "x", "+", "y")
end

for (code, expected) in [
    ("fn() {};", []),
    ("fn(x) {};", ["x"]),
    ("fn(x, y, z) {};", ["x", "y", "z"]),
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    fn = statement.expression
    @test length(fn.params) == length(expected)

    for (parameter, expected_parameter) in zip(fn.params, expected)
        test_literal_expression(parameter, expected_parameter)
    end
end

for (code) in [
    ("[1, 2 * 2, 3 + 3]")
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    al = statement.expression
    @test al isa m.ArrayLiteral

    @test length(al.elements) == 3
    test_literal_expression(al.elements[1], 1)

    test_infix_expression(al.elements[2], 2, "*", 2)
    test_infix_expression(al.elements[3], 3, "+", 3)
end

for (code, expected) in [
    ("{\"one\": 1, \"two\": 2, \"three\": 3}",
     Dict("one" => 1, "two" => 2, "three" => 3))
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    hl = statement.expression
    @test hl isa m.HashLiteral

    @test length(hl.pairs) == 3

    for (key, value) in hl.pairs
        @test key isa m.StringLiteral
        @test key.value in keys(expected)
        test_integer_literal(value, expected[key.value])
    end
end

for (code, tests) in [
    ("""{"one": 0 + 1, "two": 10 - 8, "three": 15 / 5}""",
     Dict("one" => x -> test_infix_expression(x, 0, "+", 1),
          "two" => x -> test_infix_expression(x, 10, "-", 8),
          "three" => x -> test_infix_expression(x, 15, "/", 5)))
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    hl = statement.expression
    @test hl isa m.HashLiteral

    @test length(hl.pairs) == 3

    for (key, value) in hl.pairs
        @test key isa m.StringLiteral
        @test key.value in keys(tests)
        tests[key.value](value)
    end
end

for (code, expected) in [
    ("{1: 1, 2: 2, 3: 3}",
     Dict(1 => 1, 2 => 2, 3 => 3))
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    hl = statement.expression
    @test hl isa m.HashLiteral

    @test length(hl.pairs) == 3

    for (key, value) in hl.pairs
        @test key isa m.IntegerLiteral
        @test key.value in keys(expected)
        test_integer_literal(value, expected[key.value])
    end
end

for (code, expected) in [
    ("{false: 0, true: 1}",
     Dict(false => 0, true => 1))
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    hl = statement.expression
    @test hl isa m.HashLiteral

    @test length(hl.pairs) == 2

    for (key, value) in hl.pairs
        @test key isa m.BooleanLiteral
        @test key.value in keys(expected)
        test_integer_literal(value, expected[key.value])
    end
end

for (code) in [
    ("{}")
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ExpressionStatement

    hl = statement.expression
    @test hl isa m.HashLiteral

    @test length(hl.pairs) == 0
end
