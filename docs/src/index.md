# QuizQuestions

[QuizQuestions](https://github.com/jverzani/QuizQuestions.jl) allows the inclusion of self-grading quiz questions within a `Documenter`, `Weave`, or `Pluto` HTML page.

## Basics

The basic idea is:

* load the package:

```@example quiz_question
using QuizQuestions
```

* create a question with `Julia` code:

```@example quiz_question
choices = ["one", "``2``", raw"``\sqrt{9}``"]
question = "Which is largest?"
answer = 3
radioq(choices, answer; label=question, hint="A hint")
```

* repeat as desired.


The quizzes are written in markdown with the questions in `Julia`
blocks. The above code cells would be enclosed in triple-backtick
blocks and would typically have their contents hidden from the user. How this is
done varies between `Documenter`, `Weave`, and `Pluto`. The `examples`
directory shows examples of each.

----

For each question:

* The `show` method of the object for the `text/html` mime type
  inserts the necessary HTML and JavaScript code to show the input
  widget and grading logic.

* the optional `hint` argument allows a text-only hint available to
  the user on hover.

* The optional `label` argument is used to flag the question.

For example, the question can be asked in the body of the document
(the position of any hint will be different):


```@example quiz_question
answer = sqrt(2)
tol = 1e-3
numericq(answer, tol,
    label=raw"What is ``\sqrt{2}``?",
	hint="you need to be within 1/1000")
```


## Examples of question types

### Choice questions (one from many)


The `radioq` question was shown above.

The `buttonq` question is alternative to radio buttons where the correct answer is shown after the first choice. If this choice is wrong, the explanation is shown along with the correct answer.


```@example quiz_question
buttonq(["``1 + 1``", "``2+2``", "``-1 + -1``"], 1;
    label = "Which adds to ``2``?",
	explanation="Add 'em up")
```

### Multiple choices (one or more from many)


A multiple choice question (one or *more* from many) can be constructed with `multieq`:

```@example quiz_question
choices =["Four score and seven years ago",
"Lorum ipsum",
"The quick brown fox jumped over the lazy dog",
"One and one and one makes three"
]
ans = (1, 4)
multiq(choices, ans,
    label="Select the sentences with numbers (one or more)")
```


### Numeric answers

Questions with numeric answers use `numericq`. The question is graded when the input widget loses focus.

```@example quiz_question
answer = 1 + 1
numericq(answer;
    label="``1 + 1``?",
	hint="Do the math")
```

Numeric questions can have an absolute tolerance set to allow for rounding.


### Text response

A question graded by a regular expression can be asked with `stringq`. The question is graded when the input widget loses focus.



```@example quiz_question
stringq(r"^Washington"; label="Who was the first president?",
        placeholder="last name")
```

### Matching

A question involving matching can be asked with `matchq`.


```@example quiz_question
questions = ("Select a Volvo", "Select a Mercedes", "Select an Audi")
choices = ("XC90", "A4", "GLE 350", "X1") # may be more than questions
answer = (1,3,2) # indices of correct
matchq(questions, choices, answer;
    label="For each question, select the correct answer.")
```

The above shows that the number of choices need not match the number of questions. When they do, a dictionary can be used to specify the choices and the answers will be computed:

```@example quiz_question
d = Dict("Select a Volvo" => "XC90", "Select a Mercedes" => "GLE 350",
         "Select an Audi" => "A4")
matchq(d, label="Match the manufacture with a model")
```

### Fill-in-the-blank questions

Fill-in-the blank questions can be asked with `fillblankq`. Answers can be gathered and graded in different manners.


```@example quiz_question
question = "The quick brown fox jumped over the ____ dog"
fillblankq(question, ("lazy", "brown", "sleeping"), 1)
```

----

(like `stringq`)

```@example quiz_question
question = "The quick brown fox jumped over the ____ dog"
fillblankq(question, r"lazy")
```

----

(like `numericq`)

```@example quiz_question
question = "____ ``+ 2  = 4``"
fillblankq(question, 2)
```


## Reference

Currently only a few question types are available:

```@docs
radioq
buttonq
yesnoq
booleanq
multiq
matchq
numericq
stringq
fillblankq
```
