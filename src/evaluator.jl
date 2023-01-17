const _TRUE = BooleanObj(true)
const _FALSE = BooleanObj(false)
const _NULL = NullObj()

is_truthy(::Object) = true
is_truthy(b::BooleanObj) = b.value
is_truthy(::NullObj) = false

evaluate(::Node, env::Environment) = _NULL
evaluate(node::Program, env::Environment) = evaluate(node.stmts, env)
evaluate(node::ExpressionStatement, env::Environment) = evaluate(node.expr, env)

function evaluate(node::Vector{Expression}, env::Environment)
    result = Object[]
    for expr in node
        evaluated = evaluate(expr, env)
        evaluated isa ErrorObj && return [evaluated]

        push!(result, evaluated)
    end
    return result
end

function evaluate(stmts::Vector{Statement}, env::Environment)
    result = _NULL
    for stmt in stmts
        result = evaluate(stmt, env)
        result isa ReturnValue && return result.value
        result isa ErrorObj && return result
    end
    return result
end

function evaluate(node::PrefixExpression, env::Environment)
    right = evaluate(node.right, env)
    return right isa ErrorObj ? right : evaluate_prefix_expression(node.operator, right)
end

function evaluate_prefix_expression(operator::String, right::Object)
    if operator == "!"
        return evaluate_bang_operator_expression(right)
    elseif operator == "-"
        return evaluate_minus_operator_expression(right)
    else
        return ErrorObj("unknown operator: " * operator * type(right))
    end
end

function evaluate_bang_operator_expression(right::Object)
    if right === _FALSE || right === _NULL
        return _TRUE
    else
        return _FALSE
    end
end

evaluate_minus_operator_expression(right::IntegerObj) = IntegerObj(-right.value)

function evaluate_minus_operator_expression(right::Object)
    return ErrorObj("unknown operator: -" * type(right))
end

function evaluate(node::InfixExpression, env::Environment)
    left = evaluate(node.left, env)
    left isa ErrorObj && return left

    right = evaluate(node.right, env)
    right isa ErrorObj && return right

    return evaluate_infix_expression(node.operator, left, right)
end

function evaluate_infix_expression(operator::String, left::Object, right::Object)
    if type(left) != type(right)
        return ErrorObj("type mismatch: " * type(left) * " " * operator * " " * type(right))
    end
    if operator == "=="
        return left == right ? _TRUE : _FALSE
    elseif operator == "!="
        return left != right ? _TRUE : _FALSE
    else
        return ErrorObj("unknown operator: " * type(left) * " " * operator * " " *
                        type(right))
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
        right.value == 0 && return ErrorObj("division by zero")
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
        return ErrorObj("unknown operator: " * type(left) * " " * operator * " " *
                        type(right))
    end
end

function evaluate_infix_expression(operator::String, left::StringObj, right::StringObj)
    if operator != "+"
        return ErrorObj("unknown operator: " * type(left) * " " * operator * " " *
                        type(right))
    else
        return StringObj(left.value * right.value)
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

    args = evaluate(node.args, env)
    if length(args) == 1 && args[1] isa ErrorObj
        return args[1]
    end

    return apply_function(fn, args)
end

apply_function(fn::Object, ::Vector{Object}) = ErrorObj("not a function: " * type(fn))

function apply_function(fn::FunctionObj, args::Vector{Object})
    if length(fn.params) != length(args)
        return ErrorObj("argument error: wrong number of args: got $(length(args))")
    end
    extended_env = extend_function_environment(fn, args)
    evaluated = evaluate(fn.body, extended_env)
    return unwrap_return_value(evaluated)
end

function apply_function(fn::BuiltinObj, args::Vector{Object})
    return fn.fn(args...)
end

function extend_function_environment(fn::FunctionObj, args::Vector{Object})
    env = Environment(fn.env)
    for (parameter, argument) in zip(fn.params, args)
        set!(env, parameter.value, argument)
    end
    return env
end

function unwrap_return_value(object::Object)
    return object isa ReturnValue ? object.value : object
end

function evaluate(node::IndexExpression, env::Environment)
    left = evaluate(node.left, env)
    left isa ErrorObj && return left

    index = evaluate(node.index, env)
    index isa ErrorObj && return index

    return evaluate_index_expression(left, index)
end

evaluate_index_expression(left::HashObj, key::Object) = Base.get(left.pairs, key, _NULL)

function evaluate_index_expression(left::Object, ::Object)
    return ErrorObj("index operator not supported: " * type(left))
end

function evaluate_index_expression(::ArrayObj, index::Object)
    return ErrorObj("unsupported index type: " * type(index))
end

function evaluate_index_expression(left::ArrayObj, index::IntegerObj)
    index = index.value
    max_index = length(left.elements) - 1
    return 0 <= index <= max_index ? left.elements[index + 1] : _NULL
end

function evaluate(node::BlockStatement, env::Environment)
    result = _NULL
    for stmt in node.stmts
        result = evaluate(stmt, env)
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

    node.value ∉ keys(BUILTINS) && return ErrorObj("identifier not found: $(node.value)")

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
    pairs = Dict{Object, Object}()

    for (key_node, value_node) in node.pairs
        key = evaluate(key_node, env)
        key isa ErrorObj && return key

        value = evaluate(value_node, env)
        value isa ErrorObj && return value

        pairs[key] = value
    end

    return HashObj(pairs)
end
