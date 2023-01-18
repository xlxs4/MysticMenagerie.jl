using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

@testset "Test Invalid LetStatement" begin for (code, expected_error) in [
    ("let 5;", "parser error: expected next token to be IDENT, got INT instead"),
    ("let x 5;", "parser error: expected next token to be ASSIGN, got INT instead"),
]
    _, p, _ = parse_from_code!(code)
    @test split(check_parser_errors(p), '\n')[2] == expected_error
end end

@testset "Test LetStatement" begin for (code, expected_ident, expected_value) in [
    ("let x = 5;", "x", 5),
    ("let y = true;", "y", true),
    ("let foobar = y;", "foobar", "y"),
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.AbstractStatement
    test_let_statement(statement, expected_ident)

    val = statement.value
    test_literal_expression(val, expected_value)
end end

@testset "Test ReturnStatement" begin for (code, expected_value) in [
    ("return 5;", 5),
    ("return false;", false),
    ("return y;", "y"),
]
    _, p, program = parse_from_code!(code)
    test_parser_errors(p)

    @test length(program.statements) == 1

    statement = program.statements[1]
    @test statement isa m.ReturnStatement

    val = statement.return_value
    test_literal_expression(val, expected_value)
end end
