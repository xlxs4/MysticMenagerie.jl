using MysticMenagerie, Test

const m = MysticMenagerie

function check_parser_errors(p::m.Parser)
    if !isempty(p.errors)
        return join(vcat(["parser has $(length(p.errors)) errors"],
                         ["parser error: $e" for e in p.errors]), "\n")
    end
    return nothing
end

function test_let_statement(ls::m.Statement, name::String)
    @assert(isa(ls, m.LetStatement),
            "Statement is $(typeof(ls)) instead of LetStatement.")
    @assert(ls.name.value==name,
            "Statement name value is $(ls.name.value) instead of $name.")
    @assert(m.token_literal(ls.name)==name,
            "Statement name token literal is $(m.token_literal(ls.name)) instead of $name.")
end

function test_identifier_expression(id::m.Expression, value::String)
    @assert(isa(id, m.Identifier),
            "Expression is $(typeof(id)) instead of Identifier.")
    @assert(id.value==value,
            "Expression value is $(id.value) instead of $value.")
    @assert(m.token_literal(id)==value,
            "Expression token literal is $(m.token_literal(id)) instead of $value.")
end

function test_integer_literal_expression(il::m.Expression, value::Int64)
    @assert(isa(il, m.IntegerLiteral),
            "Expression is $(typeof(il)) instead of IntegerLiteral.")
    @assert(il.value==value,
            "Expression value is $(il.value) instead of $value.")
    @assert(m.token_literal(il)==string(value),
            "Expression token literal is $(m.token_literal(il)) instead of $value.")
end

@testset "Test parsing invalid LetStatement" begin
    l = m.Lexer("""
                let 5;
                let x 5;
                """)
    p = m.Parser(l)
    program = m.parse_program!(p)
    expected = """
    parser has 2 errors
    parser error: expected next token to be IDENT, got INT instead
    parser error: expected next token to be ASSIGN, got INT instead
    """
    @test check_parser_errors(p) == chomp(expected)
end

@testset "Test parsing valid LetStatement" begin
    l = m.Lexer("""
                let x = 5;
                let y = 10;
                let foobar = 838383;
                """)

    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test begin
        isnothing(msg) || error(msg)
        @assert(length(program.statements)==3,
                "Input program contains $(length(program.statements)) statements instead of 3.")

        true
    end

    for (i, expected) in enumerate(["x", "y", "foobar"])
        @test begin
            @assert(isa(program.statements[i], m.Statement),
                    "Program statement is $(typeof(program.statements[i])) instead of Statement.")
            test_let_statement(program.statements[i], expected)

            true
        end
    end
end

@testset "Test parsing ReturnStatement" begin
    l = m.Lexer("""
                return 5;
                return 10;
                return 993322;
                """)

    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test begin
        isnothing(msg) || error(msg)
        @assert(length(program.statements)==3,
                "Input program contains $(length(program.statements)) statements instead of 3.")

        true
    end

    for i in 1:3
        @test begin
            @assert(isa(program.statements[i], m.ReturnStatement),
                    "Program statement is $(typeof(program.statements[i])) instead of ReturnStatement.")
            @assert m.token_literal(program.statements[i]) == "return"

            true
        end
    end
end

@testset "Test parsing Identifier ExpressionStatement" begin
    l = m.Lexer("foobar;")
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test begin
        isnothing(msg) || error(msg)
        @assert(length(program.statements)==1,
                "Input program contains $(length(program.statements)) statements instead of 1.")
        @assert(isa(program.statements[1], m.ExpressionStatement),
                "Program statement is $(typeof(program.statements[1])) instead of ExpressionStatement.")
        test_identifier_expression(program.statements[1].expression, "foobar")

        true
    end
end

@testset "Test parsing IntegerLiteral ExpressionStatement" begin
    l = m.Lexer("5;")
    p = m.Parser(l)
    program = m.parse_program!(p)
    msg = check_parser_errors(p)

    @test begin
        isnothing(msg) || error(msg)
        @assert(length(program.statements)==1,
                "Input program contains $(length(program.statements)) statements instead of 1.")
        @assert(isa(program.statements[1], m.ExpressionStatement),
                "Program statement is $(typeof(program.statements[1])) instead of ExpressionStatement.")
        test_integer_literal_expression(program.statements[1].expression, 5)

        true
    end
end
