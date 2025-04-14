# About FYPP

## Programming Languages

How does Fortran compare to C++/Rust/Python/Julia?

- Notable lack of abstractions
- Fortranistas: it's easy and fast

## What can abstractions do for you?

- DRY?

## Health measures

- If you want to change something, how many places do you need to look?
    - global variables: everywhere it is used
    - (inline) accessor function: one place only
- How much of the code do I need to know to make a change?

## Speed vs. Design

- Abstract code is perceived to be slow: generic design patterns don't always allow for special optimisations.

- SIMD: make small loops, do not use functions!? (what about pure inlines?)

## Main question

How do I keep code portable across compilers, while getting top performance, and good design?

## Fypp

Preprocessor that does more than CPP.

Prepend lines with `#:` for a control directive, `$:` for an eval directive and `@:` for a direct (macro) call.

Inline values `${var}$`

Syntax: `if/elif/else/endif`, `set`, `del`, `for/in/endfor`, `assert`, `stop`

Macros: `def/enddef`

Use Python to expand code

## Invocation

Invocation with `-D` to set variables.

Output of line numbering markers for compiler errors `-n`.


