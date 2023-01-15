@testset "Test `rest` Builtin" begin for (code, expected) in [
    ("rest([1, 2, 3])", [2, 3]),
    ("rest([1])", []),
    ("rest([])", nothing),
    ("rest(\"hello\")", "ello"),
    ("rest(\"\")", ""),
    ("rest(\"\")", nothing),
    ("rest(1)", "argument to `rest` not supported, got INTEGER"),
    ("rest([1, 2], [3, 4])", "wrong number of arguments. got 2, want 1"),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end
