const BUILTINS = Dict{String, BuiltinObj}("len" => BuiltinObj(function (args::Object...)
                                                                  if length(args) != 1
                                                                      return ErrorObj("wrong number of arguments. got $(length(args)), want 1")
                                                                  end

                                                                  arg = args[1]
                                                                  if arg isa StringObj
                                                                      return IntegerObj(length(arg.value))
                                                                  elseif arg isa ArrayObj
                                                                      return IntegerObj(length(arg.elements))
                                                                  end

                                                                  return ErrorObj("argument to `len` not supported, got $(type(arg))")
                                                              end))
