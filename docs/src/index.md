# QuizQuestions

[QuizQuestions](https://github.com/jverzani/QuizQuestions.jl) allows the inclusion of self-grading quiz questions within a `Documenter`, `Weave`, [quarto](https://quarto.org),  or `Pluto` HTML page.

A few examples:

* [Quarto example](./quarto-example.html)
* [Weave example](./weave-example.html)



## Basics

The basic idea is:

* load the package:

```@example quiz_question
using QuizQuestions
using LaTeXStrings # helper for using math notation
```

* create a question with `Julia` code:

```@example quiz_question
choices = ["one", L"2", L"\sqrt{9}"]
question = "Which is largest?"
answer = 3
radioq(choices, answer; label=question, hint="A hint")
```

* repeat as desired.

----

The quizzes are written in markdown with the questions in `Julia`
blocks. The above code cells would be enclosed in triple-backtick
blocks and would typically have their contents hidden from the
user. How this is done varies between `Documenter`, `Weave`,
[quarto](https://quarto.org), and `Pluto`. The `examples` directory
shows examples of each.


For each question:

* The `show` method of the object for the `text/html` mime type
  inserts the necessary HTML and JavaScript code to show the input
  widget and grading logic.

* the optional `hint` argument allows a text-only hint available to
  the user on hover.

* The optional `label` argument is used to flag the question.

* The optional `explanation` argument is used to give feedback to the user in case there is an incorrect answer given.

For example, the question can be asked in the body of the document
(the position of any hint will be different):


```@example quiz_question
answer = sqrt(2)
tol = 1e-3
numericq(answer, tol,
    label=L"What is $\sqrt{2}$?",
	hint="you need to be within 1/1000")
```

!!! note "Using Documenter adjustment"

    Math  markup using ``\LaTeX`` in Markdown may be done with different delimiters. There are paired dollar signs (or double dollar signs); paired  `\(` and `\)` (or `\[`, `\]`)  delimiters; double backticks (which require no escaping); or even `math` flavors for triple backtick blocks. When displaying ``\LaTeX`` in HTML, the paired parentheses are used. **However** with `Documenter` paired dollar signs are needed for markup used by `QuizQuestions`.
	As of `v"0.3.21"`, placing the line `ENV["QQ_LaTeX_dollar_delimiters"] = true` in `make.jl` will instruct that. This package documentation illustrates.


## Examples of question types

### Choice questions (one from many)


The `radioq` question was shown above.

The `buttonq` question is alternative to radio buttons where the correct answer is shown after the first choice. If this choice is wrong, the explanation is shown along with the correct answer.


```@example quiz_question
buttonq([L"1 + 1", L"2+2", L"-1 + -1"], 1;
    label = L"Which adds to $2$?",
	explanation="Add 'em up")
```

### Multiple choices (one or more from many)


A multiple choice question (one or *more* from many) can be constructed with `multiq`:

```@example quiz_question
choices =[
	"Four score and seven years ago",
	"Lorum ipsum",
	"The quick brown fox jumped over the lazy dog",
	"One and one and one makes three"
]
answer = (1, 4)
multiq(choices, answer,
    label="Select the sentences with numbers (one or more)")
```


The `multibuttonq` question is similar, but it uses a "done" button to initiate the grading. This allows for answers with ``0``, ``1``, or more correct answers.

```@example quiz_question
choices =[
	"Four score and seven years ago",
	"Lorum ipsum",
	"The quick brown fox jumped over the lazy dog",
	"One and one and one makes three"
]
answer = (1, 4)
multibuttonq(choices, answer,
    label="Select the sentences with numbers (one or more)")
```



### Numeric answers

Questions with numeric answers use `numericq`. The question is graded when the input widget loses focus.

```@example quiz_question
answer = 1 + 1
numericq(answer;
    label=L"1 + 1?",
	hint="Do the math")
```

Numeric questions can have an absolute tolerance set to allow for rounding.


### Text response

A question graded by a regular expression can be asked with `stringq`. The question is graded when the input widget loses focus.



```@example quiz_question
stringq(r"^Washington"; label="Who was the first US president?",
        placeholder="last name")
```

### Matching

A question involving matching can be asked with `matchq`.


```@example quiz_question
questions = ("Select a Volvo", "Select a Mercedes", "Select an Audi")
choices = ("XC90", "A4", "GLE 350", "X1") # may be more than questions
answer = (1,3,2) # indices of choices that match correct answer for each question
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
fillblankq(question, r"^lazy$")
```

----

(like `numericq`)

```@example quiz_question
question = "____ `` + 2  = 4``"
fillblankq(question, 2)
```

### Select from an image question

The `hotspotq` shows an image, specified by a file, and grades an answer correct if a mouse click is in a specified rectangular region. The region is given in terms of `(xmin,xmax)` and `(ymin, ymax)` as if the entire region was in ``[0,1] \times [0,1]``, though the `correct_answer` argument allows for more complicated regions.

```@example quiz_question
using Plots
p1 = plot(x -> x^2, axis=nothing, legend=false)
p2 = plot(x -> x^3, axis=nothing, legend=false)
p3 = plot(x -> -x^2, axis=nothing, legend=false)
p4 = plot(x -> -x^3, axis=nothing, legend=false)
l = @layout [a b; c d]
p = plot(p1, p2, p3, p4, layout=l)
imgfile = tempname() * ".png"
savefig(p, imgfile)
hotspotq(imgfile, (0,1/2), (0, 1/2),
    label=L"What best matches the graph of $f(x) = -x^4$?")
```

----

The `PlotlyLight` package provides a very lightweight interface for producing JavaScript based graphs with the `plotly.js` library. The `plotlylight` type allows questions involving an `(x,y)` selection from a graph (`(x,y)` is a point on a graph).

!!! note
    The `plotlylight` question type does not work with `Documenter`.

## Reference

The available question types are listed below. If others are desirable, open an issue on the GitHub repository.

```@docs
radioq
buttonq
yesnoq
booleanq
multiq
multibuttonq
matchq
numericq
stringq
fillblankq
hotspotq
plotlylightq
scorecard
```
