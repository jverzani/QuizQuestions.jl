abstract type Question end


mutable struct Stringq <: Question
    re::Regex
    reminder
    hint
end

"""
    stringq(re::Regex, args..; kwargs...)

Match string answer with regular expression
"""
function stringq(re::Regex,
                 reminder="";
                 hint="")
    Stringq(re,reminder, hint)
end



##
mutable struct Numericq <: Question
    val
    tol
    reminder
    answer_text
    m
    M
    units
    hint
end

function numericq(val, tol=1e-3, reminder="", args...;
                  hint="", units::AbstractString="")

    answer_text= "[$(round(val-tol,digits=5)), $(round(val+tol,digits=5))]"
    Numericq(val, tol, reminder, answer_text, val-tol, val+tol, units, hint)
end

numericq(val::Int; kwargs...) = numericq(val, 0; kwargs...)



##
mutable struct Radioq <: Question
    choices
    answer
    reminder
    answer_text
    values
    labels
    hint
    inline
end

"""
    radioq(choices, ans, args...; kwargs...)

Multiple choice question (one of several)

Arguments:

* `choices`: vector of choices.

* `answer`: index of correct choice

* `inline::Bool`: hint to render inline (or not) if supported

Example
```
radioq(["beta", L"\beta", "`beta`"], 2, "a reminder", hint="which is the Greek symbol")
```
"""
function radioq(choices, answer, reminder="", answer_text=nothing;
                hint="", inline::Bool=(hint!=""),
                keep_order::Bool=false)
    inds = collect(1:length(choices))
    values = copy(inds)
    labels = choices
    !keep_order && shuffle!(inds)

    Radioq(choices[inds], findfirst(isequal(answer), inds), reminder,
           answer_text, values, labels[inds], hint, inline)
end


"""
    booleanq(ans, [reminder])
True of false questions:

Example:

```
booleanq(true, reminder="Does it hurt...")
```

"""
function booleanq(ans::Bool, reminder="", answer_text=nothing;labels::Vector=["true", "false"], hint::AbstractString="", inline::Bool=true)
    choices = labels[1:2]
    ans = 2 - ans
    radioq(choices, ans, reminder, answer_text; hint=hint,
           inline=inline, keep_order=true)
end

"""
    yesnoq(ans)

Boolean question with `yes` or `no` labels.

Examples: `yesnoq("yes")` or `yesnoq(true)`

"""
yesnoq(ans::AbstractString, args...; kwargs...) = radioq(["Yes", "No"], ans == "yes" ? 1 : 2, args...; keep_order=true, kwargs...)
yesnoq(ans::Bool, args...; kwargs...) = yesnoq(ans ? "yes" : "no", args...;kwargs...)
