include("../test_helpers.jl")

using MysticMenagerie

const m = MysticMenagerie

@testset "Test push" begin for (code, expected) in [
    ("push([], 2)[0]", 2),
    ("push([1], 2)[0]", 1),
    ("push([1], 2)[1]", 2),
    ("push({2: 3}, 4, 5)[4]", 5),
    ("push(1)", ArgumentError("wrong number of arguments. got 1, want 2 or 3")),
    ("push(1, 2)", ArgumentError("argument to `push` must be ARRAY, got INTEGER")),
    ("push(1, 2, 3)", ArgumentError("argument to `push` must be HASH, got INTEGER")),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end
