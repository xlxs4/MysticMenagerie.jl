using MysticMenagerie, Test, SafeTestsets

@time begin @time @safetestset "Lexer" begin include("lexer_test.jl") end end
@time begin @time @safetestset "Parser" begin include("parser_test.jl") end end
