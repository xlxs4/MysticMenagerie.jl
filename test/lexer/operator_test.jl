@testset "Test operator token set" begin
    l = m.Lexer("!-/*5;")
    expected = map(x -> m.Token(x...),
                   [
                       (m.BANG, "!"),
                       (m.MINUS, "-"),
                       (m.SLASH, "/"),
                       (m.ASTERISK, "*"),
                       (m.INT, "5"),
                       (m.SEMICOLON, ";"),
                   ])

    for token in expected
        @test m.next_token!(l) == token
    end
end
