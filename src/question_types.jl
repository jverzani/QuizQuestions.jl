abstract type Question end

mutable struct Stringq <: Question
    re::Regex
    label
    hint
    explanation
    placeholder
end

"""
    stringq(re::Regex; label="", hint="", explanation="")

Match string answer with regular expression

Arguments:

* `re`: a regular expression for grading
* `label`: optional label for the form element
* `hint`: optional plain-text hint that can be seen on hover
* `placeholder`: text shown when input widget is initially drawn
"""
stringq(re::Regex; label="", hint="", explanation="",  placeholder=nothing) =
    Stringq(re, label, hint, explanation, placeholder)


##
mutable struct Numericq <: Question
    val
    tol
    units
    label
    hint
    explanation
    placeholder
end

"""
    numericq(value, tol=1e-3; label="", hint="", units="", explanation="", placeholder=nothing)

Match a numeric answer

Arguments:

* `value`: the numeric answer
* `tol`: ``|answer - value| \\le tol`` is used to determine correctness
* `label`: optional label for the form element
* `hint`: optional plain-text hint that can be seen on hover
* `units`: a string indicating expected units.
* `placeholder`: text shown when input widget is initially drawn

"""
function numericq(val, tol=1e-3, args...;
                  label="",
                  hint="", units::AbstractString="",
                  explanation="",
                  placeholder=nothing)

    Numericq(val, tol,  units, label, hint, explanation, placeholder)
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

* `keep_order::Boolean`: if `true` keeps display order of choices, otherwise they are shuffled.

* `inline::Bool`: hint to render inline (or not) if supported

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

Example:

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
    explanation
    label
    hint
end

"""
    buttonq(choices, answer; label="", hint="")

Use buttons for multiple choice (one of many). Show answer after first click.

Arguments:

* `choices`: indexable collection of choices. As seen in the example, choices can be formatted with markdown.

* `answer::Int`: index of correct choice

* `explanation`: text to display on a wrong selection

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

Example:

```
choices = ["beta", raw"``\\beta``", "`beta`"]
answer = 2
explanation = "The other two answers are not a symbol, but a name"
buttonq(choices, answer; label="Which is the Greek symbol?", explanation=explanation)
```

!!! note
    The button questions do not work well with `Pluto`.
"""
function buttonq(choices, answer::Integer;
                 explanation="",
                 label="", hint="")
    answers = [i == answer ? "correct" : "incorrect" for i ∈ eachindex(choices)]
    Buttonq(choices, answers, explanation, label, hint)
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

* `keep_order::Boolean`: if `true` keeps display order of choices, otherwise they are shuffled.

* `inline::Bool`: hint to render inline (or not) if supported

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

Example:

```
choices = ["pear", "tomato", "banana"]
answers = [1,3]
multiplecq(choices, answers; hint="not the red one!")
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

* `questions`: Indexable collection of questions.

* `choices`: indexable collection of choices for each question. As seen in the example, choices can be formatted with markdown.

* `answers`: collection of correct indices for each question.

* `d`: As an alternative, a dictionary of questions and answers can be specified. The choices will be taken from the values then randomized, the answers will be computed.

* `label`: optional label for the form element

* `hint`: optional plain-text hint that can be seen on hover

## Examples:

```
questions = ("Select a Volvo", "Select a Mercedes", "Select an Audi")
choices = ("XC90", "A4", "GLE 350", "X1") # may be more than questions
answer = (1,3,2) # indices of correct
matchq(questions, choices, answer)

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
    booleanq(ans; [label, hint])
True of false questions:

Example:

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
    yesnoq(ans)

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
    tol
    label
    hint
    explanation
    placeholder
end


"""
    fillblankq(question answer::Regex; label="", hint="", placeholder=nothing)
    fillblankq(question, choices, answer; label="", hint="", keep_order=false)
    fillblankq(question, val, tol=0; label="", hint="", placeholder=nothing)

Present a fill-in-the-blank question where the blank can be a selection, a number, or a string graded by a regular expression.

* `question`: A string. Use `____` (4 or more under scores) to indicate the blank

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

fillblankq(question, val::Real, tol=0; label="", hint="", explanation="",
           placeholder=nothing) =
    FillBlankNumericQ(question, val, tol, label, hint, explanation, placeholder)

## ------

mutable struct HotspotQ <: Question
    imgfile
    xy
    ΔxΔy
    label
    hint
    explanation
    correct_answer
end

"""
    hotspotq(imagefile, xy, ΔxΔy; label="", hint="", explanation="",
        correct_answer=nothing)

Question type to check if user clicks in a specified region of an image.

* `imgfile`: file of an image
* `xy`: tuple of ``(x,y)`` coordinates in ``[0,1] × [0,1]`` relative to lower left corner
* `ΔxΔy`: tuple of ``(w,h)`` coordinates used to describe rectangular region of the figure
* `correct_answer`: a text snippet of javascript which can be specified to add more complicated logic to test if an answer is correct. It must use `x` and `y` for the coordinates of the click.

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
hotspotq(imgfile, (0,0), (1/2, 1/2), label="What best matches the graph of ``f(x) = -x^4``?")
```

!!! note
    The display of the image is not adjusted by this question type and must
    be managed separately.

"""
function hotspotq(imgfile, xy, ΔxΔy;
                  label = "", hint="", explanation="",
                  correct_answer=nothing)
    HotspotQ(imgfile, xy, ΔxΔy, label, hint, explanation, correct_answer)
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

Display a `PlotlyLight` graph. By default, correct answers select a value on the graph with `x` in the range specified by `xs` and `y` in the range specified by `ys`.

* `xs`: specifies interval for selected pont `[x₀,x₁]`, defaults = `(-Inf,Inf)`
* `ys`: range `[y₀,y₁]`
* `correct_answer`: when speficied, allows more advanced notions of correct. This is a JavaScript code snippet with `x` and `y` representing the point on the graph that is clicked on.

## Examples

```
using PlotlyLight # not loaded by default
xs = range(0, 2pi, length=100)
ys = sin.(xs)
p = Plot(Config(x=xs, y=ys))
plotlylightq(p, (3,Inf); label="Click a value with ``x>3``")
```

An example where the default grading script needs modification. Note also, the `x`, `y` values refer to the *first* graph. (One could modify their definition in `correct answer`; they are found through `x=e.points[0].x`, `y=e.points[0].y`.)

```
xs = range(0, 2pi, length=100)
ys = sin.(xs)
p = Plot(Config(x=xs, y=ys))
push!(p.data, Config(x=xs, y=cos.(xs)));
question = "Click a value where `sin(x)` is increasing"
# evalute pi/2 as no pi in JavaScript, also Inf -> Infinity
correct_answer = "((x >= 0 && x <= $(pi/2)) || (x >= $(3pi/2) && x <= $(2pi)))"
plotlylightq(p, (3,Inf); label=question, correct_answer=correct_answer)
```

!!! note
    The use of `PlotlyLight` graphics works with `Weave`, but is unusable from `Documenter`.

"""
function plotlylightq(p, xs=(-Inf, Inf), ys=(-Inf,Inf);
                  label = "", hint="", explanation="",
                  correct_answer=nothing)
    PlotlyLightQ(p, xs, ys, label, hint, explanation, correct_answer)
end
