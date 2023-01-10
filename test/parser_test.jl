using MysticMenagerie, Test

const m = MysticMenagerie

function check_parser_errors(p::m.Parser)
    if !isempty(p.errors)
        msg = join(vcat(["parser has $(length(p.errors)) errors"],
                        ["parser error: $e" for e in p.errors]), "\n")
        error(msg)
    end
end

l = m.Lexer("""
            let x = 5;
            let y = 10;
            let foobar = 838383;
            """)

p = m.Parser(l)
program = m.parse_program!(p)

@test begin
    check_parser_errors(p)
    @assert length(program.statements) == 3
    true
end

function test_let_statement(ls::m.LetStatement, name::String)
    m.token_literal(ls.name) == name || return false
    ls.name.value == name || return false
    return true
end

for (i, expected) in enumerate(["x", "y", "foobar"])
    @test test_let_statement(program.statements[i], expected)
end
