@enum TokenType begin
    ILLEGAL
    EOF

    # Identifiers and literals.
    IDENT
    INT

    # Operators.
    ASSIGN
    PLUS
    MINUS
    BANG
    ASTERISK
    SLASH

    LT
    GT

    # Delimiters.
    COMMA
    SEMICOLON

    LPAREN
    RPAREN
    LBRACE
    RBRACE

    # Keywords.
    FUNCTION
    LET
    TRUE
    FALSE
    IF
    ELSE
    RETURN
end

struct Token
    type::TokenType
    literal::String
end

const KEYWORDS = Dict{String, TokenType}("fn" => FUNCTION,
                                         "let" => LET,
                                         "true" => TRUE,
                                         "false" => FALSE,
                                         "if" => IF,
                                         "else" => ELSE,
                                         "return" => RETURN)

lookup_ident(ident::AbstractString) = ident ∈ keys(KEYWORDS) ? KEYWORDS[ident] : IDENT
