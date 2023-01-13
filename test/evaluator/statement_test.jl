@testset "Test ReturnStatement" begin for (code, expected) in [
    ("return 10;", 10),
    ("return 10; 9;", 10),
    ("return 2 * 5; 9;", 10),
    ("9; return 2 * 5; 9;", 10),
    ("""
    if (10 > 1) {
        if (10 > 1) {
            return 10;
        }

        return 1;
    }
    """, 10),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end
