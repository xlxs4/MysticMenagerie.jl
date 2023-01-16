@time begin @time @testset "Map" begin include("map_test.jl") end end
@time begin @time @testset "Reduce" begin include("reduce_test.jl") end end
