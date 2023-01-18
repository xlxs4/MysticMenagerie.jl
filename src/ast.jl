abstract type AbstractNode end
abstract type AbstractExpression <: AbstractNode end
abstract type AbstractStatement <: AbstractNode end

token_literal(node::AbstractNode) = node.token.literal
Base.string(node::AbstractNode) = node.token.literal
Base.show(io::IO, node::AbstractNode) = print(io, string(node))

struct Program <: AbstractNode
    statements::Vector{AbstractStatement}
end

token_literal(p::Program) = !isempty(p.statements) ? token_literal(p.statements[1]) : ""
Base.string(p::Program) = join(map(string, p.statements))
Base.show(io::IO, p::Program) = print(io, string(p))

struct Identifier <: AbstractExpression
    token::Token
    value::String
end

Base.string(id::Identifier) = id.value

struct ExpressionStatement{E <: AbstractExpression} <: AbstractStatement
    token::Token
    expression::E
end

Base.string(es::ExpressionStatement) = string(es.expression)

struct LetStatement{E <: AbstractExpression} <: AbstractStatement
    token::Token
    name::Identifier
    value::E
end

function Base.string(ls::LetStatement)
    return ls.token.literal * " " * string(ls.name) * " = " * string(ls.value) * ";"
end

struct ReturnStatement{E <: AbstractExpression} <: AbstractStatement
    token::Token
    return_value::E
end

function Base.string(rs::ReturnStatement)
    token_literal(rs) * " " * string(rs.return_value) * ";"
end

struct BlockStatement <: AbstractStatement
    token::Token
    statements::Vector{AbstractStatement}
end

Base.string(bs::BlockStatement) = join(map(string, bs.statements))

struct NullLiteral <: AbstractExpression
    token::Token
end

struct IntegerLiteral <: AbstractExpression
    token::Token
    value::Int
end

struct BooleanLiteral <: AbstractExpression
    token::Token
    value::Bool
end

struct StringLiteral <: AbstractExpression
    token::Token
    value::String
end

Base.string(sl::StringLiteral) = "\"" * string(sl.value) * "\""

struct FunctionLiteral <: AbstractExpression
    token::Token
    params::Vector{Identifier}
    body::BlockStatement
end

function Base.string(fl::FunctionLiteral)
    return fl.token.literal * "(" * join(map(string, fl.params), ", ") * ") " *
           string(fl.body)
end

struct ArrayLiteral <: AbstractExpression
    token::Token
    elements::Vector{AbstractExpression}
end

function Base.string(al::ArrayLiteral)
    return "[" * join(map(string, al.elements), ", ") * "]"
end

struct HashLiteral <: AbstractExpression
    token::Token
    pairs::Dict{AbstractExpression, AbstractExpression}
end

function Base.string(hl::HashLiteral)
    return "{" *
           join(map(x -> string(x[1]) * ": " * string(x[2]), collect(hl.pairs)), ", ") * "}"
end

struct PrefixExpression{E <: AbstractExpression} <: AbstractExpression
    token::Token
    operator::String
    right::E
end

Base.string(pe::PrefixExpression) = "(" * pe.operator * string(pe.right) * ")"

struct InfixExpression{E1 <: AbstractExpression, E2 <: AbstractExpression} <:
       AbstractExpression
    token::Token
    left::E1
    operator::String
    right::E2
end

function Base.string(ie::InfixExpression)
    return "(" * string(ie.left) * " " * ie.operator * " " * string(ie.right) * ")"
end

struct IfExpression{E <: AbstractExpression} <: AbstractExpression
    token::Token
    condition::E
    consequence::BlockStatement
    alternative::Optional{BlockStatement}
end

function Base.string(ie::IfExpression)
    left = "if (" * string(ie.condition) * ") { " * string(ie.consequence) * " } "
    if isnothing(ie.alternative)
        return left
    else
        return left * "else { " * string(ie.alternative) * " }"
    end
end

struct CallExpression{E <: AbstractExpression} <: AbstractExpression
    token::Token
    fn::E
    arguments::Vector{AbstractExpression}
end

function Base.string(ce::CallExpression)
    return string(ce.fn) * "(" * join(map(string, ce.arguments), ", ") * ")"
end

struct IndexExpression{E1 <: AbstractExpression, E2 <: AbstractExpression} <:
       AbstractExpression
    token::Token
    left::E1
    index::E2
end

function Base.string(ie::IndexExpression)
    return "(" * string(ie.left) * "[" * string(ie.index) * "])"
end
