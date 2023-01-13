function check_parser_errors(p::m.Parser)
    if !isempty(p.errors)
        return join(vcat(["parser has $(length(p.errors)) errors"],
                         ["parser error: $e" for e in p.errors]), "\n")
    end
    return nothing
end

function test_parser_errors(p::m.Parser)
    msg = check_parser_errors(p)
    @test isnothing(msg) || error(msg)
end

function test_identifier(id::m.Expression, value::String)
    @test id isa m.Identifier
    @test id.value == value
    @test m.token_literal(id) == value
end

function test_integer_literal(il::m.Expression, value::Int64)
    @test il isa m.IntegerLiteral
    @test il.value == value
    @test m.token_literal(il) == string(value)
end

function test_boolean_literal(b::m.BooleanLiteral, value::Bool)
    @test b isa m.BooleanLiteral
    @test b.value == value
    @test m.token_literal(b) == string(value)
end

function test_literal_expression(expr::m.Expression, expected)
    if expected isa Int
        test_integer_literal(expr, Int64(expected))
    elseif expected isa String
        test_identifier(expr, expected)
    elseif expected isa Bool
        test_boolean_literal(expr, expected)
    else
        error("Unexpected type for $expected.")
    end
end

function test_infix_expression(expr::m.Expression, left, operator::String, right)
    @test expr isa m.InfixExpression
    test_literal_expression(expr.left, left)

    @test expr.operator == operator
    test_literal_expression(expr.right, right)
end

function test_let_statement(ls::m.Statement, name::String)
    @test ls isa m.LetStatement
    @test ls.name.value == name
    @test m.token_literal(ls.name) == name
end

function parse_from_code!(code::String)
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    return l, p, program
end

function test_integer_object(object::m.Object, expected::Int64)
    @test object isa m.IntegerObj
    @test object.value == expected
end

function test_boolean_object(object::m.Object, expected::Bool)
    @test object isa m.BooleanObj
    @test object.value == expected
end

function evaluate_from_code!(code::String)
    _, _, program = parse_from_code!(code)
    return m.evaluate(program)
end
