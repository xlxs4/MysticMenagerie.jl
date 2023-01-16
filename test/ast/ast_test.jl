@time begin @time @testset "Base.string" begin include("base_string_test.jl") end end
@time begin @time @testset "token_literal" begin include("token_literal_test.jl") end end
