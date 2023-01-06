# MysticMenagerie

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://xlxs4.github.io/MysticMenagerie.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://xlxs4.github.io/MysticMenagerie.jl/dev/)
[![Build Status](https://github.com/xlxs4/MysticMenagerie.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/xlxs4/MysticMenagerie.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/xlxs4/MysticMenagerie.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/xlxs4/MysticMenagerie.jl)

A tree-walker C-style interpreter made with the Julia programming language.
It's inspired from [monkeylang](https://monkeylang.org) by Thorsten Ball.

> _Primate Palooza, Magical Monkeys, Arcane Apes, Sorcerer Sanctorum_.

Main features:

- [ ] C-like syntax
- [ ] variable bindings
- [ ] integers and booleans
- [ ] arithmetic expressions
- [ ] built-in functions
- [ ] _first-class and higher-order functions_
- [ ] _closures_
- [ ] a string data structure
- [ ] an array data structure
- [ ] a hash data structure

Major parts:

- [ ] the lexer
- [ ] the parser
- [ ] the Abstract Syntax Tree (AST)
- [ ] the internal object system
- [ ] the evaluator

Go to the root of the repository and run:

```julia
using JuliaFormatter, MysticMenagerie
format(joinpath(dirname(pathof(MysticMenagerie)), ".."))
```

to format the package automatically.
