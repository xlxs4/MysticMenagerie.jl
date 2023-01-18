using MysticMenagerie

const m = MysticMenagerie

@testset "Test ImmutableDict" begin
    code = Base.ImmutableDict(1 => 2, 3 => 4)
    expected = Base.ImmutableDict(1 => 2)
    expected = Base.ImmutableDict(expected, 3 => 4)
    @test code == expected
end
