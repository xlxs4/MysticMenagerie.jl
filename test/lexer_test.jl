using MysticMenagerie, Test

const m = MysticMenagerie

l = m.Lexer("=+(){},;")
expected = map(x -> m.Token(x...),
               [
                   (m.ASSIGN, "="),
                   (m.PLUS, "+"),
                   (m.LPAREN, "("),
                   (m.RPAREN, ")"),
                   (m.LBRACE, "{"),
                   (m.RBRACE, "}"),
                   (m.COMMA, ","),
                   (m.SEMICOLON, ";"),
                   (m.EOF, ""),
               ])

for token in expected
    @test m.next_token!(l) == token
end

l = m.Lexer("""
            let add = fn(x, y) {
                x + y;
            };
            """)
expected = map(x -> m.Token(x...),
               [
                   (m.LET, "let"),
                   (m.IDENT, "add"),
                   (m.ASSIGN, "="),
                   (m.FUNCTION, "fn"),
                   (m.LPAREN, "("),
                   (m.IDENT, "x"),
                   (m.COMMA, ","),
                   (m.IDENT, "y"),
                   (m.RPAREN, ")"),
                   (m.LBRACE, "{"),
                   (m.IDENT, "x"),
                   (m.PLUS, "+"),
                   (m.IDENT, "y"),
                   (m.SEMICOLON, ";"),
                   (m.RBRACE, "}"),
                   (m.SEMICOLON, ";"),
               ])

for token in expected
    @test m.next_token!(l) == token
end
