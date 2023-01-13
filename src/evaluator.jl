const _TRUE = BooleanObj(true)
const _FALSE = BooleanObj(false)
const _NULL = NullObj()

function evaluate(node::Node)
    node isa Program && return evaluate_statements(node.statements)
    node isa ExpressionStatement && return evaluate(node.expression)
    if node isa PrefixExpression
        right = evaluate(node.right)
        return evaluate_prefix_expression(node.operator, right)
    end
    node isa IntegerLiteral && return IntegerObj(node.value)
    node isa BooleanLiteral && return node.value ? _TRUE : _FALSE
    return nothing
end

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
