@enum TokenType begin
    ILLEGAL
    EOF
    IDENT
    INT
    ASSIGN
    PLUS
    MINUS
    BANG
    ASTERISK
    SLASH
    EQ
    NOT_EQ
    LT
    GT
    COMMA
    SEMICOLON
    LPAREN
    RPAREN
    LBRACE
    RBRACE
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
