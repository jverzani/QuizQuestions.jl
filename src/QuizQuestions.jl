module QuizQuestions

using Markdown
using Mustache
using Random
using Base64

include("question_types.jl")
include("html_templates.jl")
include("show_methods.jl")
include("latex_show_methods.jl")

export numericq,
    buttonq, radioq, booleanq, yesnoq,
    multiq,  multibuttonq, matchq,
    stringq, scriptq, fillblankq,
    hotspotq, plotlylightq,
    scorecard

end
