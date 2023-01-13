const _TRUE = BooleanObj(true)
const _FALSE = BooleanObj(false)
const _NULL = NullObj()

evaluate(::Node) = nothing
evaluate(node::Program) = evaluate_statements(node.statements)
evaluate(node::ExpressionStatement) = evaluate(node.expression)

function evaluate(node::PrefixExpression)
    right = evaluate(node.right)
    return evaluate_prefix_expression(node.operator, right)
end

function evaluate(node::InfixExpression)
    left = evaluate(node.left)
    right = evaluate(node.right)
    return evaluate_infix_expression(node.operator, left, right)
end

evaluate(node::IntegerLiteral) = IntegerObj(node.value)
evaluate(node::BooleanLiteral) = node.value ? _TRUE : _FALSE

function evaluate_statements(statements::Vector{Statement})
    result = nothing
    for stmt in statements
        result = evaluate(stmt)
    end
    return result
end

function evaluate_prefix_expression(operator::String, right::Object)
    if operator == "!"
        return evaluate_bang_operator_expression(right)
    elseif operator == "-"
        return evaluate_minus_operator_expression(right)
    else
        return _NULL
    end
end

function evaluate_bang_operator_expression(right::Object)
    if right === _FALSE || right === _NULL
        return _TRUE
    else
        return _FALSE
    end
end

evaluate_minus_operator_expression(::Object) = _NULL
evaluate_minus_operator_expression(right::IntegerObj) = IntegerObj(-right.value)

function evaluate_infix_expression(operator::String, left::Object, right::Object)
    if operator == "=="
        return left == right ? _TRUE : _FALSE
    elseif operator == "!="
        return left != right ? _TRUE : _FALSE
    else
        return _NULL
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
        right.value == 0 && return _NULL
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
        return _NULL
    end
end
