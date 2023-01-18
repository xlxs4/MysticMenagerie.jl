include("../test_helpers.jl")

using MysticMenagerie

const m = MysticMenagerie

@testset "Test type" begin for (code, expected) in [
    ("type(\"foo\")", "STRING"),
    ("type(1, 2)", ArgumentError("wrong number of arguments. got 2, want 1")),
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end
