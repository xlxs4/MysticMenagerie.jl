include("../test_helpers.jl")

using MysticMenagerie

const m = MysticMenagerie

@testset "Test map Implementation" begin for (code, expected) in [
    ("""
    let map = fn(f, arr) {
        let iter = fn(arr, accumulated) {
            if (len(arr) == 0) {
                accumulated
            } else {
                iter(rest(arr), push(accumulated, f(first(arr))))
            }
        }

        iter(arr, [])
    }

    let xs = [1, 2, 3, 4]
    let double = fn(x) { x * 2 }

    map(double, xs)[3]
    """, 8)
]
    evaluated = evaluate_from_code!(code)
    test_object(evaluated, expected)
end end
