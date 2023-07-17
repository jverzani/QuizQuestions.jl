abstract type Question end

mutable struct Stringq <: Question
    re::Regex
    label
    hint
    explanation
    placeholder
end

"""
    stringq(re::Regex; label="", hint="", explanation="", placeholder="")

Match string answer with regular expression

Arguments:

* `re`: a regular expression for grading

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

* `explanation`: text to display on a wrong selection

* `placeholder`: text shown when input widget is initially drawn

## Example

```
re = Regex("^abc")
stringq(re, label="First 3 letters...")
```

"""
stringq(re::Regex; label="", hint="", explanation="",  placeholder=nothing) =
    Stringq(re, label, hint, explanation, placeholder)


##
mutable struct Numericq <: Question
    val
    atol
    units
    label
    hint
    explanation
    placeholder
end

"""
    numericq(value, atol=1e-3; label="", hint="", units="", explanation="", placeholder=nothing)

Match a numeric answer

Arguments:

* `value`: the numeric answer

* `atol`: ``|answer - value| \\le atol`` is used to determine correctness

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

* `units`: a string indicating expected units

* `placeholder`: text shown when input widget is initially drawn

"""
function numericq(val, atol=1e-3, args...;
                  label="",
                  hint="", units::AbstractString="",
                  explanation="",
                  placeholder=nothing)

    Numericq(val, atol,  units, label, hint, explanation, placeholder)
end

numericq(val::Int; kwargs...) = numericq(val, 0; kwargs...)



##
mutable struct Radioq <: Question
    choices
    answer
    values
    labels
    label
    hint
    explanation
    inline
end

"""
    radioq(choices, answer; label="", hint="", explanation="", keep_order=false)

Multiple choice question (one of several)

Arguments:

* `choices`: indexable collection of choices. As seen in the example, choices can be formatted with markdown.

* `answer::Int`: index of correct choice

* `keep_order::Boolean`: if `true` keeps display order of choices, otherwise they are shuffled

* `inline::Bool`: hint to render inline (or not) if supported

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

* `explanation`: text to display on a wrong selection

## Example:

```
choices = ["beta", raw"``\\beta``", "`beta`"]
answer = 2
radioq(choices, answer; hint="Which is the Greek symbol?")
```

"""
function radioq(choices, answer::Integer;
                label="", hint="", explanation="",
                inline::Bool=(hint!=""),
                keep_order::Bool=false)
    inds = collect(1:length(choices))
    values = copy(inds)
    labels = choices
    !keep_order && shuffle!(inds)

    Radioq(choices[inds], findfirst(isequal(answer), inds),
           values, labels[inds], label, hint, explanation, inline)
end

##
mutable struct Buttonq <: Question
    choices
    answer
    label
    hint
    explanation
    colors
end

"""
    buttonq(choices, answer; label="", hint="", [colors])

Use buttons for multiple choice (one of many). Show answer after first click.

Arguments:

* `choices`: indexable collection of choices. As seen in the example, choices can be formatted with markdown.

* `answer::Int`: index of correct choice

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

* `explanation`: text to display on a wrong selection


## Example:

```
choices = ["beta", raw"``\\beta``", "`beta`"]
answer = 2
explanation = "The other two answers are not a symbol, but a name"
buttonq(choices, answer; label="Which is the Greek symbol?",
        explanation=explanation)
```
"""
function buttonq(choices, answer::Integer;
                 label="", hint="", explanation="",
                 colors=(GREEN="#FF0000AA",
                         RED = "#00AA33AA",
                         BLUE = nothing) #"#0033CC11",
                 )

    answers = [i == answer ? "correct" : "incorrect" for i ∈ eachindex(choices)]
    Buttonq(choices, answers, label, hint, explanation, colors)
end





##
mutable struct Multiq <: Question
    choices
    answer
    values
    labels
    label
    hint
    explanation
    inline
end

"""
    multiq(choices, answers; label="", hint="", explanation="", keep_order=false)

Multiple choice question (one *or more* of several)

Arguments:

* `choices`: indexable collection of choices. As seen in the example, choices can be formatted with markdown.

* `answers::Vector{Int}`: index of correct choice(s)

* `keep_order::Boolean`: if `true` keeps display order of choices, otherwise they are shuffled

* `inline::Bool`: hint to render inline (or not) if supported

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

* `explanation`: text to display on a wrong selection

## Example

```
choices = ["pear", "tomato", "banana"]
answers = [1,3]
multiq(choices, answers; label="yellow foods", hint="not the red one!")
```

"""
function multiq(choices, answers;
                label="", hint="", explanation="",
                inline::Bool=(hint!=""),
                keep_order::Bool=false)
    inds = collect(1:length(choices))
    values = copy(inds)
    labels = choices
    !keep_order && shuffle!(inds)

    Multiq(choices[inds], findall(in(answers), inds),
           values, labels[inds], label, hint, explanation, inline)
end

## ----
mutable struct MultiButtonq <: Question
    choices
    answer
    values
    labels
    label
    hint
    explanation
    inline
end

"""
    multibuttonq(choices, answers; label="", hint="", explanation="", keep_order=false)

Multiple choice question (zero, one *or more* of several) using buttons and a "done" button to reveal  the answers and whether the user input is correct.

Arguments:

* `choices`: indexable collection of choices. As seen in the example, choices can be formatted with markdown.

* `answers::Vector{Int}`: index of correct choice(s)

* `keep_order::Boolean`: if `true` keeps display order of choices, otherwise they are shuffled

* `inline::Bool`: hint to render inline (or not) if supported

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

* `explanation`: text to display on a wrong selection

## Example

```
choices = ["pear", "tomato", "banana"]
answers = [1,3]
multibuttonq(choices, answers; label="yellow foods", hint="not the red one!")
```

"""
function multibuttonq(choices, answers;
                label="", hint="", explanation="",
                inline::Bool=(hint!=""),
                      keep_order::Bool=false)

    inds = collect(1:length(choices))
    values = copy(inds)
    labels = choices
    !keep_order && shuffle!(inds)

    MultiButtonq(choices[inds], findall(in(answers), inds),
           values, labels[inds], label, hint, explanation, inline)
end

##
mutable struct Matchq <: Question
    questions
    choices
    answer
    label
    hint
    explanation
end

"""
    matchq(questions, choices, answers; label="", hint="", explanation="")
    matchq(d::Dictionary; label="", hint="", explanation="")

Use a drop down to select the right match for each question.

Arguments:

* `questions`: Indexable collection of questions

* `choices`: indexable collection of choices for each question. As seen in the example, choices can be formatted with markdown.

* `answers`: for each question, the index from `choices` of the correct answer

* `d`: As an alternative, a dictionary of questions and answers can be specified. The choices will be taken from the values then randomized, the answers will be computed

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

* `explanation`: text to display on a wrong selection

## Examples

```
questions = ("Select a Volvo", "Select a Mercedes", "Select an Audi")
choices = ("XC90", "A4", "GLE 350", "X1") # may be more than questions
answer = (1,3,2) # indices of correct
matchq(questions, choices, answer)
```

This example uses a dictionary to specify the questions and choices:

```
d = Dict("Select a Volvo" => "XC90", "Select a Mercedes" => "GLE 250")
matchq(d)
```

"""
function matchq(questions, choices, answers;
                label="", hint="", explanation="")

    @assert length(questions) == length(answers)

    Matchq(questions, choices, answers,
           label, hint, explanation)
end

function matchq(d::AbstractDict; kwargs...)

    questions = collect(keys(d))
    choices = collect(values(d))
    n = length(questions)
    inds = shuffle(1:n)

    matchq(questions, choices[inds], sortperm(inds); kwargs...)
end



"""
    booleanq(ans; [label, hint, explanation])
True of false questions:

## Example:

```
booleanq(true; label="Does it hurt...")
```

"""
function booleanq(ans::Bool;
                  labels::Vector=["true", "false"],
                  label="", hint::AbstractString="", explanation="",
                  inline::Bool=true)
    choices = labels[1:2]
    ans = 2 - ans
    radioq(choices, ans;
           label=label, hint=hint, explanation=explanation,
           inline=inline, keep_order=true)
end

"""
    yesnoq(ans; [label, hint, explanation])

Boolean question with `yes` or `no` labels.

Examples:

```
yesnoq("yes")
yesnoq(true)
```

"""
yesnoq(ans::AbstractString, args...; kwargs...) = radioq(["Yes", "No"], ans == "yes" ? 1 : 2, args...; keep_order=true, kwargs...)
yesnoq(ans::Bool, args...; kwargs...) = yesnoq(ans ? "yes" : "no", args...;kwargs...)

## --------

abstract type FillBlankQ <: Question end

mutable struct FillBlankChoiceQ <: FillBlankQ
    question
    choices
    answer
    label
    hint
    explanation
end

mutable struct FillBlankStringQ <: FillBlankQ
    question
    re::Regex
    label
    hint
    explanation
    placeholder
end

mutable struct FillBlankNumericQ <: FillBlankQ
    question
    val
    atol
    label
    hint
    explanation
    placeholder
end


"""
    fillblankq(question answer::Regex; placeholder=nothing, [label, hint, explanation])
    fillblankq(question, choices, answer; keep_order=false,[label, hint, explanation])
    fillblankq(question, val, atol=0; placeholder=nothing, [label, hint, explanation])

Present a fill-in-the-blank question where the blank can be a selection, a number, or a string graded by a regular expression.

* `question`: A string. Use `____` (4 or more under scores) to indicate the blank.

Other rguments from `stringq`, `radioq`, and `numericq`

## Examples
```
question = "The quick brown fox jumped over the ____ dog"
fillblankq(question, r"lazy")
fillblankq(question, ("lazy", "brown", "sleeping"), 1)
fillblankq("____ ``+ 2  = 4``", 2)
```
"""
fillblankq(question, answer::Regex; label="", hint="", explanation="",
           placeholder=nothing) =
    FillBlankStringQ(question, answer, label, hint, explanation, placeholder)


function fillblankq(question, choices, answer; label="", hint="", explanation="",
                    keep_order=false)

    if !keep_order
        inds = collect(1:length(choices))
        values = copy(inds)
        labels = choices
        !keep_order && shuffle!(inds)
        choices = choices[inds]
        answer = findfirst(isequal(answer), inds)
    end


    FillBlankChoiceQ(question, choices, answer, label, hint, explanation)
end

fillblankq(question, val::Real, atol=0; label="", hint="", explanation="",
           placeholder=nothing) =
    FillBlankNumericQ(question, val, atol, label, hint, explanation, placeholder)

## ------

mutable struct HotspotQ <: Question
    imgfile
    xs
    ys
    label
    hint
    explanation
    correct_answer
end

"""
    hotspotq(imagefile, xs, ys=(0,1); label="", hint="", explanation="",
        correct_answer=nothing)

Question type to check if user clicks in a specified region of an image.

* `imgfile`: File of an image. The images will be encoded and embedded in the web page.

* `xs`: iterable specifying `(xmin, xmax)` with `0 <= xmin <= xmax <= 1`

* `ys`: iterable specifying `(ymin, ymax)`

* `correct_answer`: A text snippet of JavaScript which can be specified to add more complicated logic to test if an answer is correct. It must use `x` and `y` for the coordinates of the click.

## Examples

```
using Plots
p1 = plot(x -> x^2, axis=nothing, legend=false)
p2 = plot(x -> x^3, axis=nothing, legend=false)
p3 = plot(x -> -x^2, axis=nothing, legend=false)
p4 = plot(x -> -x^3, axis=nothing, legend=false)
l = @layout [a b; c d]
p = plot(p1, p2, p3, p4, layout=l)
imgfile = tempname() * ".png"
savefig(p, imgfile)
hotspotq(imgfile, (0,1/2), (0, 1/2), label="What best matches the graph of ``f(x) = -x^4``?")
```

!!! note
    The display of the image is not adjusted by this question type and must
    be managed separately.

"""
function hotspotq(imgfile, xs, ys=(0,1);
                  label = "", hint="", explanation="",
                  correct_answer=nothing)
    HotspotQ(imgfile, xs, ys, label, hint, explanation, correct_answer)
end


## ----
mutable struct PlotlyLightQ <: Question
    p
    xs
    ys
    label
    hint
    explanation
    correct_answer
end

"""
    plotlylightq(p, xs=(-Inf, Inf), ys=(-Inf, Inf);
                 label="", hint="", explanation="",
                 correct_answer=nothing)


From a plotly graph of a function present a question about the `x-y` point on a graph shown on hover. (For figures with multiple graphs, the hover of the first one is taken. For parameterized plots, the hover may be computed in an unexpected manner.)

By default, correct answers select a value on the graph with `x` in the range specified by `xs` and `y` in the range specified by `ys`.

* `xs`: specifies interval for selected point `[x₀,x₁]`, defaults to `(-Inf,Inf)`

* `ys`: range `[y₀,y₁]`

* `correct_answer`: When specified, allows more advanced notions of correct. This is a JavaScript code snippet with `x` and `y` representing the hovered point on the graph that is highlighted on clicking.

## Examples

```
using PlotlyLight
xs = range(0, 2pi, length=100)
ys = sin.(xs)
p = Plot(Config(x=xs, y=ys))
plotlylightq(p, (3,Inf); label="Click a value with ``x>3``")
```

An example where the default grading script needs modification. Note
also, the `x`, `y` values refer to the *first* graph. (One could
modify their definition in `correct answer`; they are found through
`x=e.points[0].x`, `y=e.points[0].y`.)

```
xs = range(0, 2pi, length=100)
ys = sin.(xs)
p = Plot(Config(x=xs, y=ys));
push!(p.data, Config(x=xs, y=cos.(xs)));  # add layer
question = "Click a value where `sin(x)` is increasing"
# evalute pi/2 as no pi in JavaScript, also Inf -> Infinity
correct_answer = "((x >= 0 && x <= $(pi/2)) || (x >= $(3pi/2) && x <= $(2pi)))"
plotlylightq(p; label=question, correct_answer=correct_answer)
```

!!! note
    The use of `PlotlyLight` graphics works with `Weave` and `Pluto`, but is unusable from `quarto` and `Documenter`.

"""
function plotlylightq(p, xs=(-Inf, Inf), ys=(-Inf,Inf);
                  label = "", hint="", explanation="",
                  correct_answer=nothing)
    PlotlyLightQ(p, xs, ys, label, hint, explanation, correct_answer)
end

## -----

struct Scorecard <: Question
    values
    ONCOMPLETION::Bool
    NOT_COMPLETED_MSG
end

"""
    scorecard(values; oncompletion::Bool=false, not_completed_msg::String="")

Add a scorecard

* `values` is a collection of pairs, `interval => message`. See below. The default summarizes the number of correct of the number of questions attempted and the total number of questions.

* The `oncompletion` flag can be set to only show the message if all the questions have been attempted. When set, and not all questions have been attempted, the `not_completed_msg` message is shown.

The interval is specified as `(l,r)`, with `0 <= l < r <= 100`, or *optionally* as `(l,r,interval_type)` where `interval_type`, a string, is one of `"[]"`, `"[)"`,`"(]"`, or `"()"`. The default interval type is `"[)"` unless `r` is `100`, in which case it is `"[]"`.

The message is shown when the percent correct is in the interval. The following values are substituted, when present:

- `{{:total_questions}}` - the number of total questions
- `{{:correct}}` - the number of correct answers
- `{{:attempted}}` - the number of attempted questions
- `{{:total_attempts}}` -- the number of attempts.

The message may have Markdown formatting.


Example
```
vals = [(0,99)=>"Keep trying",
          (99, 100) => "You got {{:correct}} **correct** of {{:total_questions}} total *questions*"]
scorecard(vals)
```

!!! note:
    Does not work with Pluto.
"""
function scorecard(values=[(0,99) =>
                           "You have {{:correct}} *correct* in {{:attempted}} *attempted* questions. There are {{:total_questions}} total questions to try.",
                           (99,100) => "You have {{:correct}} *correct* of the {{:total_questions}} total questions to try.",
                           ];
                   oncompletion::Bool=false,
                   not_completed_msg::String = "")

    function _tohtml(txt)
        txt = _markdown_to_html(txt)
        txt = replace(txt, "&#123;" => "{") # replace
        txt = replace(txt, "&#125;" => "}")
        txt = chomp(txt)
        txt
    end

    NOT_COMPLETED_MSG = oncompletion ? not_completed_msg : ""
    Scorecard(
        [first(pair) => _tohtml(pair[end]) for pair ∈ values],
        oncompletion,
        chomp(_markdown_to_html(NOT_COMPLETED_MSG))
    )

end
