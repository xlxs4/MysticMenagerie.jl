include("../test_helpers.jl")

using MysticMenagerie

const m = MysticMenagerie

for (code, expected) in [
    ("first([1, 2, 3])", 1),
    ("first([])", nothing),
    ("first(\"hello\")", "h"),
    ("first(\"\")", nothing),
    ("first(1)", "argumentument to `first` not supported, got INTEGER"),
    ("first([1, 2], [3, 4])", "wrong number of arguments. got 2, want 1"),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    test_object(evaluated, expected)
end
