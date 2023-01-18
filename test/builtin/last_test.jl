include("../test_helpers.jl")

using MysticMenagerie

const m = MysticMenagerie

@testset "Test last" begin for (code, expected) in [
    ("last([1, 2, 3])", 3),
    ("last([])", nothing),
    ("last(\"hello\")", "o"),
    ("last(\"\")", nothing),
    ("last(1)", ArgumentError("argument to `last` not supported, got INTEGER")),
    ("last([1, 2], [3, 4])", ArgumentError("wrong number of arguments. got 2, want 1")),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end
