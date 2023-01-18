using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

for (code, expected) in [
    ("5 + true;", "type mismatch: INTEGER + BOOLEAN"),
    ("5 + true; 5;", "type mismatch: INTEGER + BOOLEAN"),
    ("-true", "unknown operator: -BOOLEAN"),
    ("true + false;", "unknown operator: BOOLEAN + BOOLEAN"),
    ("5; true + false; 5", "unknown operator: BOOLEAN + BOOLEAN"),
    ("if (10 > 1) { true + false; }", "unknown operator: BOOLEAN + BOOLEAN"),
    ("""
    if (10 > 1) {
        if (10 > 1) {
            return true + false;
        }

        return 1;
    }
    """, "unknown operator: BOOLEAN + BOOLEAN"),
    ("\"Hello\" - \"World!\"", "unknown operator: STRING - STRING"),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    test_object(evaluated, expected)
end

for (code, expected) in [
    ("foobar", "identifier not found: foobar"),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    test_object(evaluated, expected)
end
