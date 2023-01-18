using MysticMenagerie

const m = MysticMenagerie

@testset "Test Node Construction" begin
    struct DummyObject <: m.AbstractObject end

    @test m.AbstractNode(DummyObject()) == m.NullLiteral(m.Token(m.NULL, "null"))
    @test m.AbstractNode(m.IntegerObj(1)) == m.IntegerLiteral(m.Token(m.INT, "1"), 1)

    @test m.AbstractNode(m.StringObj("foo")) ==
          m.StringLiteral(m.Token(m.STRING, "foo"), "foo")

    @test m.AbstractNode(m.BooleanObj(true)) ==
          m.BooleanLiteral(m.Token(m.TRUE, "true"), true)

    @test m.AbstractNode(m.ArrayObj([m.IntegerObj(1), m.IntegerObj(2), m.IntegerObj(3)])).token ==
          (m.Token(m.LBRACKET, "["))

    @test m.AbstractNode(m.ArrayObj([m.IntegerObj(1), m.IntegerObj(2), m.IntegerObj(3)])).elements ==
          map(m.AbstractNode,
              m.ArrayObj([m.IntegerObj(1), m.IntegerObj(2), m.IntegerObj(3)]).elements)

    @test m.AbstractNode(m.HashObj(Dict(m.StringObj("foo") => m.IntegerObj(1)))).pairs ==
          m.HashLiteral(m.Token(m.LBRACE, "{"),
                        Dict(m.AbstractNode(m.StringObj("foo")) => m.AbstractNode(m.IntegerObj(1)))).pairs

    m.AbstractNode(m.FunctionObj([m.Identifier(m.Token(m.IDENT, "x"), "x")],
                                 m.BlockStatement(m.Token(m.LBRACE, "{"),
                                                  [
                                                      m.ExpressionStatement(m.Token(m.IDENT,
                                                                                    "x"),
                                                                            m.InfixExpression(m.Token(m.PLUS,
                                                                                                      "+"),
                                                                                              m.Identifier(m.Token(m.IDENT,
                                                                                                                   "x"),
                                                                                                           "x"),
                                                                                              "+",
                                                                                              m.IntegerLiteral(m.Token(m.INT,
                                                                                                                       "2"),
                                                                                                               2))),
                                                  ]), m.Environment())) ==
    m.FunctionLiteral(m.Token(m.FUNCTION, "fn"), [m.Identifier(m.Token(m.IDENT, "x"), "x")],
                      m.BlockStatement(m.Token(m.LBRACE, "{"),
                                       [
                                           m.ExpressionStatement(m.Token(m.IDENT,
                                                                         "x"),
                                                                 m.InfixExpression(m.Token(m.PLUS,
                                                                                           "+"),
                                                                                   m.Identifier(m.Token(m.IDENT,
                                                                                                        "x"),
                                                                                                "x"),
                                                                                   "+",
                                                                                   m.IntegerLiteral(m.Token(m.INT,
                                                                                                            "2"),
                                                                                                    2))),
                                       ]))
end
