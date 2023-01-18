include("../test_helpers.jl")

using MysticMenagerie

const m = MysticMenagerie

@testset "Test reduce Implementation" begin for (code, expected) in [
    ("""
    let reduce = fn(f, arr, initial) {
        let iter = fn(arr, result) {
            if (len(arr) == 0) {
                result
            } else {
                iter(rest(arr), f(result, first(arr)))
            }
        }

        iter(arr, initial)
    }

    let sum = fn(arr) {
        reduce(fn(initial, el) { initial + el }, arr, 0)
    }

    sum([1, 2, 3, 4, 5])
    """, 15)
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end
