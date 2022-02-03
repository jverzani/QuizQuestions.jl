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
