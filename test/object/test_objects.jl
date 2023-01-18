using MysticMenagerie

const m = MysticMenagerie

integer_obj = m.IntegerObj(1)
string_obj = m.StringObj("foo")
true_obj = m._TRUE
false_obj = m._FALSE
null_obj = m._NULL
error_obj = m.ErrorObj(m.TypeMismatch("BOOLEAN"))
array_obj = m.ArrayObj([m.IntegerObj(1), m.IntegerObj(2), m.IntegerObj(3)])
hash_obj = m.HashObj(Dict(m.StringObj("foo") => m.IntegerObj(1),
                          m.StringObj("bar") => m.IntegerObj(2)))
function_obj = m.FunctionObj([m.Identifier(m.Token(m.IDENT, "x"), "x")],
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
                                              ]),
                             m.Environment())
len = m.BUILTINS["len"]
return_value = m.ReturnValue(m._TRUE)
