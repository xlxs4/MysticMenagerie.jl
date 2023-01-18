using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

@testset "Test TypeMismatch" begin for (code, expected) in [
    ("5 + true;", m.TypeMismatch("INTEGER + BOOLEAN")),
    ("5 + true; 5;", m.TypeMismatch("INTEGER + BOOLEAN")),
    ("5 + null", m.TypeMismatch("INTEGER + NULL")),
    ("5 + null; 5", m.TypeMismatch("INTEGER + NULL")),
    ("\"foo\"[1]", m.TypeMismatch("STRING")),
    ("[1, 2, 3][\"2\"]", m.TypeMismatch("STRING")),
    ("2(3)", m.TypeMismatch("not a function: INTEGER")),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test UnknownOperator" begin for (code, expected) in [
    ("-true", m.UnknownOperator("-BOOLEAN")),
    ("true + false;", m.UnknownOperator("BOOLEAN + BOOLEAN")),
    ("5; true + false; 5", m.UnknownOperator("BOOLEAN + BOOLEAN")),
    ("if (10 > 1) { true + false; }", m.UnknownOperator("BOOLEAN + BOOLEAN")),
    ("""
    if (10 > 1) {
        if (10 > 1) {
            return true + false;
        }

        return 1;
    }
    """, m.UnknownOperator("BOOLEAN + BOOLEAN")),
    ("\"Hello\" - \"World!\"", m.UnknownOperator("STRING - STRING")),
    ("-null", m.UnknownOperator("-NULL")),
    ("null + null", m.UnknownOperator("NULL + NULL")),
    ("5; null + null; 5", m.UnknownOperator("NULL + NULL")),
    ("if (10 > 1) { null + null; }", m.UnknownOperator("NULL + NULL")),
    ("""
    if (10 > 1) {
        if (10 > 1) {
            return null + null;
        }
        
        return 1;
    }
    """, m.UnknownOperator("NULL + NULL"),
     ("5 ~ 5", m.UnknownOperator("INTEGER ~ INTEGER"))),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test UnknownIdentifier" begin for (code, expected) in [
    ("foobar", m.UnknownIdentifier("foobar")),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test DivisionByZero" begin for (code, expected) in [
    ("5 / 0", m.DivisionByZero("")),
    ("[5 / 0]", m.DivisionByZero("")),
    ("{5 / 0: 2}", m.DivisionByZero("")),
    ("{2: 5 / 0}", m.DivisionByZero("")),
    ("(5 / 0) + (5 / 0)", m.DivisionByZero("")),
    ("if (5 / 0) { 2 }", m.DivisionByZero("")),
    ("(5 / 0)()", m.DivisionByZero("")),
    ("let a = fn(x) { x }; a(5 / 0)", m.DivisionByZero("")),
    ("{1: 2}[5 / 0]", m.DivisionByZero("")),
    ("if (true) { 5 / 0; 2 + 3; 4; }", m.DivisionByZero("")),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test ArgumentError" begin for (code, expected) in [
    ("fn() { 1; }(1);", ArgumentError("wrong number of arguments: got 1, want 0")),
    ("fn(a) { a; }();", ArgumentError("wrong number of arguments: got 0, want 1")),
    ("fn(a, b) { a + b; }(1);", ArgumentError("wrong number of arguments: got 1, want 2")),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test Propagation" begin for (code, expected) in [
    ("let x = a", m.UnknownIdentifier("a"))
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end
