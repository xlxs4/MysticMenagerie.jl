using MysticMenagerie, Test

const m = MysticMenagerie

@testset "Test token_literal" begin for (program, expected) in [
    (m.Program([]), ""),
    (m.Program([
                   m.LetStatement(m.Token(m.LET, "let"),
                                  m.Identifier(m.Token(m.IDENT, "myVar"), "myVar"),
                                  m.Identifier(m.Token(m.IDENT, "anotherVar"),
                                               "anotherVar")),
               ]),
     "let"),
]
    @test m.token_literal(program) == expected
end end

@testset "Test Base.string(program)" begin for (code, expected) in [
    ("""
     let a = 1;
     let b = a + 2;

     let f = if (true) {
         fn(x) { x + 1; }
     } else { 
         fn(x) { return x * 2; }
     }

     let c = f(b); 

     let d = 1 + 2 * 3 / a * (5 - 2 * -3);
     """,
     "let a = 1;let b = (a + 2);let f = if (true) { fn(x) (x + 1) } else { fn(x) return (x * 2); };let c = f(b);let d = (1 + (((2 * 3) / a) * (5 - (2 * (-3)))));")
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    @test string(program) == expected
end end
