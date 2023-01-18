using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

@testset "Test IntegerLiteral" begin for (code, expected) in [
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
    test_object(evaluated, expected)
end end

@testset "Test BooleanLiteral" begin for (code, expected) in [
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
    ("\"a\" == \"a\"", true),
    ("\"a\" == \"b\"", false),
    ("\"b\" == \"a\"", false),
    ("\"b\" == \"b\"", true),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test StringLiteral" begin for (code, expected) in [
    ("\"Hello world!\"", "Hello world!")
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test ArrayLiteral" begin for (code, expected) in [
    ("[]", []),
    ("[1, 2, 3]", [1, 2, 3]),
    ("[1, 2 * 2, 3 + 3]", [1, 4, 6]),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test ArrayLiteral Indexing" begin for (code, expected) in [
    ("[1, 2, 3][0]", 1),
    ("[1, 2, 3][1]", 2),
    ("[1, 2, 3][2]", 3),
    ("let i = 0; [1][i]", 1),
    ("[1, 2, 3][1 + 1]", 3),
    ("let myArray = [1, 2, 3]; myArray[2]", 3),
    ("let myArray = [1, 2, 3]; myArray[0] + myArray[1] + myArray[2]", 6),
    ("let myArray = [1, 2, 3]; let i = myArray[0]; myArray[i]", 2),
    ("[1, 2, 3][3]", nothing),
    ("[1, 2, 3][-1]", nothing),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test HashLiteral" begin for (code, expected) in [
    ("""{"foo": "bar", true: false}""", Dict("foo" => "bar", true => false)),
    ("{1: 2, 1: 3, 1: 4}", Dict(1 => 4)),
    ("""{null: [], [2]: null, {3: 5}: {"1": 2}}""",
     Dict(nothing => [], [2] => nothing, Dict(3 => 5) => Dict("1" => 2))),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end

@testset "Test HashLiteral Indexing" begin for (code, expected) in [
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
    test_object(evaluated, expected)
end end

for (code, expected_parameter, expected_body) in [
    ("fn(x) { x + 2; };", "x", "(x + 2)")
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected_parameter, expected_body)
end
