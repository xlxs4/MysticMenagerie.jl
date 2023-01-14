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
    ("""
    let f = fn(x) {
        return x;
        x + 10;
    };
    f(10);
    """, 10),
    ("""
    let f = fn(x) {
        let result = x + 10;
        return result;
        return 10;
    };
    f(10);
    """, 20),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end

@testset "Test LetStatement" begin for (code, expected) in [
    ("let a = 5; a;", 5),
    ("let a = 5 * 5; a;", 25),
    ("let a = 5; let b = a; b;", 5),
    ("let a = 5; let b = a; let c = a + b + 5; c;", 15),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end
