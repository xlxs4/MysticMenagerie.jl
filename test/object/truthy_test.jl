using MysticMenagerie

const m = MysticMenagerie

include("test_objects.jl")

@testset "Test Truthy" begin
    @test m.is_truthy(m.IntegerObj(1))
    @test m.is_truthy(m.IntegerObj(0))
    @test m.is_truthy(integer_obj)
    @test m.is_truthy(m.StringObj(""))
    @test m.is_truthy(m.StringObj("0"))
    @test m.is_truthy(m.StringObj("1"))
    @test m.is_truthy(string_obj)
    @test m.is_truthy(true_obj)
    @test !m.is_truthy(false_obj)
    @test !m.is_truthy(null_obj)
    @test m.is_truthy(error_obj)
    @test m.is_truthy(array_obj)
    @test m.is_truthy(hash_obj)
    @test m.is_truthy(function_obj)
    @test m.is_truthy(len)
    @test m.is_truthy(return_value)
end
