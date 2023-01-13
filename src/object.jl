abstract type Object end

Base.show(io::IO, object::Object) = print(io, string(object))

type(::Object) = error("type is not defined in the concrete type")

const INTEGER_OBJ = "INTEGER"
const BOOLEAN_OBJ = "BOOLEAN"
const NULL_OBJ = "NULL"

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
