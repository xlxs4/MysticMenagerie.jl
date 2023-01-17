abstract type Node end
abstract type Expression <: Node end
abstract type Statement <: Node end

token_literal(node::Node) = node.token.literal
Base.string(node::Node) = node.token.literal
Base.show(io::IO, node::Node) = print(io, string(node))

struct Program <: Node
    stmts::Vector{Statement}
end

token_literal(p::Program) = !isempty(p.stmts) ? token_literal(p.stmts[1]) : ""
Base.string(p::Program) = join(map(string, p.stmts))
Base.show(io::IO, p::Program) = print(io, string(p))

struct Identifier <: Expression
    token::Token
    value::String
end

Base.string(id::Identifier) = id.value

struct ExpressionStatement{T <: Expression} <: Statement
    token::Token
    expr::T
end

Base.string(es::ExpressionStatement) = string(es.expr)

struct LetStatement{T <: Expression} <: Statement
    token::Token
    name::Identifier
    value::T
end

function Base.string(ls::LetStatement)
    return ls.token.literal * " " * string(ls.name) * " = " * string(ls.value) * ";"
end

struct ReturnStatement{T <: Expression} <: Statement
    token::Token
    return_value::T
end

Base.string(rs::ReturnStatement) = token_literal(rs) * " " * string(rs.return_value) * ";"

struct BlockStatement <: Statement
    token::Token
    stmts::Vector{Statement}
end

Base.string(bs::BlockStatement) = join(map(string, bs.stmts))

struct IntegerLiteral <: Expression
    token::Token
    value::Int64
end

struct BooleanLiteral <: Expression
    token::Token
    value::Bool
end

struct StringLiteral <: Expression
    token::Token
    value::String
end

Base.string(s::StringLiteral) = "\"" * string(s.value) * "\""

struct FunctionLiteral <: Expression
    token::Token
    params::Vector{Identifier}
    body::BlockStatement
end

function Base.string(fl::FunctionLiteral)
    return fl.token.literal * "(" * join(map(string, fl.params), ", ") * ") " *
           string(fl.body)
end

struct ArrayLiteral <: Expression
    token::Token
    elements::Vector{Expression}
end

function Base.string(al::ArrayLiteral)
    return "[" * join(map(string, al.elements), ", ") * "]"
end

struct HashLiteral <: Expression
    token::Token
    pairs::Dict{Expression, Expression}
end

function Base.string(hl::HashLiteral)
    return "{" *
           join(map(x -> string(x[1]) * ":" * string(x[2]), collect(hl.pairs)), ", ") * "}"
end

struct PrefixExpression{T <: Expression} <: Expression
    token::Token
    operator::String
    right::T
end

Base.string(pe::PrefixExpression) = "(" * pe.operator * string(pe.right) * ")"

struct InfixExpression{T <: Expression, N <: Expression} <: Expression
    token::Token
    left::T
    operator::String
    right::N
end

function Base.string(ie::InfixExpression)
    return "(" * string(ie.left) * " " * ie.operator * " " * string(ie.right) * ")"
end

struct IfExpression{T <: Expression} <: Expression
    token::Token
    condition::T
    consequence::BlockStatement
    alternative::Optional{BlockStatement}
end

function Base.string(ie::IfExpression)
    left = "if (" * string(ie.condition) * ") { " * string(ie.consequence) * " } "
    return isnothing(ie.alternative) ? left :
           (left * "else { " * string(ie.alternative) * " }")
end

struct CallExpression{T <: Expression} <: Expression
    token::Token
    fn::T
    args::Vector{Expression}
end

function Base.string(ce::CallExpression)
    return string(ce.fn) * "(" * join(map(string, ce.args), ", ") * ")"
end

struct IndexExpression{T <: Expression, N <: Expression} <: Expression
    token::Token
    left::T
    index::N
end

function Base.string(ie::IndexExpression)
    return "(" * string(ie.left) * "[" * string(ie.index) * "])"
end
