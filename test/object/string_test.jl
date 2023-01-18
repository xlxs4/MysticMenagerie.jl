using MysticMenagerie

const m = MysticMenagerie

include("test_objects.jl")

@testset "Test Base.string" begin
    @test string(integer_obj) == "1"
    @test string(true_obj) == "true"
    @test string(false_obj) == "false"
    @test string(null_obj) == "null"
    @test string(string_obj) == "\"foo\""
    @test string(error_obj) == "ERROR: BOOLEAN"
    @test string(array_obj) == "[1, 2, 3]"
    @test string(hash_obj) in ["{\"foo\": 1, \"bar\": 2}", "{\"bar\": 2, \"foo\": 1}"]
    @test string(function_obj) == "fn(x) {\n(x + 2)\n}"
    @test string(len) == "builtin function"
    @test string(return_value) == "true"
end
