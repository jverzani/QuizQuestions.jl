abstract type Question end

mutable struct Stringq <: Question
    re::Regex
    label
    hint
end

"""
    stringq(re::Regex; label="", hint="")

Match string answer with regular expression

Arguments:

* `re`: a regular expression for grading
* `label`: optional label for the form element
* `hint`: optional plain-text hint that can be seen on hover

"""
stringq(re::Regex; label="", hint="") = Stringq(re, label, hint)


##
mutable struct Numericq <: Question
    val
    tol
    units
    label
    hint
end

"""
    numericq(value, tol=1e-3; label="", hint="", units="")

Match a numeric answer

Arguments:

* `value`: the numeric answer
* `tol`: ``|answer - value| \\le tol`` is used to determine correctness
* `label`: optional label for the form element
* `hint`: optional plain-text hint that can be seen on hover
* `units`: a string indicating expected units.

"""
function numericq(val, tol=1e-3, args...;
                  label="",
                  hint="", units::AbstractString="")

    Numericq(val, tol,  units, label, hint)
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
    inline
end

"""
    radioq(choices, answer; label="", hint="", keep_order=false)

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
                label="", hint="", inline::Bool=(hint!=""),
                keep_order::Bool=false)
    inds = collect(1:length(choices))
    values = copy(inds)
    labels = choices
    !keep_order && shuffle!(inds)

    Radioq(choices[inds], findfirst(isequal(answer), inds),
           values, labels[inds], label, hint, inline)
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
    inline
end

"""
    multiq(choices, answers; label="", hint="", keep_order=false)

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
                label="", hint="", inline::Bool=(hint!=""),
                keep_order::Bool=false)
    inds = collect(1:length(choices))
    values = copy(inds)
    labels = choices
    !keep_order && shuffle!(inds)

    Multiq(choices[inds], findall(in(answers), inds),
           values, labels[inds], label, hint, inline)
end

##
mutable struct Matchq <: Question
    questions
    choices
    answer
    label
    hint
end

"""
    matchq(questions, choices, answers; label="", hint="")
    matchq(d::Dictionary; label="", hint="")

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
                label="", hint="")

    @assert length(questions) == length(answers)

    Matchq(questions, choices, answers,
           label, hint)
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
                  label="", hint::AbstractString="",
                  inline::Bool=true)
    choices = labels[1:2]
    ans = 2 - ans
    radioq(choices, ans;
           label=label, hint=hint, inline=inline, keep_order=true)
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
