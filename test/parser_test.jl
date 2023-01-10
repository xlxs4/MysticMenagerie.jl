using MysticMenagerie, Test

const m = MysticMenagerie

function check_parser_errors(p::m.Parser)
    if !isempty(p.errors)
        msg = join(vcat(["parser has $(length(p.errors)) errors"],
                        ["parser error: $e" for e in p.errors]), "\n")
        error(msg)
    end
end

function test_let_statement(ls::m.Statement, name::String)
    @assert(isa(ls, m.LetStatement),
            "Statement is $(typeof(ls)) instead of LetStatement.")
    @assert(ls.name.value==name,
            "Statement name value is $(ls.name.value) instead of $name.")
    @assert(m.token_literal(ls.name)==name,
            "Statement name token literal is $(m.token_literal(ls.name)) instead of $name.")
end

function test_identifier_expression(expr::m.Expression, value::String)
    @assert(isa(expr, m.Identifier),
            "Expression is $(typeof(expr)) instead of Identifier.")
    @assert(expr.value==value,
            "Expression value is $(expr.value) instead of $value.")
    @assert(m.token_literal(expr)==value,
            "Expression token literal is $(m.token_literal(expr)) instead of $value.")
end

@testset "Test parsing LetStatement" begin
    l = m.Lexer("""
                let x = 5;
                let y = 10;
                let foobar = 838383;
                """)

    p = m.Parser(l)
    program = m.parse_program!(p)

    @test begin
        check_parser_errors(p)
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

    @test begin
        check_parser_errors(p)
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

    @test begin
        check_parser_errors(p)
        @assert(length(program.statements)==1,
                "Input program contains $(length(program.statements)) statements instead of 1.")
        @assert(isa(program.statements[1], m.ExpressionStatement),
                "Program statement is $(typeof(program.statements[1])) instead of ExpressionStatement.")
        test_identifier_expression(program.statements[1].expression, "foobar")

        true
    end
end
