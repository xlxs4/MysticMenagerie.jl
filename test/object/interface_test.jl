using MysticMenagerie

const m = MysticMenagerie

@testset "Test Object interface" begin
    struct DummyObject <: m.AbstractObject end
    @test_throws "type is not defined in the concrete type" m.type(DummyObject())
end
