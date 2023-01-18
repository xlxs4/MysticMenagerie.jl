using MysticMenagerie

const m = MysticMenagerie

include("../test_helpers.jl")

@testset "Test Environment" begin for (code, expected) in [
    ("""
    let first = 10;
    let second = 10;
    let third = 10;

    let ourFunction = fn(first) {
        let second = 20;

        first + second + third;
    };

    ourFunction(20) + first + second;
    """, 70)
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end
