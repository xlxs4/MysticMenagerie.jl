const BUILTINS = Base.ImmutableDict("len" => BuiltinObj(function (arguments::AbstractObject...)
                                                            if length(arguments) !=
                                                               1
                                                                return ErrorObj(ArgumentError("wrong number of arguments. got $(length(arguments)), want 1"))
                                                            end

                                                            argument = arguments[1]
                                                            if argument isa
                                                               StringObj
                                                                return IntegerObj(length(argument.value))
                                                            elseif argument isa
                                                                   ArrayObj
                                                                return IntegerObj(length(argument.elements))
                                                            elseif argument isa HashObj
                                                                return IntegerObj(length(argument.pairs))
                                                            else
                                                                return ErrorObj(ArgumentError("argument to `len` not supported, got $(type(argument))"))
                                                            end
                                                        end),
                                    "first" => BuiltinObj(function (arguments::AbstractObject...)
                                                              if length(arguments) !=
                                                                 1
                                                                  return ErrorObj(ArgumentError("wrong number of arguments. got $(length(arguments)), want 1"))
                                                              end

                                                              argument = arguments[1]
                                                              if argument isa
                                                                 StringObj
                                                                  return length(argument.value) >
                                                                         0 ?
                                                                         StringObj(string(first(argument.value))) :
                                                                         _NULL
                                                              elseif argument isa
                                                                     ArrayObj
                                                                  return length(argument.elements) >
                                                                         0 ?
                                                                         first(argument.elements) :
                                                                         _NULL
                                                              else
                                                                  return ErrorObj(ArgumentError("argument to `first` not supported, got $(type(argument))"))
                                                              end
                                                          end),
                                    "last" => BuiltinObj(function (arguments::AbstractObject...)
                                                             if length(arguments) !=
                                                                1
                                                                 return ErrorObj(ArgumentError("wrong number of arguments. got $(length(arguments)), want 1"))
                                                             end

                                                             argument = arguments[1]
                                                             if argument isa
                                                                StringObj
                                                                 return length(argument.value) >
                                                                        0 ?
                                                                        StringObj(string(last(argument.value))) :
                                                                        _NULL
                                                             elseif argument isa
                                                                    ArrayObj
                                                                 return length(argument.elements) >
                                                                        0 ?
                                                                        last(argument.elements) :
                                                                        _NULL
                                                             else
                                                                 return ErrorObj(ArgumentError("argument to `last` not supported, got $(type(argument))"))
                                                             end
                                                         end),
                                    "rest" => BuiltinObj(function (arguments::AbstractObject...)
                                                             if length(arguments) !=
                                                                1
                                                                 return ErrorObj(ArgumentError("wrong number of arguments. got $(length(arguments)), want 1"))
                                                             end

                                                             argument = arguments[1]
                                                             if argument isa
                                                                StringObj
                                                                 if length(argument.value) >
                                                                    0
                                                                     _, start = iterate(argument.value)
                                                                     return StringObj(argument.value[start:end])
                                                                 else
                                                                     return _NULL
                                                                 end
                                                             elseif argument isa
                                                                    ArrayObj
                                                                 return length(argument.elements) >
                                                                        0 ?
                                                                        ArrayObj(argument.elements[2:end]) :
                                                                        _NULL
                                                             else
                                                                 return ErrorObj(ArgumentError("argument to `rest` not supported, got $(type(argument))"))
                                                             end
                                                         end),
                                    "push" => BuiltinObj(function (arguments::AbstractObject...)
                                                             if length(arguments) != 2 &&
                                                                length(arguments) != 3
                                                                 return ErrorObj(ArgumentError("wrong number of arguments. got $(length(arguments)), want 2 or 3"))
                                                             end
                                                             if length(arguments) == 2
                                                                 array = arguments[1]
                                                                 if array isa ArrayObj
                                                                     elements = copy(array.elements)
                                                                     push!(elements,
                                                                           arguments[2])

                                                                     return ArrayObj(elements)
                                                                 else
                                                                     return ErrorObj(ArgumentError("argument to `push` must be ARRAY, got $(type(array))"))
                                                                 end
                                                             else
                                                                 hash = arguments[1]
                                                                 if hash isa HashObj
                                                                     pairs = copy(hash.pairs)
                                                                     push!(pairs,
                                                                           arguments[2] => arguments[3])
                                                                     return HashObj(pairs)
                                                                 else
                                                                     return ErrorObj(ArgumentError("argument to `push` must be HASH, got $(type(hash))"))
                                                                 end
                                                             end
                                                         end),
                                    "puts" => BuiltinObj(function (arguments::AbstractObject...)
                                                             for argument in arguments
                                                                 if argument isa StringObj
                                                                     println(argument.value)
                                                                 else
                                                                     println(argument)
                                                                 end
                                                             end
                                                         end),
                                    "type" => BuiltinObj(function (arguments::AbstractObject...)
                                                             if length(arguments) != 1
                                                                 return ErrorObj(ArgumentError("wrong number of arguments. got $(length(arguments)), want 1"))
                                                             end

                                                             return StringObj(type(arguments[1]))
                                                         end))
