using MysticMenagerie, Test

const m = MysticMenagerie

include("test_helpers.jl")

@time begin @time @testset "Lexer" begin include("lexer/lexer_test.jl") end end
@time begin @time @testset "Parser" begin include("parser/parser_test.jl") end end
@time begin @time @testset "AST" begin include("ast/ast_test.jl") end end
@time begin @time @testset "Evaluator" begin include("evaluator/evaluator_test.jl") end end
