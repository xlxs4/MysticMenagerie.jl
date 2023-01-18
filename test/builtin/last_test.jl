include("../test_helpers.jl")

using MysticMenagerie

const m = MysticMenagerie

for (code, expected) in [
    ("last([1, 2, 3])", 3),
    ("last([])", nothing),
    ("last(\"hello\")", "o"),
    ("last(\"\")", nothing),
    ("last(1)", "argumentument to `last` not supported, got INTEGER"),
    ("last([1, 2], [3, 4])", "wrong number of arguments. got 2, want 1"),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    test_object(evaluated, expected)
end
