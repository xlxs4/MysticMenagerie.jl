using MysticMenagerie, Test

const m = MysticMenagerie

l = m.Lexer("""
            let x = 5;
            let y = 10;
            let foobar = 838383;
            """)

p = m.Parser(l)
program = m.parse_program!(p)

@test length(program.statements) == 3

function test_let_statement(ls::m.LetStatement, name::String)
    m.token_literal(ls.name) == name || return false
    ls.name.value == name || return false
    return true
end

for (i, expected) in enumerate(["x", "y", "foobar"])
    @test test_let_statement(program.statements[i], expected)
end
