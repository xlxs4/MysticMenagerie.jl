mutable struct DivisionByZero <: Exception
    msg::String
end

Base.showerror(io::IO, e::DivisionByZero) = print(io, "division by zero: " * e.msg)

mutable struct TypeMismatch <: Exception
    msg::String
end

Base.showerror(io::IO, e::TypeMismatch) = print(io, "type mismatch: " * e.msg)

mutable struct UnknownIdentifier <: Exception
    msg::String
end

Base.showerror(io::IO, e::UnknownIdentifier) = print(io, "unknown identifier: " * e.msg)

mutable struct UnknownOperator <: Exception
    msg::String
end

Base.showerror(io::IO, e::UnknownOperator) = print(io, "unknown operator: " * e.msg)
