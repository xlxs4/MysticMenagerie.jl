@testset "Test `push` Builtin" begin for (code, expected) in [
    ("push([], 2)[0]", 2),
    ("push([1], 2)[0]", 1),
    ("push([1], 2)[1]", 2),
    ("push(1)", "wrong number of arguments. got 1, want 2"),
    ("push(1, 2)", "argument to `push` must be ARRAY, got INTEGER"),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end
