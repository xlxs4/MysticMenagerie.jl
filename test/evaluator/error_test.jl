using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

for (code, expected) in [
    ("5 + true;", m.TypeMismatch("INTEGER + BOOLEAN")),
    ("5 + true; 5;", m.TypeMismatch("INTEGER + BOOLEAN")),
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
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.ErrorObj

    test_object(evaluated, expected)
end

for (code, expected) in [
    ("foobar", m.UnknownIdentifier("foobar")),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.ErrorObj

    test_object(evaluated, expected)
end
