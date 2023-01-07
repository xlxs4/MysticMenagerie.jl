mutable struct Lexer
    input::String
    next::Optional{Tuple{Char, Int}}
end

Lexer(input::String) = Lexer(input, iterate(input))

function read_char(l::Lexer)
    isnothing(l.next) && return
    ch, _ = l.next
    return ch
end

function read_char!(l::Lexer)
    isnothing(l.next) && return
    ch, state = l.next
    l.next = iterate(l.input, state)
    return ch
end

function peek_char(l::Lexer)
    isnothing(l.next) && return
    _, state = l.next
    ch, _ = iterate(l.input, state)
    return ch
end

function next_token!(l::Lexer)
    skip_whitespace!(l)
    ch = read_char(l)
    if ch == '='
        if peek_char(l) == '='
            read_char!(l)
            token = Token(EQ, "==")
        else
            token = Token(ASSIGN, "=")
        end
    elseif ch == ';'
        token = Token(SEMICOLON, ";")
    elseif ch == '('
        token = Token(LPAREN, "(")
    elseif ch == ')'
        token = Token(RPAREN, ")")
    elseif ch == ','
        token = Token(COMMA, ",")
    elseif ch == '+'
        token = Token(PLUS, "+")
    elseif ch == '-'
        token = Token(MINUS, "-")
    elseif ch == '!'
        if peek_char(l) == '='
            read_char!(l)
            token = Token(NOT_EQ, "!=")
        else
            token = Token(BANG, "!")
        end
    elseif ch == '/'
        token = Token(SLASH, "/")
    elseif ch == '*'
        token = Token(ASTERISK, "*")
    elseif ch == '<'
        token = Token(LT, "<")
    elseif ch == '>'
        token = Token(GT, ">")
    elseif ch == '{'
        token = Token(LBRACE, "{")
    elseif ch == '}'
        token = Token(RBRACE, "}")
    elseif isnothing(ch)
        token = Token(EOF, "")
    elseif is_ident_letter(ch)
        return read_ident!(l)
    elseif is_valid_digit(ch)
        return read_number!(l)
    else
        token = Token(ILLEGAL, string(ch))
    end

    read_char!(l)
    return token
end

function skip_whitespace!(l::Lexer)
    is_valid_space(ch) = !isnothing(ch) && isspace(ch)
    while is_valid_space(read_char(l))
        read_char!(l)
    end
end

function read_literal!(l::Lexer, f::Function)
    chars = Char[]
    while f(read_char(l))
        push!(chars, read_char!(l))
    end

    return join(chars, "")
end

function read_ident!(l::Lexer)
    literal = read_literal!(l, is_ident_letter)
    return Token(lookup_ident(literal), literal)
end

function read_number!(l::Lexer)
    literal = read_literal!(l, is_valid_digit)
    return Token(INT, literal)
end

is_ident_letter(ch) = !isnothing(ch) && ('a' <= ch <= 'z' || 'A' <= ch <= 'Z' || ch == '_')
is_valid_digit(ch) = !isnothing(ch) && isdigit(ch)
