using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

@testset "Test type" begin for (code, expected) in [
    ("type(false)", m.BOOLEAN_OBJ),
    ("type(true)", m.BOOLEAN_OBJ),
    ("type(null)", m.NULL_OBJ),
    ("type(1)", m.INTEGER_OBJ),
    ("type(\"hello\")", m.STRING_OBJ),
    ("type([1, 2])", m.ARRAY_OBJ),
    ("type({1: 2})", m.HASH_OBJ),
    ("type(fn(x) { x })", m.FUNCTION_OBJ),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end
