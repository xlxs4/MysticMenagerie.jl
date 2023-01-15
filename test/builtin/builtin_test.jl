@time begin @time @testset "Literal" begin include("len_test.jl") end end
@time begin @time @testset "Expression" begin include("first_test.jl") end end
@time begin @time @testset "Statement" begin include("last_test.jl") end end
