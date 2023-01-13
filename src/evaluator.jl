const _TRUE = BooleanObj(true)
const _FALSE = BooleanObj(false)
const _NULL = NullObj()

is_truthy(::Object) = true
is_truthy(b::BooleanObj) = b.value
is_truthy(::NullObj) = false

evaluate(::Node) = nothing
evaluate(node::Program) = evaluate(node.statements)
evaluate(node::ExpressionStatement) = evaluate(node.expression)

function evaluate(node::PrefixExpression)
    right = evaluate(node.right)
    return right isa ErrorObj ? right : evaluate_prefix_expression(node.operator, right)
end

function evaluate(node::InfixExpression)
    left = evaluate(node.left)
    left isa ErrorObj && return left

    right = evaluate(node.right)
    right isa ErrorObj && return right

    return evaluate_infix_expression(node.operator, left, right)
end

evaluate(node::IntegerLiteral) = IntegerObj(node.value)
evaluate(node::BooleanLiteral) = node.value ? _TRUE : _FALSE

function evaluate(node::IfExpression)
    condition = evaluate(node.condition)
    condition isa ErrorObj && return condition

    if is_truthy(condition)
        return evaluate(node.consequence)
    elseif !isnothing(node.alternative)
        return evaluate(node.alternative)
    else
        return _NULL
    end
end

function evaluate(statements::Vector{Statement})
    result = _NULL
    for stmt in statements
        result = evaluate(stmt)
        result isa ReturnValue && return result.value
        result isa ErrorObj && return result
    end
    return result
end

function evaluate(node::BlockStatement)
    result = _NULL
    for stmt in node.statements
        result = evaluate(stmt)
        if result isa ReturnValue || result isa ErrorObj
            return result
        end
    end
    return result
end

function evaluate(node::ReturnStatement)
    val = evaluate(node.return_value)
    return val isa ErrorObj ? val : ReturnValue(val)
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
