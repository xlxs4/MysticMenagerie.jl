const BUILTINS = Dict{String, BuiltinObj}("len" => BuiltinObj(function (args::Object...)
                                                                  if length(args) != 1
                                                                      return ErrorObj("wrong number of arguments. got $(length(args)), want 1")
                                                                  end

                                                                  arg = args[1]
                                                                  if arg isa StringObj
                                                                      return IntegerObj(length(arg.value))
                                                                  elseif arg isa ArrayObj
                                                                      return IntegerObj(length(arg.elements))
                                                                  else
                                                                      return ErrorObj("argument to `len` not supported, got $(type(arg))")
                                                                  end
                                                              end),
                                          "first" => BuiltinObj(function (args::Object...)
                                                                    if length(args) != 1
                                                                        return ErrorObj("wrong number of arguments. got $(length(args)), want 1")
                                                                    end

                                                                    arg = args[1]
                                                                    if arg isa StringObj
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
                                                                   if length(args) != 1
                                                                       return ErrorObj("wrong number of arguments. got $(length(args)), want 1")
                                                                   end

                                                                   arg = args[1]
                                                                   if arg isa StringObj
                                                                       return length(arg.value) >
                                                                              0 ?
                                                                              StringObj(string(last(arg.value))) :
                                                                              _NULL
                                                                   elseif arg isa ArrayObj
                                                                       return length(arg.elements) >
                                                                              0 ?
                                                                              last(arg.elements) :
                                                                              _NULL
                                                                   else
                                                                       return ErrorObj("argument to `last` not supported, got $(type(arg))")
                                                                   end
                                                               end))
