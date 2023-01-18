using MysticMenagerie

const m = MysticMenagerie

l = m.Lexer("""
            let five = 5;
            let ten = 10;

            let add = fn(x, y) {
                x + y;
            };

            let result = add(five, ten);

            "foobar"
            "foo bar"
            """)
expected = map(x -> m.Token(x...),
               [
                   (m.LET, "let"),
                   (m.IDENT, "five"),
                   (m.ASSIGN, "="),
                   (m.INT, "5"),
                   (m.SEMICOLON, ";"),
                   (m.LET, "let"),
                   (m.IDENT, "ten"),
                   (m.ASSIGN, "="),
                   (m.INT, "10"),
                   (m.SEMICOLON, ";"),
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
                   (m.LET, "let"),
                   (m.IDENT, "result"),
                   (m.ASSIGN, "="),
                   (m.IDENT, "add"),
                   (m.LPAREN, "("),
                   (m.IDENT, "five"),
                   (m.COMMA, ","),
                   (m.IDENT, "ten"),
                   (m.RPAREN, ")"),
                   (m.SEMICOLON, ";"),
                   (m.STRING, "foobar"),
                   (m.STRING, "foo bar"),
                   (m.EOF, ""),
               ])

for token in expected
    @test m.next_token!(l) == token
end
