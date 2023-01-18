using MysticMenagerie

const m = MysticMenagerie

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

function test_identifier(id::m.AbstractExpression, value::String)
    @test id isa m.Identifier
    @test id.value == value
    @test m.token_literal(id) == value
end

function test_integer_literal(il::m.AbstractExpression, value::Int)
    @test il isa m.IntegerLiteral
    @test il.value == value
    @test m.token_literal(il) == string(value)
end

function test_boolean_literal(b::m.BooleanLiteral, value::Bool)
    @test b isa m.BooleanLiteral
    @test b.value == value
    @test m.token_literal(b) == string(value)
end

function test_literal_expression(::m.AbstractExpression, expected)
    error("Unexpected type for $expected.")
end

function test_literal_expression(expression::m.AbstractExpression, expected::Int)
    test_integer_literal(expression, Int(expected))
end

function test_literal_expression(expression::m.AbstractExpression, expected::String)
    test_identifier(expression, expected)
end

function test_literal_expression(expression::m.AbstractExpression, expected::Bool)
    test_boolean_literal(expression, expected)
end

function test_infix_expression(expression::m.AbstractExpression, left,
                               operator::String, right)
    @test expression isa m.InfixExpression
    test_literal_expression(expression.left, left)

    @test expression.operator == operator
    test_literal_expression(expression.right, right)
end

function test_let_statement(ls::m.AbstractStatement, name::String)
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

test_object(object::m.AbstractObject, ::Nothing) = @test object === m._NULL
function test_object(object::m.AbstractObject, expected::Int)
    @test object isa m.IntegerObj
    @test object.value == expected
end

function test_object(object::m.AbstractObject, expected::Bool)
    @test object isa m.BooleanObj
    @test object.value == expected
end

test_object(object::m.AbstractObject, expected::String) = @test object.message == expected
test_object(::m.NullObj, expected::String) = @test expected == ""
test_object(object::m.StringObj, expected::String) = @test object.value == expected

function test_object(object::m.FunctionObj, expected_parameter::String,
                     expected_body::String)
    @test length(object.params) == 1
    @test string(object.params[1]) == expected_parameter
    @test string(object.body) == expected_body
end

function test_object(object::m.ArrayObj, expected::Vector)
    @test length(object.elements) == length(expected)

    for (obj, exp) in zip(object.elements, expected)
        test_object(obj, exp)
    end
end

function test_object(object::m.HashObj, expected::Dict)
    @test length(object.pairs) == length(expected)

    for (k, v) in collect(expected)
        key = m.AbstractObject(k)
        test_object(get(object.pairs, key, nothing), v)
    end
end

function evaluate_from_code!(code::String)
    _, _, program = parse_from_code!(code)
    env = m.Environment()
    return m.evaluate(program, env)
end
