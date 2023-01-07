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

l = m.Lexer("5 < 10 > 5;")
expected = map(x -> m.Token(x...),
               [
                   (m.INT, "5"),
                   (m.LT, "<"),
                   (m.INT, "10"),
                   (m.GT, ">"),
                   (m.INT, "5"),
                   (m.SEMICOLON, ";"),
               ])

for token in expected
    @test m.next_token!(l) == token
end

l = m.Lexer("""
            let five = 5;
            let ten = 10;

            let add = fn(x, y) {
                x + y;
            };

            let result = add(five, ten);
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
               ])

for token in expected
    @test m.next_token!(l) == token
end

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

l = m.Lexer("""
            10 == 10;
            10 != 9;
            """)
expected = map(x -> m.Token(x...),
               [
                   (m.INT, "10"),
                   (m.EQ, "=="),
                   (m.INT, "10"),
                   (m.SEMICOLON, ";"),
                   (m.INT, "10"),
                   (m.NOT_EQ, "!="),
                   (m.INT, "9"),
                   (m.SEMICOLON, ";"),
               ])

for token in expected
    @test m.next_token!(l) == token
end
