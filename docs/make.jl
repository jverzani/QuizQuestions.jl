using Documenter
using QuizQuestions

ENV["QQ_LaTeX_dollar_delimiters"] = true

makedocs(sitename="QuizQuestions documentation",
         format = Documenter.HTML(ansicolor=true)
         )
# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/jverzani/QuizQuestions.jl.git",
    devbranch = "main"
)
