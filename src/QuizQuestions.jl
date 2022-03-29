module QuizQuestions

using Markdown
using Mustache
using Random

include("question_types.jl")
include("html_templates.jl")
include("show_methods.jl")

export numericq, radioq, multiq, booleanq, yesnoq, stringq

end
