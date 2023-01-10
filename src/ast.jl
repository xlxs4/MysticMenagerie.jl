abstract type Node end
abstract type Expression <: Node end
abstract type Statement <: Node end

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

struct Identifier <: Expression
    token::Token
    value::String
end

expression_node(::Identifier) = nothing
token_literal(id::Identifier) = id.token.literal

struct LetStatement{T} <: Statement where {T <: Expression}
    token::Token
    name::Identifier
    value::T
end

statement_node(::LetStatement) = nothing
token_literal(ls::LetStatement) = ls.token.literal

struct ReturnStatement{T} <: Statement where {T <: Expression}
    token::Token
    value::T
end

statement_node(::ReturnStatement) = nothing
token_literal(rs::ReturnStatement) = rs.token.literal
