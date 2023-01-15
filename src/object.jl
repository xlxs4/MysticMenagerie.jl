abstract type Object end

Base.show(io::IO, object::Object) = print(io, string(object))

type(::Object) = error("type is not defined in the concrete type")

const INTEGER_OBJ = "INTEGER"
const BOOLEAN_OBJ = "BOOLEAN"
const STRING_OBJ = "STRING"
const NULL_OBJ = "NULL"
const RETURN_VALUE = "RETURN_VALUE"
const ERROR_OBJ = "ERROR"
const FUNCTION_OBJ = "FUNCTION"
const BUILTIN_OBJ = "BUILTIN"
const ARRAY_OBJ = "ARRAY"

struct IntegerObj <: Object
    value::Int64
end

type(::MysticMenagerie.IntegerObj) = INTEGER_OBJ
Base.string(i::MysticMenagerie.IntegerObj) = string(i.value)

struct BooleanObj <: Object
    value::Bool
end

type(::BooleanObj) = BOOLEAN_OBJ
Base.string(b::BooleanObj) = string(b.value)

struct StringObj <: Object
    value::String
end

type(::StringObj) = STRING_OBJ
Base.string(s::StringObj) = "\"" * string(s.value) * "\""

struct NullObj <: Object end

type(::NullObj) = NULL_OBJ
Base.string(n::NullObj) = "null"

struct ReturnValue{T <: Object} <: Object
    value::T
end

type(::ReturnValue) = RETURN_VALUE
Base.string(rv::ReturnValue) = string(rv.value)

struct ErrorObj <: Object
    message::String
end

type(::ErrorObj) = ERROR_OBJ
Base.string(e::ErrorObj) = "ERROR: " * e.message

struct Environment{T <: Object}
    store::Dict{String, T}
    outer::Optional{Environment}
end

Environment() = Environment(Dict{String, Object}(), nothing)
Environment(outer::Environment) = Environment(Dict{String, Object}(), outer)

function get(env::Environment, name::String)
    result = Base.get(env.store, name, nothing)
    if isnothing(result) && !isnothing(env.outer)
        return get(env.outer, name)
    end
    return result
end

set!(env::Environment, name::String, value::Object) = push!(env.store, name => value)

struct FunctionObj <: Object
    parameters::Vector{Identifier}
    body::BlockStatement
    env::Environment
end

type(::FunctionObj) = FUNCTION_OBJ
function Base.string(f::FunctionObj)
    return "fn(" * join(map(string, f.parameters), ", ") * ") {\n" * string(f.body) * "\n}"
end

struct BuiltinObj <: Object
    fn::Function
end

type(::BuiltinObj) = BUILTIN_OBJ
Base.string(b::BuiltinObj) = "builtin function"

struct ArrayObj <: Object
    elements::Vector{Object}
end

type(::ArrayObj) = ARRAY_OBJ
Base.string(a::ArrayObj) = "[" * join(map(string, a.elements), ", ") * "]"
