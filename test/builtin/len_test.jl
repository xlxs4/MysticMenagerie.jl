include("../test_helpers.jl")

using MysticMenagerie

const m = MysticMenagerie

for (code, expected) in [
    ("len(\"\")", 0),
    ("len(\"four\")", 4),
    ("len(\"hello world\")", 11),
    ("len([])", 0),
    ("len([1, 2, 3])", 3),
    ("len([[1, 2, 3], [4, 5, 6]])", 2),
    ("len(1)", "argumentument to `len` not supported, got INTEGER"),
    ("len(\"one\", \"two\")", "wrong number of arguments. got 2, want 1"),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    test_object(evaluated, expected)
end
