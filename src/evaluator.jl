const _TRUE = BooleanObj(true)
const _FALSE = BooleanObj(false)
const _NULL = NullObj()

is_truthy(::AbstractObject) = true
is_truthy(b::BooleanObj) = b.value
is_truthy(::NullObj) = false

evaluate(::AbstractNode, env::Environment) = _NULL
evaluate(node::Program, env::Environment) = evaluate(node.statements, env)
function evaluate(node::ExpressionStatement, env::Environment)
    evaluate(node.expression, env)
end

function evaluate(node::Vector{AbstractExpression}, env::Environment)
    result = AbstractObject[]
    for expression in node
        evaluated = evaluate(expression, env)
        evaluated isa ErrorObj && return [evaluated]
        push!(result, evaluated)
    end

    return result
end

function evaluate(statements::Vector{AbstractStatement}, env::Environment)
    result = _NULL
    for statement in statements
        result = evaluate(statement, env)
        result isa ReturnValue && return result.value
        result isa ErrorObj && return result
    end

    return result
end

function evaluate(node::PrefixExpression, env::Environment)
    right = evaluate(node.right, env)
    if right isa ErrorObj
        return right
    else
        return evaluate_prefix_expression(node.operator, right)
    end
end

function evaluate_prefix_expression(operator::String, right::AbstractObject)
    if operator == "!"
        return evaluate_bang_operator_expression(right)
    elseif operator == "-"
        return evaluate_minus_operator_expression(right)
    else
        return ErrorObj(UnknownOperator(operator * type(right)))
    end
end

function evaluate_bang_operator_expression(right::AbstractObject)
    if right === _FALSE || right === _NULL
        return _TRUE
    else
        return _FALSE
    end
end

evaluate_minus_operator_expression(right::IntegerObj) = IntegerObj(-right.value)
function evaluate_minus_operator_expression(right::AbstractObject)
    return ErrorObj(UnknownOperator("-" * type(right)))
end

function evaluate(node::InfixExpression, env::Environment)
    left = evaluate(node.left, env)
    left isa ErrorObj && return left

    right = evaluate(node.right, env)
    right isa ErrorObj && return right

    return evaluate_infix_expression(node.operator, left, right)
end

function evaluate_infix_expression(operator::String, left::AbstractObject,
                                   right::AbstractObject)
    if type(left) != type(right)
        return ErrorObj(TypeMismatch(type(left) * " " * operator *
                                     " " * type(right)))
    end

    if operator == "=="
        return left == right ? _TRUE : _FALSE
    elseif operator == "!="
        return left != right ? _TRUE : _FALSE
    else
        return ErrorObj(UnknownOperator(type(left) * " " * operator *
                                        " " *
                                        type(right)))
    end
end

function evaluate_infix_expression(operator::String, left::IntegerObj,
                                   right::IntegerObj)
    if operator == "+"
        return IntegerObj(left.value + right.value)
    elseif operator == "-"
        return IntegerObj(left.value - right.value)
    elseif operator == "*"
        return IntegerObj(left.value * right.value)
    elseif operator == "/"
        right.value == 0 && return ErrorObj(DivisionByZero(""))
        return IntegerObj(left.value ÷ right.value)
    elseif operator == "<"
        return left.value < right.value ? _TRUE : _FALSE
    elseif operator == ">"
        return left.value > right.value ? _TRUE : _FALSE
    elseif operator == "=="
        return left.value == right.value ? _TRUE : _FALSE
    elseif operator == "!="
        return left.value != right.value ? _TRUE : _FALSE
    else
        return ErrorObj(UnknownOperator(type(left) * " " * operator *
                                        " " *
                                        type(right)))
    end
end

function evaluate_infix_expression(operator::String, left::StringObj,
                                   right::StringObj)
    if operator == "+"
        return StringObj(left.value * right.value)
    elseif operator == "=="
        return left.value == right.value ? _TRUE : _FALSE
    elseif operator == "!="
        return left.value != right.value ? _TRUE : _FALSE
    else
        return ErrorObj(UnknownOperator(type(left) * " " * operator *
                                        " " * type(right)))
    end
end

function evaluate(node::IfExpression, env::Environment)
    condition = evaluate(node.condition, env)
    condition isa ErrorObj && return condition

    if is_truthy(condition)
        return evaluate(node.consequence, env)
    elseif !isnothing(node.alternative)
        return evaluate(node.alternative, env)
    else
        return _NULL
    end
end

function evaluate(node::CallExpression, env::Environment)
    fn = evaluate(node.fn, env)
    fn isa ErrorObj && return fn

    arguments = evaluate(node.arguments, env)
    if length(arguments) == 1 && arguments[1] isa ErrorObj
        return arguments[1]
    end

    return apply_function(fn, arguments)
end

function apply_function(fn::AbstractObject, ::Vector{AbstractObject})
    return ErrorObj(TypeMismatch("not a function: " * type(fn)))
end

function apply_function(fn::FunctionObj, arguments::Vector{AbstractObject})
    if length(fn.params) != length(arguments)
        return ErrorObj(ArgumentError("wrong number of arguments: got $(length(arguments)), want $(length(fn.params))"))
    end

    extended_env = extend_function_environment(fn, arguments)
    evaluated = evaluate(fn.body, extended_env)
    return unwrap_return_value(evaluated)
end

function apply_function(fn::BuiltinObj, arguments::Vector{AbstractObject})
    return fn.fn(arguments...)
end

function extend_function_environment(fn::FunctionObj,
                                     arguments::Vector{AbstractObject})
    env = Environment(fn.env)
    for (parameter, argument) in zip(fn.params, arguments)
        set!(env, parameter.value, argument)
    end

    return env
end

function unwrap_return_value(object::AbstractObject)
    return object isa ReturnValue ? object.value : object
end

function evaluate(node::IndexExpression, env::Environment)
    left = evaluate(node.left, env)
    left isa ErrorObj && return left

    index = evaluate(node.index, env)
    index isa ErrorObj && return index

    return evaluate_index_expression(left, index)
end

function evaluate_index_expression(left::HashObj, key::AbstractObject)
    Base.get(left.pairs, key, _NULL)
end

function evaluate_index_expression(left::AbstractObject, ::AbstractObject)
    return ErrorObj(TypeMismatch(type(left)))
end

function evaluate_index_expression(::ArrayObj, index::AbstractObject)
    return ErrorObj(TypeMismatch(type(index)))
end

function evaluate_index_expression(left::ArrayObj, index::IntegerObj)
    index = index.value
    max_index = length(left.elements) - 1
    return 0 <= index <= max_index ? left.elements[index + 1] : _NULL
end

function evaluate(node::BlockStatement, env::Environment)
    result = _NULL
    for statement in node.statements
        result = evaluate(statement, env)
        if result isa ReturnValue || result isa ErrorObj
            return result
        end
    end

    return result
end

function evaluate(node::ReturnStatement, env::Environment)
    val = evaluate(node.return_value, env)
    return val isa ErrorObj ? val : ReturnValue(val)
end

function evaluate(node::LetStatement, env::Environment)
    val = evaluate(node.value, env)
    if val isa ErrorObj
        return val
    end

    set!(env, node.name.value, val)
    return val
end

function evaluate(node::Identifier, env::Environment)
    val = get(env, node.value)
    !isnothing(val) && return val

    node.value ∉ keys(BUILTINS) &&
        return ErrorObj(UnknownIdentifier(node.value))

    return BUILTINS[node.value]
end

evaluate(node::IntegerLiteral, env::Environment) = IntegerObj(node.value)
evaluate(node::BooleanLiteral, env::Environment) = node.value ? _TRUE : _FALSE
evaluate(node::StringLiteral, env::Environment) = StringObj(node.value)
function evaluate(node::FunctionLiteral, env::Environment)
    return FunctionObj(node.params, node.body, env)
end

function evaluate(node::ArrayLiteral, env::Environment)
    elements = evaluate(node.elements, env)
    if length(elements) == 1 && elements[1] isa ErrorObj
        return elements[1]
    end

    return ArrayObj(elements)
end

function evaluate(node::HashLiteral, env::Environment)
    pairs = Dict{AbstractObject, AbstractObject}()

    for (key_node, value_node) in node.pairs
        key = evaluate(key_node, env)
        key isa ErrorObj && return key

        value = evaluate(value_node, env)
        value isa ErrorObj && return value

        pairs[key] = value
    end

    return HashObj(pairs)
end

AbstractNode(::AbstractObject) = NullLiteral(Token(NULL, "null"))
function AbstractNode(object::IntegerObj)
    return IntegerLiteral(Token(INT, string(object.value)), object.value)
end

AbstractNode(object::StringObj) = StringLiteral(Token(STRING, object.value), object.value)
function AbstractNode(object::BooleanObj)
    return BooleanLiteral(Token(object.value ? TRUE : FALSE, string(object.value)),
                          object.value)
end

function AbstractNode(object::ArrayObj)
    return ArrayLiteral(Token(LBRACKET, "["), map(AbstractNode, object.elements))
end

function Node(object::FunctionObj)
    return FunctionLiteral(Token(FUNCTION, "fn"), object.parameters, object.body)
end

function AbstractNode(object::HashObj)
    return HashLiteral(Token(LBRACE, "{"),
                       Dict(AbstractNode(key) => AbstractNode(value)
                            for (key, value) in collect(object.pairs)))
end
