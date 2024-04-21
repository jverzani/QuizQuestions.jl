# QuizQuestions

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://jverzani.github.io/QuizQuestions.jl/dev/)

A simple means to make basic web pages using Markdown with self-grading quiz questions. Question types are for numeric response, text response (graded with a regular expression or by JavaScript function), matching, a selection of one from many, or one or more from many. Can be used with Weave, Documenter, [quarto](https://quarto.org), or Pluto.


The package creates `show` methods for mime type `text/html` for a few objects that produce HTML showing an input widget with attached javascript code to grade the input once the widget loses focus.

> **Note**
> ## using within `Documenter`
> 
> Math markup using ``\LaTeX`` in Markdown may be done with different delimiters. There are paired dollar signs (or double dollar signs); paired `\(` and `\)` (or `\[`, `\]`) delimiters; double backticks (convenient, as they require no escaping); or even math flavors for triple backtick blocks. When displaying LaTeX. In HTML, the paired parentheses are used. However with Documenter paired dollar signs are needed for markup used by `QuizQuestions`. As of `v"0.3.21"`, placing the line 
>
> `ENV["QQ_LaTeX_dollar_delimiters"] = true`
>
>in `make.jl` will instruct that. This package documentation illustrates.
