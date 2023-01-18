using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

for (code, expected) in [
    ("5", 5),
    ("10", 10),
    ("-5", -5),
    ("-10", -10),
    ("5 + 5 + 5 + 5 - 10", 10),
    ("2 * 2 * 2 * 2 * 2", 32),
    ("-50 + 100 + -50", 0),
    ("5 * 2 + 10", 20),
    ("5 + 2 * 10", 25),
    ("20 + 2 * -10", 0),
    ("50 / 2 * 2 + 10", 60),
    ("2 * (5 + 10)", 30),
    ("3 * 3 * 3 + 10", 37),
    ("3 * (3 * 3) + 10", 37),
    ("(5 + 10 * 2 + 15 / 3) * 2 + -10", 50),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    test_object(evaluated, expected)
end

for (code, expected) in [
    ("true", true),
    ("false", false),
    ("1 < 2", true),
    ("1 > 2", false),
    ("1 < 1", false),
    ("1 > 1", false),
    ("1 == 1", true),
    ("1 != 1", false),
    ("1 == 2", false),
    ("1 != 2", true),
    ("true == true", true),
    ("false == false", true),
    ("true == false", false),
    ("true != false", true),
    ("false != true", true),
    ("(1 < 2) == true", true),
    ("(1 < 2) == false", false),
    ("(1 > 2) == true", false),
    ("(1 > 2) == false", true),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    test_object(evaluated, expected)
end

for (code, expected) in [
    ("\"Hello world!\"", "Hello world!")
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.StringObj

    test_object(evaluated, expected)
end

for (code, expected_parameter, expected_body) in [
    ("fn(x) { x + 2; };", "x", "(x + 2)")
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    @test evaluated isa m.FunctionObj
    test_object(evaluated, expected_parameter, expected_body)
end

for (code) in [
    ("[1, 2 * 2, 3 + 3]")
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    @test evaluated isa m.ArrayObj
    @test length(evaluated.elements) == 3

    test_object(evaluated.elements[1], 1)
    test_object(evaluated.elements[2], 4)
    test_object(evaluated.elements[3], 6)
end

for (code, expected) in [
    ("""{"foo": "bar", true: false}""", Dict("foo" => "bar", true => false)),
    ("{1: 2, 1: 3, 1: 4}", Dict(1 => 4)),
    ("""{{3: 5}: {"1": 2}}""", Dict(Dict(3 => 5) => Dict("1" => 2))),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    @test evaluated isa m.HashObj
    test_object(evaluated, expected)
end

for (code, expected) in [
    ("""{"foo": 5}["foo"]""", 5),
    ("""{"foo": 5}["bar"]""", nothing),
    ("""let key = "foo"; {"foo": 5}[key]""", 5),
    ("""{}["foo"]""", nothing),
    ("{5: 5}[5]", 5),
    ("{true: 5}[true]", 5),
    ("{false: 5}[false]", 5),
    ("let a = [1, 2]; {a: 2}[[1, 2]]", 2),
    ("let a = {1: 2, 3: 4}; {a: 2}[{3: 4, 1: 2}]", 2),
]
    evaluated = evaluate_from_code!(code)
    @test evaluated isa m.AbstractObject

    test_object(evaluated, expected)
end
