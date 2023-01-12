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
    ("let y = true;", "y", true),
    ("let foobar = y;", "foobar", "y"),
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

    val = stmt.value
    test_literal_expression(val, expected_value)
end end

@testset "Test parsing ReturnStatement" begin for (code, expected_value) in [
    ("return 5;", 5),
    ("return false;", false),
    ("return y;", "y"),
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test isnothing(msg) || error(msg)
    @test length(program.statements) == 1

    stmt = program.statements[1]
    @test stmt isa m.ReturnStatement

    val = stmt.return_value
    test_literal_expression(val, expected_value)
end end
