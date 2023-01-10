using MysticMenagerie, Test

const m = MysticMenagerie

function check_parser_errors(p::m.Parser)
    if !isempty(p.errors)
        msg = join(vcat(["parser has $(length(p.errors)) errors"],
                        ["parser error: $e" for e in p.errors]), "\n")
        error(msg)
    end
end

function test_let_statement(ls::m.LetStatement, name::String)
    m.token_literal(ls) == "let" || return false
    m.token_literal(ls.name) == name || return false
    ls.name.value == name || return false
    return true
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
        @assert length(program.statements)==3 "Input program does not contain 3 statements. Got $(length(program.statements)) instead."
        true
    end

    for (i, expected) in enumerate(["x", "y", "foobar"])
        @test begin
            @assert program.statements[i] isa m.LetStatement
            "Program statement is $(typeof(program.statements[i])) instead of LetStatement."

            test_let_statement(program.statements[i], expected)
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
        @assert length(program.statements)==3 "Input program does not contain 3 statements. Got $(length(program.statements)) instead."
        true
    end

    for i in 1:3
        @test begin
            @assert program.statements[i] isa m.ReturnStatement
            "Program statement is $(typeof(program.statements[i])) instead of ReturnStatement."

            @assert m.token_literal(program.statements[i]) == "return"
            true
        end
    end
end
