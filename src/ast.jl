abstract type Node end
abstract type Expression <: Node end
abstract type Statement <: Node end

Base.show(io::IO, node::Node) = print(io, string(node))

token_literal(::Node) = error("token_literal is not defined in the concrete type")
token_literal(::Expression) = error("token_literal is not defined in the concrete type")
token_literal(::Statement) = error("token_literal is not defined in the concrete type")

function expression_node(::Expression)
    error("expression_node is not defined in the concrete type")
end
statement_node(::Statement) = error("statement_node is not defined in the concrete type")

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

expression_node(::Identifier) = nothing
token_literal(id::Identifier) = id.token.literal
Base.string(id::Identifier) = id.value

struct IntegerLiteral <: Expression
    token::Token
    value::Int64
end

expression_node(::IntegerLiteral) = nothing
token_literal(il::IntegerLiteral) = il.token.literal
Base.string(il::IntegerLiteral) = token_literal(il)

struct BooleanLiteral <: Expression
    token::Token
    value::Bool
end

expression_node(::BooleanLiteral) = nothing
token_literal(b::BooleanLiteral) = b.token.literal
Base.string(b::BooleanLiteral) = token_literal(b)

struct StringLiteral <: Expression
    token::Token
    value::String
end

expression_node(::StringLiteral) = nothing
token_literal(s::StringLiteral) = s.token.literal
Base.string(s::StringLiteral) = "\"" * string(s.value) * "\""

struct PrefixExpression{T <: Expression} <: Expression
    token::Token
    operator::String
    right::T
end

expression_node(::PrefixExpression) = nothing
token_literal(pe::PrefixExpression) = pe.token.literal
Base.string(pe::PrefixExpression) = "(" * pe.operator * string(pe.right) * ")"

struct InfixExpression{T <: Expression, N <: Expression} <: Expression
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

struct BlockStatement <: Statement
    token::Token
    statements::Vector{Statement}
end

statement_node(::BlockStatement) = nothing
token_literal(bs::BlockStatement) = bs.token.literal
Base.string(bs::BlockStatement) = join(map(string, bs.statements))

struct IfExpression{T <: Expression} <: Expression
    token::Token
    condition::T
    consequence::BlockStatement
    alternative::Optional{BlockStatement}
end

expression_node(::IfExpression) = nothing
token_literal(ie::IfExpression) = ie.token.literal
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

expression_node(::FunctionLiteral) = nothing
token_literal(fl::FunctionLiteral) = fl.token.literal
function Base.string(fl::FunctionLiteral)
    fl.token.literal * "(" * join(map(string, fl.parameters), ", ") * ") " * string(fl.body)
end

struct CallExpression{T <: Expression} <: Expression
    token::Token
    fn::T
    arguments::Vector{Expression}
end

expression_node(::CallExpression) = nothing
token_literal(ce::CallExpression) = ce.token.literal
function Base.string(ce::CallExpression)
    string(ce.fn) * "(" * join(map(string, ce.arguments), ", ") * ")"
end

struct LetStatement{T <: Expression} <: Statement
    token::Token
    name::Identifier
    value::T
end

statement_node(::LetStatement) = nothing
token_literal(ls::LetStatement) = ls.token.literal
function Base.string(ls::LetStatement)
    ls.token.literal * " " * string(ls.name) * " = " * string(ls.value) * ";"
end

struct ReturnStatement{T <: Expression} <: Statement
    token::Token
    return_value::T
end

statement_node(::ReturnStatement) = nothing
token_literal(rs::ReturnStatement) = rs.token.literal
Base.string(rs::ReturnStatement) = token_literal(rs) * " " * string(rs.return_value) * ";"

struct ExpressionStatement{T <: Expression} <: Statement
    token::Token
    expression::T
end

statement_node(::ExpressionStatement) = nothing
token_literal(es::ExpressionStatement) = es.token.literal
Base.string(es::ExpressionStatement) = string(es.expression)
