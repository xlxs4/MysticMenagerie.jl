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
    elseif is_ident_letter(ch)
        return read_ident!(l)
    else
        token = Token(ILLEGAL, string(ch))
    end

    read_char!(l)
    return token
end

function read_ident!(l::Lexer)
    chars = Char[]
    while is_ident_letter(read_char(l))
        push!(chars, read_char!(l))
    end

    literal = join(chars, "")
    return Token(lookup_ident(literal), literal)
end

function skip_whitespace!(l::Lexer)
    is_valid_space(ch) = !isnothing(ch) && isspace(ch)
    while is_valid_space(read_char(l))
        read_char!(l)
    end
end

is_ident_letter(ch) = 'a' <= ch <= 'z' || 'A' <= ch <= 'Z' || ch == '_'
