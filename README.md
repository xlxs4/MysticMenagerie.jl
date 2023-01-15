# MysticMenagerie

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://xlxs4.github.io/MysticMenagerie.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://xlxs4.github.io/MysticMenagerie.jl/dev/)
[![Build Status](https://github.com/xlxs4/MysticMenagerie.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/xlxs4/MysticMenagerie.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/xlxs4/MysticMenagerie.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/xlxs4/MysticMenagerie.jl)
[![SciML Code Style](https://img.shields.io/static/v1?label=code%20style&message=SciML&color=9558b2&labelColor=389826)](https://github.com/SciML/SciMLStyle)

A tree-walker C-style interpreter made with the Julia programming language.
It's inspired from [monkeylang](https://monkeylang.org) by Thorsten Ball.

> _Primate Palooza, Magical Monkeys, Arcane Apes, Sorcerer Sanctorum_.

Main features:

- [x] C-like syntax
- [x] variable bindings
- [x] integers and booleans
- [x] arithmetic expressions
- [x] built-in functions
- [x] _first-class and higher-order functions_
- [x] _closures_
- [x] a string data structure
- [x] an array data structure
- [ ] a hash data structure

Major parts:

- [x] the lexer
- [x] the parser
- [x] the Abstract Syntax Tree (AST)
- [x] the internal object system
- [x] the evaluator

Go to the root of the repository and run:

```julia
using JuliaFormatter, MysticMenagerie
format(joinpath(dirname(pathof(MysticMenagerie)), ".."))
```

to format the package automatically.
