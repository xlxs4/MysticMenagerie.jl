@enum TokenType begin
    ILLEGAL
    EOF
    IDENT
    INT
    STRING
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
    COLON
    LPAREN
    RPAREN
    LBRACKET
    RBRACKET
    LBRACE
    RBRACE
    FUNCTION
    LET
    TRUE
    FALSE
    NULL
    IF
    ELSE
    RETURN
end

const KEYWORDS = Base.ImmutableDict("fn" => FUNCTION,
                                    "let" => LET,
                                    "true" => TRUE,
                                    "false" => FALSE,
                                    "null" => NULL,
                                    "if" => IF,
                                    "else" => ELSE,
                                    "return" => RETURN)

struct Token
    type::TokenType
    literal::String
end

lookup_ident(ident::AbstractString) = ident ∈ keys(KEYWORDS) ? KEYWORDS[ident] : IDENT
