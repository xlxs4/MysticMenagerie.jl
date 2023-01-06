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
