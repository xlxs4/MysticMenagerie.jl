using MysticMenagerie

const m = MysticMenagerie

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
