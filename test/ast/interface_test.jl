@testset "Test implicit interface" begin
    expected_error(f) = "$(string(f)) is not defined in the concrete type"

    struct DummyNode <: m.Node end
    @test_throws ErrorException(expected_error(m.token_literal)) m.token_literal(DummyNode())

    struct DummyExpression <: m.Expression end
    @test_throws ErrorException(expected_error(m.token_literal)) m.token_literal(DummyExpression())
    @test_throws ErrorException(expected_error(m.expression_node)) m.expression_node(DummyExpression())

    struct DummyStatement <: m.Statement end
    @test_throws ErrorException(expected_error(m.token_literal)) m.token_literal(DummyStatement())
    @test_throws ErrorException(expected_error(m.statement_node)) m.statement_node(DummyStatement())
end
