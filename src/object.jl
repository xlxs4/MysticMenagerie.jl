abstract type Object end

Base.show(io::IO, object::Object) = print(io, string(object))

type(::Object) = error("type is not defined in the concrete type")

const INTEGER_OBJ = "INTEGER"
const BOOLEAN_OBJ = "BOOLEAN"
const NULL_OBJ = "NULL"
const RETURN_VALUE = "RETURN_VALUE"
const ERROR_OBJ = "ERROR"

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
end

Environment() = Environment(Dict{String, Object}())
get(env::Environment, name::String) = Base.get(env.store, name, nothing)
set!(env::Environment, name::String, value::Object) = push!(env.store, name => value)
