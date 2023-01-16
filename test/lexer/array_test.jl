@testset "Test array token set" begin
    l = m.Lexer("[1, 2];")
    expected = map(x -> m.Token(x...),
                   [
                       (m.LBRACKET, "["),
                       (m.INT, "1"),
                       (m.COMMA, ","),
                       (m.INT, "2"),
                       (m.RBRACKET, "]"),
                       (m.SEMICOLON, ";"),
                       (m.EOF, ""),
                   ])

    for token in expected
        @test m.next_token!(l) == token
    end
end
