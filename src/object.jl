abstract type AbstractObject end

Base.show(io::IO, object::AbstractObject) = print(io, string(object))
type(::AbstractObject) = error("type is not defined in the concrete type")

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

struct IntegerObj <: AbstractObject
    value::Int
end

type(::MysticMenagerie.IntegerObj) = INTEGER_OBJ
Base.string(i::MysticMenagerie.IntegerObj) = string(i.value)
Base.:(==)(a::IntegerObj, b::IntegerObj) = a.value == b.value
Base.hash(i::IntegerObj, h::UInt) = hash(i.value, h)
AbstractObject(i::Int) = IntegerObj(i)

struct BooleanObj <: AbstractObject
    value::Bool
end

type(::BooleanObj) = BOOLEAN_OBJ
Base.string(b::BooleanObj) = string(b.value)
Base.:(==)(a::BooleanObj, b::BooleanObj) = a.value == b.value
Base.hash(b::BooleanObj, h::UInt) = hash(b.value, h)
AbstractObject(b::Bool) = BooleanObj(b)

struct StringObj <: AbstractObject
    value::String
end

type(::StringObj) = STRING_OBJ
Base.string(s::StringObj) = "\"" * string(s.value) * "\""
Base.:(==)(a::StringObj, b::StringObj) = a.value == b.value
Base.hash(s::StringObj, h::UInt) = hash(s.value, h)
AbstractObject(s::String) = StringObj(s)

struct NullObj <: AbstractObject end

type(::NullObj) = NULL_OBJ
Base.string(n::NullObj) = "null"
AbstractObject(::Nothing) = NullObj()

struct ReturnValue{O <: AbstractObject} <: AbstractObject
    value::O
end

type(::ReturnValue) = RETURN_VALUE
Base.string(rv::ReturnValue) = string(rv.value)

struct ErrorObj{E <: Exception} <: AbstractObject
    exception::E
end

type(::ErrorObj) = ERROR_OBJ
Base.string(e::ErrorObj) = "ERROR: " * e.exception.msg
function Base.:(==)(a::ErrorObj, b::ErrorObj)
    return typeof(a.exception) == typeof(b.exception) && a.exception.msg == b.exception.msg
end

Base.hash(e::ErrorObj, h::UInt) = hash(e.exception, hash(e.exception.msg, h))

struct Environment{O <: AbstractObject}
    store::Dict{String, O}
    outer::Optional{Environment}
end

Environment() = Environment(Dict{String, AbstractObject}(), nothing)
Environment(outer::Environment) = Environment(Dict{String, AbstractObject}(), outer)
function get(env::Environment, name::String)
    result = Base.get(env.store, name, nothing)
    if isnothing(result) && !isnothing(env.outer)
        return get(env.outer, name)
    end

    return result
end

function set!(env::Environment, name::String, value::AbstractObject)
    push!(env.store, name => value)
end

set!(env::Environment, name::String, ::Nothing) = push!(env.store, name => _NULL)

struct FunctionObj <: AbstractObject
    params::Vector{Identifier}
    body::BlockStatement
    env::Environment
end

type(::FunctionObj) = FUNCTION_OBJ
function Base.string(f::FunctionObj)
    return "fn(" * join(map(string, f.params), ", ") * ") {\n" * string(f.body) * "\n}"
end

struct BuiltinObj <: AbstractObject
    fn::Function
end

type(::BuiltinObj) = BUILTIN_OBJ
Base.string(b::BuiltinObj) = "builtin function"

struct ArrayObj <: AbstractObject
    elements::Vector{AbstractObject}
end

type(::ArrayObj) = ARRAY_OBJ
Base.string(a::ArrayObj) = "[" * join(map(string, a.elements), ", ") * "]"
Base.:(==)(a::ArrayObj, b::ArrayObj) = a.elements == b.elements
Base.hash(a::ArrayObj, h::UInt) = hash(a.elements, h)
AbstractObject(a::Vector) = ArrayObj(map(AbstractObject, a))

struct HashObj <: AbstractObject
    pairs::Dict{AbstractObject, AbstractObject}
end

type(::HashObj) = "HASH"
function Base.string(h::HashObj)
    return "{" *
           join(map(x -> string(x[1]) * ": " * string(x[2]), collect(h.pairs)), ", ") *
           "}"
end

Base.:(==)(a::HashObj, b::HashObj) = a.pairs == b.pairs
Base.hash(ho::HashObj, h::UInt) = hash(ho.pairs, h)
function AbstractObject(h::Dict)
    HashObj(Dict(map(x -> AbstractObject(x.first) => AbstractObject(x.second), collect(h))))
end
