const _TRUE = BooleanObj(true)
const _FALSE = BooleanObj(false)
const _NULL = NullObj()

function evaluate(node::Node)
    node isa Program && return evaluate_statements(node.statements)
    node isa ExpressionStatement && return evaluate(node.expression)
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
