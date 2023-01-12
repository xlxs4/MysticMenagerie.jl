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
