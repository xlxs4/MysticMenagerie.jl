@time begin
    @time @testset "Basic" begin include("basic_test.jl") end
end
@time begin
    @time @testset "Comparison" begin include("comparison_test.jl") end
end
@time begin
    @time @testset "Equality" begin include("equality_test.jl") end
end
@time begin
    @time @testset "IfElse/Return" begin include("ifelse_return_test.jl") end
end
@time begin
    @time @testset "Illegal" begin include("illegal_test.jl") end
end
@time begin
    @time @testset "Keyword" begin include("keyword_test.jl") end
end
@time begin
    @time @testset "Operator" begin include("operator_test.jl") end
end
@time begin
    @time @testset "Array" begin include("array_test.jl") end
end
@time begin
    @time @testset "Hash" begin include("hash_test.jl") end
end
