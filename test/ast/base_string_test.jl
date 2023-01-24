include("../test_helpers.jl")

using MysticMenagerie

const m = MysticMenagerie

@testset "Test Tokens Program to String" begin
    program = m.Program([
                            m.LetStatement(m.Token(m.LET, "let"),
                                           m.Identifier(m.Token(m.IDENT, "myVar"), "myVar"),
                                           m.Identifier(m.Token(m.IDENT, "anotherVar"),
                                                        "anotherVar")),
                        ])

    @test string(program) == "let myVar = anotherVar;"
end

@testset "Test Program to String" begin for (code, expected) in [
    ("""
     let a = 1;
     let b = a + 2;

     let f = if (true) {
        fn(x) {
            x + 1;
        }
     } else { 
        fn(x) {
            return x * 2;
        }
     }

     let g = if (true) {
        fn(x) { x + 1 }
     }

     let c = f(b); 

     let d = [a, b, c];
     let e = {a:b};
     let h = "hello world"
     """,
     "let a = 1;let b = (a + 2);let f = if (true) { fn(x) (x + 1) } else { fn(x) return (x * 2); };let g = if (true) { fn(x) (x + 1) } ;let c = f(b);let d = [a, b, c];let e = {a: b};let h = \"hello world\";")
]
    l = m.Lexer(code)
    p = m.Parser(l)
    program = m.parse_program!(p)
    @test string(program) == expected
end end
