using MysticMenagerie

const m = MysticMenagerie

@testset "Test Illegal" begin
    l = m.Lexer("let __snake_case__ = #;")
    expected = map(x -> m.Token(x...),
                   [
                       (m.LET, "let"),
                       (m.IDENT, "__snake_case__"),
                       (m.ASSIGN, "="),
                       (m.ILLEGAL, "#"),
                       (m.SEMICOLON, ";"),
                   ])

    for token in expected
        @test m.next_token!(l) == token
    end
end
