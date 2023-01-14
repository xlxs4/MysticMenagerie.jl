@testset "Test BANG operator PrefixExpression" begin for (code, expected) in [
    ("!true", false),
    ("!false", true),
    ("!5", false),
    ("!!true", true),
    ("!!false", false),
    ("!!5", true),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end

@testset "Test String concatenation" begin for (code, expected) in [
    ("\"Hello\" + \" \" + \"World!\"", "Hello World!")
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.StringObj

    test_object(evaluated, expected)
end end

@testset "Test IfExpression" begin for (code, expected) in [
    ("if (true) { 10 }", 10),
    ("if (false) { 10 }", nothing),
    ("if (1) { 10 }", 10),
    ("if (1 < 2) { 10 }", 10),
    ("if (1 > 2) { 10 }", nothing),
    ("if (1 < 2) { 10 } else { 20 }", 10),
    ("if (1 > 2) { 10 } else { 20 }", 20),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end

@testset "Test CallExpression" begin for (code, expected) in [
    ("let identity = fn(x) { x; }; identity(5);", 5),
    ("let identity = fn(x) { return x; }; identity(5);", 5),
    ("let double = fn(x) { x * 2; }; double(5);", 10),
    ("let add = fn(x, y) { x + y; }; add(5, 5);", 10),
    ("let add = fn(x, y) { x + y; }; add(5 + 5, add(5, 5));", 20),
    ("fn(x) { x; }(5)", 5),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end

@testset "Test Closures" begin for (code, expected) in [
    ("""
    let newAdder = fn(x) {
        fn(y) { x + y };
    };

    let addTwo = newAdder(2);
    addTwo(2);
    """, 4)
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end

@testset "Test Higher-Order Functions" begin for (code, expected) in [
    ("""
    let sub = fn(x, y) { x - y };
    let applyFunc = fn(x, y, func) { func(x, y) };

    applyFunc(10, 2, sub);
    """, 8)
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.Object

    test_object(evaluated, expected)
end end
