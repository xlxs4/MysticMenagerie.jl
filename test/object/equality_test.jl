using MysticMenagerie

const m = MysticMenagerie

include("test_objects.jl")

@testset "Test Equality" begin
    @test integer_obj == m.IntegerObj(1)
    @test integer_obj != m.IntegerObj(2)
    @test string_obj == m.StringObj("foo")
    @test string_obj != m.StringObj("oof")
    @test true_obj == m.BooleanObj(true)
    @test false_obj == m.BooleanObj(false)
    @test null_obj == m.NullObj()
    @test true_obj != false_obj
    @test false_obj != null_obj
    @test true_obj != null_obj
    @test array_obj == m.ArrayObj([m.IntegerObj(1), m.IntegerObj(2), m.IntegerObj(3)])
    @test array_obj != m.ArrayObj([m.IntegerObj(2), m.IntegerObj(3), m.IntegerObj(1)])
    @test hash_obj == m.HashObj(Dict(m.StringObj("foo") => m.IntegerObj(1),
                         m.StringObj("bar") => m.IntegerObj(2)))
    @test hash_obj == m.HashObj(Dict(m.StringObj("bar") => m.IntegerObj(2),
                         m.StringObj("foo") => m.IntegerObj(1)))
    @test hash_obj != m.HashObj(Dict(m.IntegerObj(3) => m.StringObj("4"),
                         m.IntegerObj(1) => m.IntegerObj(2)))
    @test hash_obj != m.HashObj(Dict(m.StringObj("foo") => m.IntegerObj(1),
                         m.IntegerObj(1) => m._TRUE))
end
