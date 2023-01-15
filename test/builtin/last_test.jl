@testset "Test `last` Builtin" begin for (code, expected) in [
    ("last([1, 2, 3])", 3),
    ("last([])", nothing),
    ("last(\"hello\")", "o"),
    ("last(\"\")", nothing),
    ("last(1)", "argument to `last` not supported, got INTEGER"),
    ("last([1, 2], [3, 4])", "wrong number of arguments. got 2, want 1"),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end
