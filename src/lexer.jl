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
    ch = read_char(l)
    if ch == '='
        token = Token(ASSIGN, "=")
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
    elseif ch == '{'
        token = Token(LBRACE, "{")
    elseif ch == '}'
        token = Token(RBRACE, "}")
    elseif isnothing(ch)
        token = Token(EOF, "")
    else
        token = Token(ILLEGAL, string(ch))
    end

    read_char!(l)
    return token
end
