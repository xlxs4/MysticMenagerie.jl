@enum TokenType begin
    ILLEGAL
    EOF

    # Identifiers and literals.
    IDENT
    INT

    # Operators.
    ASSIGN
    PLUS

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
end

struct Token
    type::TokenType
    literal::String
end