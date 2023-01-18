using SafeTestsets

const GROUP = get(ENV, "GROUP", "All")

@time begin
    if GROUP == "All" || GROUP == "AST"
        @time @safetestset "Base.string" begin include("ast/base_string_test.jl") end
        @time @safetestset "Token literal" begin include("ast/token_literal_test.jl") end
    end

    if GROUP == "All" || GROUP == "Builtin"
        @time @safetestset "first" begin include("builtin/first_test.jl") end
        @time @safetestset "last" begin include("builtin/last_test.jl") end
        @time @safetestset "len" begin include("builtin/len_test.jl") end
        @time @safetestset "push" begin include("builtin/push_test.jl") end
        @time @safetestset "rest" begin include("builtin/rest_test.jl") end
    end

    if GROUP == "All" || GROUP == "Complex"
        @time @safetestset "map" begin include("complex/map_test.jl") end
        @time @safetestset "reduce" begin include("complex/reduce_test.jl") end
    end

    if GROUP == "All" || GROUP == "Evaluator"
        @time @safetestset "Environment" begin include("evaluator/environment_test.jl") end
        @time @safetestset "Error" begin include("evaluator/error_test.jl") end
        @time @safetestset "Expression" begin include("evaluator/expression_test.jl") end
        @time @safetestset "Literal" begin include("evaluator/literal_test.jl") end
        @time @safetestset "Statement" begin include("evaluator/statement_test.jl") end
        @time @safetestset "Type" begin include("evaluator/type_test.jl") end
    end

    if GROUP == "All" || GROUP == "Lexer"
        @time @safetestset "Array" begin include("lexer/array_test.jl") end
        @time @safetestset "Basic" begin include("lexer/basic_test.jl") end
        @time @safetestset "Comparison" begin include("lexer/comparison_test.jl") end
        @time @safetestset "Equality" begin include("lexer/equality_test.jl") end
        @time @safetestset "Hash" begin include("lexer/hash_test.jl") end
        @time @safetestset "IfElse/Return" begin include("lexer/ifelse_return_test.jl") end
        @time @safetestset "Illegal" begin include("lexer/illegal_test.jl") end
        @time @safetestset "Keyword" begin include("lexer/keyword_test.jl") end
        @time @safetestset "Operator" begin include("lexer/operator_test.jl") end
    end

    if GROUP == "All" || GROUP == "Object"
        @time @safetestset "Equality" begin include("object/equality_test.jl") end
        @time @safetestset "String" begin include("object/string_test.jl") end
        @time @safetestset "Truthy" begin include("object/truthy_test.jl") end
        @time @safetestset "Type" begin include("object/type_test.jl") end
    end

    if GROUP == "All" || GROUP == "Parser"
        @time @safetestset "Expression" begin include("parser/expression_test.jl") end
        @time @safetestset "Literal" begin include("parser/literal_test.jl") end
        @time @safetestset "Precedence" begin include("parser/precedence_test.jl") end
        @time @safetestset "Statement" begin include("parser/statement_test.jl") end
    end
end # @time
