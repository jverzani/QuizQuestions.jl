# QuizQuestions

[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliahub.com/docs/QuizQuestions/)

A simple means to make basic web pages using Markdown with self-grading quiz questions. Question types are for numeric response, text response (graded with a regular expression), or a selection of one from many. Can be used with Weave, Documenter, or Pluto.


The package creates `show` methods for mime type `text/html` for a few objects that produce HTML showing an input widget with attached javascript code to grade the input once the widget loses focus.
