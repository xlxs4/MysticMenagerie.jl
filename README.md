# MysticMenagerie

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://xlxs4.github.io/MysticMenagerie.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://xlxs4.github.io/MysticMenagerie.jl/dev/)
[![Build Status](https://github.com/xlxs4/MysticMenagerie.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/xlxs4/MysticMenagerie.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/xlxs4/MysticMenagerie.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/xlxs4/MysticMenagerie.jl)
[![SciML Code Style](https://img.shields.io/static/v1?label=code%20style&message=SciML&color=9558b2&labelColor=389826)](https://github.com/SciML/SciMLStyle)

A C-style programming language with a tree-walker Pratt-parsing interpreter.
Made with the Julia programming language.
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
- [x] a hash data structure

Major parts:

- [x] lexer/tokenizer
- [x] Pratt parser
- [x] Abstract Syntax Tree (AST)
- [x] internal object system
- [x] evaluator

Go to the root of the repository and run:

```julia
using JuliaFormatter, MysticMenagerie
format(joinpath(dirname(pathof(MysticMenagerie)), ".."))
```

to format the package automatically.
