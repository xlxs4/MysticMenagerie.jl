@testset "Test if-else/return token set" begin
    l = m.Lexer("""
                    if (5 < 10) {
                        return true;
                    } else {
                        return false;
                    }
                    """)
    expected = map(x -> m.Token(x...),
                   [
                       (m.IF, "if"),
                       (m.LPAREN, "("),
                       (m.INT, "5"),
                       (m.LT, "<"),
                       (m.INT, "10"),
                       (m.RPAREN, ")"),
                       (m.LBRACE, "{"),
                       (m.RETURN, "return"),
                       (m.TRUE, "true"),
                       (m.SEMICOLON, ";"),
                       (m.RBRACE, "}"),
                       (m.ELSE, "else"),
                       (m.LBRACE, "{"),
                       (m.RETURN, "return"),
                       (m.FALSE, "false"),
                       (m.SEMICOLON, ";"),
                       (m.RBRACE, "}"),
                   ])

    for token in expected
        @test m.next_token!(l) == token
    end
end
