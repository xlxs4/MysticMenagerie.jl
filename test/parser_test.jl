using MysticMenagerie, Test

const m = MysticMenagerie

function check_parser_errors(p::m.Parser)
    if !isempty(p.errors)
        return join(vcat(["parser has $(length(p.errors)) errors"],
                         ["parser error: $e" for e in p.errors]), "\n")
    end
    return nothing
end

function test_identifier(id::m.Expression, value::String)
    @test id isa m.Identifier
    @test id.value == value
    @test m.token_literal(id) == value
end

function test_integer_literal(il::m.Expression, value::Int64)
    @test il isa m.IntegerLiteral
    @test il.value == value
    @test m.token_literal(il) == string(value)
end

function test_literal_expression(expr::m.Expression, expected)
    if expected isa Int
        test_integer_literal(expr, Int64(expected))
    elseif expected isa String
        test_identifier(expr, expected)
    else
        error("Unexpected type for $expected.")
    end
end

function test_infix_expression(expr::m.Expression, left, operator::String, right)
    @test expr isa m.InfixExpression
    test_literal_expression(expr.left, left)

    @test expr.operator == operator
    test_literal_expression(expr.right, right)
end

function test_let_statement(ls::m.Statement, name::String)
    @test ls isa m.LetStatement
    @test ls.name.value == name
    @test m.token_literal(ls.name) == name
end

@testset "Test parsing invalid LetStatement" begin for (code, expected_error) in [
    ("let 5;", "parser error: expected next token to be IDENT, got INT instead"),
    ("let x 5;", "parser error: expected next token to be ASSIGN, got INT instead"),
]
    l = m.Lexer(code)
    p = m.Parser(l)
    m.parse_program!(p)
    @test split(check_parser_errors(p), '\n')[2] == expected_error
end end

@testset "Test parsing valid LetStatement" begin for (code, expected_ident, expected_value) in [
    ("let x = 5;", "x", 5),
    ("let y = 10;", "y", 10),
    ("let foobar = 838383;", "foobar", 838383),
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.Statement
    test_let_statement(stmt, expected_ident)

    value = stmt.value
    test_literal_expression(value, expected_value)
end end

@testset "Test parsing ReturnStatement" begin for (code, expected_value) in [
    ("return 5;", 5),
    ("return 10;", 10),
    ("return 993322;", 993322),
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ReturnStatement

    value = stmt.return_value
    test_literal_expression(value, expected_value)
end end

@testset "Test parsing Identifier Expression" begin for (code, value) in [("foobar;",
                                                                           "foobar")]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    ident = stmt.expression
    test_literal_expression(ident, value)
end end

@testset "Test parsing invalid IntegerLiteral" begin for (code, expected_error) in [("foo",
                                                                                     "parser error: could not parse foo as integer")]
    l = m.Lexer(code)
    p = m.Parser(l)
    m.parse_integer_literal!(p)
    @test split(check_parser_errors(p), '\n')[2] == expected_error
end end

@testset "Test parsing valid IntegerLiteral Expression" begin for (code, value) in [("5;",
                                                                                     5)]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    il = stmt.expression
    test_literal_expression(il, value)
end end

@testset "Test parsing invalid PrefixExpression" begin for (code, expected_error) in [
    ("#;", "parser error: no prefix parse function for ILLEGAL found")
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    @test split(check_parser_errors(p), '\n')[2] == expected_error
end end

@testset "Test parsing valid PrefixExpression" begin

for (code, operator, right_value) in [
    ("!5;", "!", 5),
    ("-15;", "-", 15),
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    expr = stmt.expression
    @test expr isa m.PrefixExpression
    @test expr.operator == operator

    test_literal_expression(expr.right, right_value)
end end

@testset "Test parsing InfixExpression" begin for (code, left_value, operator, right_value) in [
    ("5 + 5;", 5, "+", 5),
    ("5 - 5;", 5, "-", 5),
    ("5 * 5;", 5, "*", 5),
    ("5 / 5;", 5, "/", 5),
    ("5 > 5;", 5, ">", 5),
    ("5 < 5;", 5, "<", 5),
    ("5 == 5;", 5, "==", 5),
    ("5 != 5;", 5, "!=", 5),
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    expr = stmt.expression
    test_infix_expression(expr, left_value, operator, right_value)
end end
