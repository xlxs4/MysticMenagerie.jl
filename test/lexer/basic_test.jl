using MysticMenagerie

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
