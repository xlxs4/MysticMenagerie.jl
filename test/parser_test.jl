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

function test_boolean_literal(b::m.Boolean, value::Bool)
    @test b isa m.Boolean
    @test b.value == value
    @test m.token_literal(b) == string(value)
end

function test_literal_expression(expr::m.Expression, expected)
    if expected isa Int
        test_integer_literal(expr, Int64(expected))
    elseif expected isa String
        test_identifier(expr, expected)
    elseif expected isa Bool
        test_boolean_literal(expr, expected)
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

@testset "Test parsing Boolean Expression" begin for (code, value) in [
    ("true;", true),
    ("false;", false),
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ExpressionStatement

    boolean = stmt.expression
    test_literal_expression(boolean, value)
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
    ("!true;", "!", true),
    ("!false;", "!", false),
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
    ("true == true", true, "==", true),
    ("true != false", true, "!=", false),
    ("false == false", false, "==", false),
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

@testset "Test parsing if-only IfExpression" begin for (code) in [("if (x < y) { x }")]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
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
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
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

@testset "Test operator precedence" begin for (code, expected) in [
    ("-a * b", "((-a) * b)"),
    ("!-a", "(!(-a))"),
    ("a + b + c", "((a + b) + c)"),
    ("a + b - c", "((a + b) - c)"),
    ("a * b * c", "((a * b) * c)"),
    ("a * b / c", "((a * b) / c)"),
    ("a + b / c", "(a + (b / c))"),
    ("a + b * c + d / e - f", "(((a + (b * c)) + (d / e)) - f)"),
    ("3 + 4; -5 * 5", "(3 + 4)((-5) * 5)"),
    ("5 > 4 == 3 < 4", "((5 > 4) == (3 < 4))"),
    ("5 < 4 != 3 > 4", "((5 < 4) != (3 > 4))"),
    ("3 + 4 * 5 == 3 * 1 + 4 * 5", "((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))"),
    ("true", "true"),
    ("false", "false"),
    ("3 > 5 == false", "((3 > 5) == false)"),
    ("3 < 5 == true", "((3 < 5) == true)"),
    ("1 + (2 + 3) + 4", "((1 + (2 + 3)) + 4)"),
    ("(5 + 5) * 2", "((5 + 5) * 2)"),
    ("2 / (5 + 5)", "(2 / (5 + 5))"),
    ("-(5 + 5)", "(-(5 + 5))"),
    ("!(true == true)", "(!(true == true))"),
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
    @test string(program) == expected
end end
