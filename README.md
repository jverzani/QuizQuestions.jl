# QuizQuestions

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://jverzani.github.io/QuizQuestions.jl/dev/)

A simple means to make basic web pages using Markdown with self-grading quiz questions. Question types are for numeric response, text response (graded with a regular expression), matching, a selection of one from many, or one or more from many. Can be used with Weave, Documenter, or Pluto.


The package creates `show` methods for mime type `text/html` for a few objects that produce HTML showing an input widget with attached javascript code to grade the input once the widget loses focus.
