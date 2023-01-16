const BUILTINS = Base.ImmutableDict("len" => BuiltinObj(function (args::Object...)
                                                            if length(args) !=
                                                               1
                                                                return ErrorObj("wrong number of arguments. got $(length(args)), want 1")
                                                            end

                                                            arg = args[1]
                                                            if arg isa
                                                               StringObj
                                                                return IntegerObj(length(arg.value))
                                                            elseif arg isa
                                                                   ArrayObj
                                                                return IntegerObj(length(arg.elements))
                                                            else
                                                                return ErrorObj("argument to `len` not supported, got $(type(arg))")
                                                            end
                                                        end),
                                    "first" => BuiltinObj(function (args::Object...)
                                                              if length(args) !=
                                                                 1
                                                                  return ErrorObj("wrong number of arguments. got $(length(args)), want 1")
                                                              end

                                                              arg = args[1]
                                                              if arg isa
                                                                 StringObj
                                                                  return length(arg.value) >
                                                                         0 ?
                                                                         StringObj(string(first(arg.value))) :
                                                                         _NULL
                                                              elseif arg isa
                                                                     ArrayObj
                                                                  return length(arg.elements) >
                                                                         0 ?
                                                                         first(arg.elements) :
                                                                         _NULL
                                                              else
                                                                  return ErrorObj("argument to `first` not supported, got $(type(arg))")
                                                              end
                                                          end),
                                    "last" => BuiltinObj(function (args::Object...)
                                                             if length(args) !=
                                                                1
                                                                 return ErrorObj("wrong number of arguments. got $(length(args)), want 1")
                                                             end

                                                             arg = args[1]
                                                             if arg isa
                                                                StringObj
                                                                 return length(arg.value) >
                                                                        0 ?
                                                                        StringObj(string(last(arg.value))) :
                                                                        _NULL
                                                             elseif arg isa
                                                                    ArrayObj
                                                                 return length(arg.elements) >
                                                                        0 ?
                                                                        last(arg.elements) :
                                                                        _NULL
                                                             else
                                                                 return ErrorObj("argument to `last` not supported, got $(type(arg))")
                                                             end
                                                         end),
                                    "rest" => BuiltinObj(function (args::Object...)
                                                             if length(args) !=
                                                                1
                                                                 return ErrorObj("wrong number of arguments. got $(length(args)), want 1")
                                                             end

                                                             arg = args[1]
                                                             if arg isa
                                                                StringObj
                                                                 if length(arg.value) >
                                                                    0
                                                                     _, start = iterate(arg.value)
                                                                     return StringObj(arg.value[start:end])
                                                                 else
                                                                     return _NULL
                                                                 end
                                                             elseif arg isa
                                                                    ArrayObj
                                                                 return length(arg.elements) >
                                                                        0 ?
                                                                        ArrayObj(arg.elements[2:end]) :
                                                                        _NULL
                                                             else
                                                                 return ErrorObj("argument to `rest` not supported, got $(type(arg))")
                                                             end
                                                         end),
                                    "push" => BuiltinObj(function (args::Object...)
                                                             if length(args) != 2
                                                                 return ErrorObj("wrong number of arguments. got $(length(args)), want 2")
                                                             end

                                                             array = args[1]
                                                             if array isa ArrayObj
                                                                 elements = copy(array.elements)
                                                                 push!(elements, args[2])

                                                                 return ArrayObj(elements)
                                                             else
                                                                 return ErrorObj("argument to `push` must be ARRAY, got $(type(array))")
                                                             end
                                                         end))
