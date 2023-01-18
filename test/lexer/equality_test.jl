using MysticMenagerie

const m = MysticMenagerie

@testset "Test Equality Token Set" begin
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
end
