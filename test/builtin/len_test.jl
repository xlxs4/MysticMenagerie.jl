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
    ("len(1)", ArgumentError("argument to `len` not supported, got INTEGER")),
    ("len(\"one\", \"two\")", ArgumentError("wrong number of arguments. got 2, want 1")),
    ("len({\"a\": 1, \"b\": 2})", 2),
    ("len({})", 0),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    test_object(evaluated, expected)
end
