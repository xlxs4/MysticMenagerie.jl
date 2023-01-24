include("../test_helpers.jl")

using MysticMenagerie
using Suppressor: @capture_out

const m = MysticMenagerie

@testset "Test puts" begin for (code, expected) in [
    ("puts(\"Hello world!\")", "Hello world!\n"),
    ("puts(\"Hello\", \"world!\")", "Hello\nworld!\n"),
    ("puts(1, [1, 2], [1, 2][2])", "1\n[1, 2]\nnull\n"),
    ("puts()", ""),
]
    evaluated = @capture_out begin evaluate_from_code!(code) end
    test_object(evaluated, expected)
end end
