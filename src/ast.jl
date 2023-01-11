abstract type Node end
abstract type Expression <: Node end
abstract type Statement <: Node end

Base.show(io::IO, node::Node) = print(io, string(node))

token_literal(::Node) = error("token_literal is not defined in the concrete type")
token_literal(::Expression) = error("token_literal is not defined in the concrete type")
token_literal(::Statement) = error("token literal is not defined in the concrete type")

function expression_node(::Expression)
    error("expression_node is not defined in the concrete type")
end
statement_node(::Statement) = error("statement_node is not defined in the concrete type")

struct Program
    statements::Vector{Statement}
end

token_literal(p::Program) = !isempty(p.statements) ? token_literal(p.statements[1]) : ""
Base.string(p::Program) = join(map(string, p.statements))
Base.show(io::IO, p::Program) = print(io, string(p))

struct Identifier <: Expression
    token::Token
    value::String
end

expression_node(::Identifier) = nothing
token_literal(id::Identifier) = id.token.literal
Base.string(id::Identifier) = id.value

struct IntegerLiteral <: Expression
    token::Token
    value::Int64
end

expression_node(::IntegerLiteral) = nothing
token_literal(il::IntegerLiteral) = il.token.literal
Base.string(il::IntegerLiteral) = il.token.literal

struct PrefixExpression{T} <: Expression where {T <: Expression}
    token::Token
    operator::String
    right::T
end

expression_node(::PrefixExpression) = nothing
token_literal(pe::PrefixExpression) = pe.token.literal
Base.string(pe::PrefixExpression) = "(" * pe.operator * string(pe.right) * ")"

struct InfixExpression{T, N} <: Expression where {T <: Expression, N <: Expression}
    token::Token
    left::T
    operator::String
    right::N
end

expression_node(::InfixExpression) = nothing
token_literal(ie::InfixExpression) = ie.token.literal
function Base.string(ie::InfixExpression)
    return "(" * string(ie.left) * " " * ie.operator * " " * string(ie.right) * ")"
end

struct Boolean <: Expression
    token::Token
    value::Bool
end

expression_node(::Boolean) = nothing
token_literal(b::Boolean) = b.token.literal
Base.string(b::Boolean) = b.token.literal

struct BlockStatement <: Statement
    token::Token
    statements::Vector{Statement}
end

statement_node(::BlockStatement) = nothing
token_literal(bs::BlockStatement) = bs.token.literal
Base.string(bs::BlockStatement) = join(map(string, bs.statements))

struct IfExpression{T} <: Expression where {T <: Expression}
    token::Token
    condition::T
    consequence::BlockStatement
    alternative::Optional{BlockStatement}
end

expression_node(::IfExpression) = nothing
token_literal(ie::IfExpression) = ie.token.literal
function Base.string(ie::IfExpression)
    left = "if" * string(ie.condition) * " " * string(ie.consequence)
    return isnothing(ie.alternative) ? left : left * "else " * ie.alternative
end

struct LetStatement{T} <: Statement where {T <: Expression}
    token::Token
    name::Identifier
    value::T
end

statement_node(::LetStatement) = nothing
token_literal(ls::LetStatement) = ls.token.literal
function Base.string(ls::LetStatement)
    ls.token.literal * " " * string(ls.name) * " = " * string(ls.value) * ";"
end

struct ReturnStatement{T} <: Statement where {T <: Expression}
    token::Token
    return_value::T
end

statement_node(::ReturnStatement) = nothing
token_literal(rs::ReturnStatement) = rs.token.literal
Base.string(rs::ReturnStatement) = rs.token.literal * " " * string(rs.return_value) * ";"

struct ExpressionStatement{T} <: Statement where {T <: Expression}
    token::Token
    expression::T
end

statement_node(::ExpressionStatement) = nothing
token_literal(es::ExpressionStatement) = es.token.literal
Base.string(es::ExpressionStatement) = string(es.expression)
