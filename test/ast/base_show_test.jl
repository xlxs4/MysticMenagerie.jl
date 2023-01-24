include("../test_helpers.jl")

using MysticMenagerie
using Suppressor: @capture_out

const m = MysticMenagerie

@testset "Test AbstractNode to IO" begin
    id = m.Identifier(m.Token(m.IDENT, "myVar"), "myVar")
    out = @capture_out begin show(id) end
    test_object(out, "myVar")
end

@testset "Test Program to IO" begin
    _, _, program = parse_from_code!("let a = 1; let b = a + 2;")
    out = @capture_out begin show(program) end
    test_object(out, "let a = 1;let b = (a + 2);")
end
