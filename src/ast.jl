abstract type Node end
abstract type Expression <: Node end
abstract type Statement <: Node end

token_literal(node::Node) = node.token.literal
Base.string(node::Node) = node.token.literal
Base.show(io::IO, node::Node) = print(io, string(node))

struct Program <: Node
    statements::Vector{Statement}
end

token_literal(p::Program) = !isempty(p.statements) ? token_literal(p.statements[1]) : ""
Base.string(p::Program) = join(map(string, p.statements))
Base.show(io::IO, p::Program) = print(io, string(p))

struct Identifier <: Expression
    token::Token
    value::String
end

Base.string(id::Identifier) = id.value

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

struct BlockStatement <: Statement
    token::Token
    statements::Vector{Statement}
end

Base.string(bs::BlockStatement) = join(map(string, bs.statements))

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

struct FunctionLiteral <: Expression
    token::Token
    parameters::Vector{Identifier}
    body::BlockStatement
end

function Base.string(fl::FunctionLiteral)
    return fl.token.literal * "(" * join(map(string, fl.parameters), ", ") * ") " *
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
    "{" * join(map(x -> string(x[1]) * ":" * string(x[2]), collect(hl.pairs)), ", ") * "}"
end

struct CallExpression{T <: Expression} <: Expression
    token::Token
    fn::T
    arguments::Vector{Expression}
end

function Base.string(ce::CallExpression)
    return string(ce.fn) * "(" * join(map(string, ce.arguments), ", ") * ")"
end

struct IndexExpression{T <: Expression, N <: Expression} <: Expression
    token::Token
    left::T
    index::N
end

function Base.string(ie::IndexExpression)
    return "(" * string(ie.left) * "[" * string(ie.index) * "])"
end

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

struct ExpressionStatement{T <: Expression} <: Statement
    token::Token
    expression::T
end

Base.string(es::ExpressionStatement) = string(es.expression)
