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
const HASH_OBJ = "HASH"

struct IntegerObj <: Object
    value::Int64
end

type(::MysticMenagerie.IntegerObj) = INTEGER_OBJ

Base.string(i::MysticMenagerie.IntegerObj) = string(i.value)
Base.:(==)(a::IntegerObj, b::IntegerObj) = a.value == b.value
Base.hash(i::IntegerObj, h::UInt) = hash(i.value, h)

Object(i::Int) = IntegerObj(i)

struct BooleanObj <: Object
    value::Bool
end

type(::BooleanObj) = BOOLEAN_OBJ

Base.string(b::BooleanObj) = string(b.value)
Base.:(==)(a::BooleanObj, b::BooleanObj) = a.value == b.value
Base.hash(b::BooleanObj, h::UInt) = hash(b.value, h)

Object(b::Bool) = BooleanObj(b)

struct StringObj <: Object
    value::String
end

type(::StringObj) = STRING_OBJ

Base.string(s::StringObj) = "\"" * string(s.value) * "\""
Base.:(==)(a::StringObj, b::StringObj) = a.value == b.value
Base.hash(s::StringObj, h::UInt) = hash(s.value, h)

Object(s::String) = StringObj(s)

struct NullObj <: Object end

type(::NullObj) = NULL_OBJ

Base.string(n::NullObj) = "null"

Object(::Nothing) = NullObj()

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
set!(env::Environment, name::String, ::Nothing) = push!(env.store, name => _NULL)

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
Base.:(==)(a::ArrayObj, b::ArrayObj) = a.elements == b.elements
Base.hash(a::ArrayObj, h::UInt) = hash(a.elements, h)

Object(a::Vector) = ArrayObj(map(Object, a))

struct HashObj <: Object
    pairs::Dict{Object, Object}
end

type(::HashObj) = "HASH"

function Base.string(h::HashObj)
    return "{" * join(map(x -> string(x[1]) * ":" * string(x[2]), collect(h.pairs)), ", ") *
           "}"
end
Base.:(==)(a::HashObj, b::HashObj) = a.pairs == b.pairs
Base.hash(ho::HashObj, h::UInt) = hash(ho.pairs, h)

Object(h::Dict) = HashObj(Dict(map(x -> Object(x.first) => Object(x.second), collect(h))))
