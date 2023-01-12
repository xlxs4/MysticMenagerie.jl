abstract type Object end

type(::Object) = error("type is not defined in the concrete type")

const INTEGER = "INTEGER"
const BOOLEAN = "BOOLEAN"
const NULL = "NULL"

struct Integer <: Object
    value::Int64
end

type(::MysticMenagerie.Integer) = INTEGER
Base.string(i::MysticMenagerie.Integer) = string(i.value)

struct Boolean <: Object
    value::Bool
end

type(::Boolean) = BOOLEAN
Base.string(b::Boolean) = string(b.value)

struct Null <: Object end

type(::Null) = NULL
Base.string(n::Null) = "null"
