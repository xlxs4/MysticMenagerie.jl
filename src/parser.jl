@enum ExpressionOrder begin
    LOWEST
    EQUALS
    LESSGREATER
    SUM
    PRODUCT
    PREFIX
    CALL
end

const PRECEDENCES = Dict{TokenType, ExpressionOrder}(EQ => EQUALS,
                                                     NOT_EQ => EQUALS,
                                                     LT => LESSGREATER,
                                                     GT => LESSGREATER,
                                                     PLUS => SUM,
                                                     MINUS => SUM,
                                                     SLASH => PRODUCT,
                                                     ASTERISK => PRODUCT)

mutable struct Parser
    lexer::Lexer
    errors::Vector{String}
    current_token::Token
    peek_token::Token
    prefix_parse_functions::Dict{TokenType, Function}
    infix_parse_functions::Dict{TokenType, Function}
end

register_prefix!(p::Parser, t::TokenType, fn::Function) = p.prefix_parse_functions[t] = fn
register_infix!(p::Parser, t::TokenType, fn::Function) = p.infix_parse_functions[t] = fn

function next_token!(p::Parser)
    p.current_token = p.peek_token
    p.peek_token = next_token!(p.lexer)
end

function peek_error!(p::Parser, t::TokenType)
    push!(p.errors, "expected next token to be $t, got $(p.peek_token.type) instead")
end

function expect_peek!(p::Parser, t::TokenType)
    if p.peek_token.type == t
        next_token!(p)
        return true
    else
        peek_error!(p, t)
        return false
    end
end

function current_precedence(p::Parser)
    p.current_token.type ∉ keys(PRECEDENCES) && return LOWEST
    return PRECEDENCES[p.current_token.type]
end

function peek_precedence(p::Parser)
    p.peek_token.type ∉ keys(PRECEDENCES) && return LOWEST
    return PRECEDENCES[p.peek_token.type]
end

function parse_let_statement!(p::Parser)
    token = p.current_token
    !expect_peek!(p, IDENT) && return nothing

    name = Identifier(p.current_token, p.current_token.literal)
    !expect_peek!(p, ASSIGN) && return nothing

    next_token!(p)
    value = parse_expression!(p, LOWEST)
    p.peek_token.type == SEMICOLON && next_token!(p)
    return LetStatement(token, name, value)
end

function parse_return_statement!(p::Parser)
    token = p.current_token
    next_token!(p)
    value = parse_expression!(p, LOWEST)
    while p.current_token.type != SEMICOLON
        next_token!(p)
    end

    return ReturnStatement(token, value)
end

function parse_expression!(p::Parser, precedence::ExpressionOrder)
    if p.current_token.type ∉ keys(p.prefix_parse_functions)
        push!(p.errors, "no prefix parse function for $(p.current_token.type) found")
        return nothing
    else
        prefix_function = p.prefix_parse_functions[p.current_token.type]
        left_expression = prefix_function(p)

        while p.peek_token.type != SEMICOLON && precedence < peek_precedence(p)
            p.peek_token.type ∉ keys(p.infix_parse_functions) && return left_expression

            infix_function = p.infix_parse_functions[p.peek_token.type]
            next_token!(p)
            left_expression = infix_function(p, left_expression)
        end

        return left_expression
    end
end

function parse_expression_statement!(p::Parser)
    token = p.current_token
    expression = parse_expression!(p, LOWEST)
    p.peek_token.type == SEMICOLON && next_token!(p)
    return ExpressionStatement(token, expression)
end

function parse_statement!(p::Parser)
    if p.current_token.type == LET
        return parse_let_statement!(p)
    elseif p.current_token.type == RETURN
        return parse_return_statement!(p)
    else
        return parse_expression_statement!(p)
    end
end

parse_identifier(p::Parser) = Identifier(p.current_token, p.current_token.literal)
parse_boolean(p::Parser) = Boolean(p.current_token, p.current_token.type == TRUE)

function parse_integer_literal!(p::Parser)
    try
        value = parse(Int64, p.current_token.literal)
        return IntegerLiteral(p.current_token, value)
    catch
        msg = "could not parse $(p.current_token.literal) as integer"
        push!(p.errors, msg)
        return nothing
    end
end

function parse_prefix_expression!(p::Parser)
    token = p.current_token
    operator = p.current_token.literal
    next_token!(p)
    right = parse_expression!(p, PREFIX)
    return PrefixExpression(token, operator, right)
end

function parse_infix_expression!(p::Parser, left::Expression)
    token = p.current_token
    operator = p.current_token.literal

    precedence = current_precedence(p)
    next_token!(p)
    right = parse_expression!(p, precedence)

    return InfixExpression(token, left, operator, right)
end

function parse_program!(p::Parser)
    program = Program(Statement[])
    while p.current_token.type != EOF
        stmt = parse_statement!(p)
        !isnothing(stmt) && push!(program.statements, stmt)
        next_token!(p)
    end

    return program
end

function Parser(l::Lexer)
    current_token = next_token!(l)
    peek_token = next_token!(l)
    p = Parser(l, String[], current_token, peek_token, Dict{TokenType, Function}(),
               Dict{TokenType, Function}())

    register_prefix!(p, IDENT, parse_identifier)
    register_prefix!(p, INT, parse_integer_literal!)
    register_prefix!(p, BANG, parse_prefix_expression!)
    register_prefix!(p, MINUS, parse_prefix_expression!)
    register_prefix!(p, TRUE, parse_boolean)
    register_prefix!(p, FALSE, parse_boolean)

    register_infix!(p, PLUS, parse_infix_expression!)
    register_infix!(p, MINUS, parse_infix_expression!)
    register_infix!(p, SLASH, parse_infix_expression!)
    register_infix!(p, ASTERISK, parse_infix_expression!)
    register_infix!(p, EQ, parse_infix_expression!)
    register_infix!(p, NOT_EQ, parse_infix_expression!)
    register_infix!(p, LT, parse_infix_expression!)
    register_infix!(p, GT, parse_infix_expression!)
    return p
end
