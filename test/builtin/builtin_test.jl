@time begin @time @testset "len" begin include("len_test.jl") end end
@time begin @time @testset "first" begin include("first_test.jl") end end
@time begin @time @testset "last" begin include("last_test.jl") end end
@time begin @time @testset "rest" begin include("rest_test.jl") end end
@time begin @time @testset "push" begin include("push_test.jl") end end
