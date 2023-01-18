using MysticMenagerie

const m = MysticMenagerie

include("test_objects.jl")

@testset "Test Type" begin
    @test m.type(integer_obj) == "INTEGER"
    @test m.type(string_obj) == "STRING"
    @test m.type(true_obj) == "BOOLEAN"
    @test m.type(false_obj) == "BOOLEAN"
    @test m.type(null_obj) == "NULL"
    @test m.type(error_obj) == "ERROR"
    @test m.type(array_obj) == "ARRAY"
    @test m.type(hash_obj) == "HASH"
    @test m.type(function_obj) == "FUNCTION"
    @test m.type(len) == "BUILTIN"
    @test m.type(return_value) == "RETURN_VALUE"
end
