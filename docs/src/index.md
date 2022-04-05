# QuizQuestions

[QuizQuestions](https://github.com/jverzani/QuizQuestions.jl) allows the inclusion of self-grading quiz questions within a `Documenter`, `Weave`, or `Pluto` HTML page.


The basic idea is:

* load the package:

```@example quiz_question
using QuizQuestions
```

* create a question:

```@example quiz_question
choices = ["one", "``2``", raw"``\sqrt{9}``"]
question = "Which is largest?"
answer = 3
radioq(choices, answer; label=question, hint="A hint")
```

* repeat as desired.

----

The `show` method of the object for the `text/html` mime type produced by `radioq` inserts the necessary HTML and JavaScript code to show the input widget and grading logic.


The above question uses radio buttons for allowing one choice from many.

The `hint` argument allows an optional text-only hint available to the user on hover. The `label` is used to flag the question. This is also optional. For example, the question can be asked in the body of the document (the position of any hint will be different):

What is ``\sqrt{2}``?

```@example quiz_question
answer = sqrt(2)
tol = 1e-3
numericq(answer, tol, hint="you need to be within 1/1000")
```


The quiz questions are written in markdown, as would be the rest of the Documenter or Weave document containing the questions. The above code cells would be enclosed in triple-backtick blocks and would have their contents hidden from the user. How this is done varies from `Documenter`, `Weave`, and `Pluto`. The `examples` directory shows examples of each.


* Here is an example of a numeric question:

```@example quiz_question
answer = 1 + 1
numericq(answer; label="``1 + 1``?", hint="Do the math")
```

Numeric questions can have an absolute tolerance set to allow for rounding.

* Here is an example of a multiple choice question (one or *more* from many):

Select the sentences with numbers:

```@example quiz_question
choices =["Four score and seven years ago",
"Lorum ipsum",
"The quick brown fox jumped over the lazy dog",
"One and one and one makes three"
]
ans = (1, 4)
multiq(choices, ans, label="Select one or more")
```

* Here is an example of a short text question graded by a regular expression:


Who was the first president?

```@example quiz_question
stringq(r"^Washington", label="last name")
```

* Here is an example of matching

For each question, select the correct answer.

```@example quiz_question
questions = ("Select a Volvo", "Select a Mercedes", "Select an Audi")
choices = ("XC90", "A4", "GLE 350", "X1") # may be more than questions
answer = (1,3,2) # indices of correct
matchq(questions, choices, answer)
```

----

Currently only a few question types are available:

```@docs
numericq
stringq
radioq
yesnoq
booleanq
multiq
matchq
```
