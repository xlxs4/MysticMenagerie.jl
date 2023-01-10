mutable struct Parser
    lexer::Lexer
    current_token::Token
    peek_token::Token
    errors::Vector{String}
end

function Parser(l::Lexer)
    current_token = next_token!(l)
    peek_token = next_token!(l)
    return Parser(l, current_token, peek_token, String[])
end

function peek_error!(p::Parser, t::TokenType)
    push!(p.errors, "expected next token to be $t, got $(p.peek_token.type) instead")
end

function next_token!(p::Parser)
    p.current_token = p.peek_token
    p.peek_token = next_token!(p.lexer)
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

function parse_let_statement!(p::Parser)
    token = p.current_token
    !expect_peek!(p, IDENT) && return nothing

    name = Identifier(p.current_token, p.current_token.literal)
    !expect_peek!(p, ASSIGN) && return nothing

    while p.current_token.type != SEMICOLON
        next_token!(p)
    end
    return LetStatement(token, name, value)
end

function parse_return_statement!(p::Parser)
    token = p.current_token
    next_token!(p)

    while p.current_token.type != SEMICOLON
        next_token!(p)
    end
    return ReturnStatement(token, name, value)
end

function parse_statement!(p::Parser)
    if p.current_token.type == LET
        return parse_let_statement!(p)
    elseif p.current_token.type == RETURN
        return parse_return_statement!(p)
    else
        return nothing
    end
end

function parse_program(p::Parser)
    program = Program(Statement[])
    while p.current_token.type != EOF
        stmt = parse_statement!(p)
        !isnothing(stmt) && push!(program.statements, stmt)
        next_token!(p)
    end
end
