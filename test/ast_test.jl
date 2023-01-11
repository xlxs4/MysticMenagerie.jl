using MysticMenagerie, Test

const m = MysticMenagerie

@testset "Test Base.string(program)" begin
    program = m.Program([
                            m.LetStatement(m.Token(m.LET, "let"),
                                           m.Identifier(m.Token(m.IDENT, "myVar"), "myVar"),
                                           m.Identifier(m.Token(m.IDENT, "anotherVar"),
                                                        "anotherVar")),
                        ])
    @test string(program) == "let myVar = anotherVar;"
end
