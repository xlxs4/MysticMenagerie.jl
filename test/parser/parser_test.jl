@time begin
    @time @testset "Expression" begin include("expression_test.jl") end
end
@time begin
    @time @testset "Literal" begin include("literal_test.jl") end
end
@time begin
    @time @testset "Precedence" begin include("precedence_test.jl") end
end
@time begin
    @time @testset "Statement" begin include("statement_test.jl") end
end
