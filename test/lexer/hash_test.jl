@testset "Test hash token set" begin
    l = m.Lexer("{\"foo\": \"bar\"}")
    expected = map(x -> m.Token(x...),
                   [
                       (m.LBRACE, "{"),
                       (m.STRING, "foo"),
                       (m.COLON, ":"),
                       (m.STRING, "bar"),
                       (m.RBRACE, "}"),
                       (m.EOF, ""),
                   ])

    for token in expected
        @test m.next_token!(l) == token
    end
end
