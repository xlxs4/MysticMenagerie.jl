const _TRUE = BooleanObj(true)
const _FALSE = BooleanObj(false)
const _NULL = NullObj()

is_truthy(::Object) = true
is_truthy(b::BooleanObj) = b.value
is_truthy(::NullObj) = false

evaluate(::Node, env::Environment) = _NULL
evaluate(node::Program, env::Environment) = evaluate(node.statements, env)
evaluate(node::ExpressionStatement, env::Environment) = evaluate(node.expression, env)

function evaluate(node::PrefixExpression, env::Environment)
    right = evaluate(node.right, env)
    return right isa ErrorObj ? right : evaluate_prefix_expression(node.operator, right)
end

function evaluate(node::InfixExpression, env::Environment)
    left = evaluate(node.left, env)
    left isa ErrorObj && return left

    right = evaluate(node.right, env)
    right isa ErrorObj && return right

    return evaluate_infix_expression(node.operator, left, right)
end

evaluate(node::IntegerLiteral, env::Environment) = IntegerObj(node.value)
evaluate(node::BooleanLiteral, env::Environment) = node.value ? _TRUE : _FALSE

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

function evaluate(statements::Vector{Statement}, env::Environment)
    result = _NULL
    for stmt in statements
        result = evaluate(stmt, env)
        result isa ReturnValue && return result.value
        result isa ErrorObj && return result
    end
    return result
end

function evaluate(node::BlockStatement, env::Environment)
    result = _NULL
    for stmt in node.statements
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
end

function evaluate(node::Identifier, env::Environment)
    val = get(env, node.value)
    if isnothing(val)
        return ErrorObj("identifier not found: $(node.value)")
    end
    return val
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

function evaluate_minus_operator_expression(right::Object)
    ErrorObj("unknown operator: -" * type(right))
end
evaluate_minus_operator_expression(right::IntegerObj) = IntegerObj(-right.value)

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
        return ErrorObj("unknown operator: " * type(left) * operator * type(right))
    end
end
