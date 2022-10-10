## text/latex
## These work within `Quarto` to produce pdf files

# return string or nothing
function _label(x)
   !(:label ∈ fieldnames(typeof(x))) && return nothing
    label = x.label
    length(label) > 0 ? label : nothing
end

function _hint(x)
   !(:hint ∈ fieldnames(typeof(x))) && return nothing
    hint = x.hint
    length(hint) > 0 ? label : nothing
end



# function _show_latex_label(io, m, x)
#     # show label
#     if :label ∈ fieldnames(typeof(x))
#         label = x.label
#         if length(label) > 0
#             show(io, m, Markdown.parse(label))
#         end
#     end
# end

function Base.show(io::IO, m::MIME"text/latex", x::Question)
    label = _label(x)
    label !== nothing && show(io, m, Markdown.parse(label))
    _show_latex(io, m, x)
    hint = _hint(x)
    if hint !== nothing
        show(io, m, Markdown.parse("*Hint: "))
        show(io, m, Markdown.parse(hint))
    end
end

## helpers
function _show_latex(io::IO,  m::MIME"text/latex", x::Question)
    print(io, "\\vspace{18pt}")
    nothing
end

const LATEXBOX = raw"${\quad\Box}$ "
function _show_latex(io::IO,  m::MIME"text/latex", x::Union{Radioq, Buttonq})
    for l ∈ x.labels
        print(io, LATEXBOX)
        show(io, m, Markdown.parse(l))
    end
end

function _show_latex(io::IO,  m::MIME"text/latex", x::Union{Multiq, MultiButtonq})

    for l ∈ x.labels
        print(io, LATEXBOX)
        show(io, m, Markdown.parse(l))
    end
    println(io, Markdown.latex(Markdown.parse("(*Select one or more*)")))

end

function _show_latex(io::IO,  m::MIME"text/latex", x::Matchq)
    qs = x.questions
    cs = x.choices
    for q ∈ qs
        show(io, m, Markdown.parse(q))
        for c ∈ cs
            print(io, LATEXBOX)
            show(io, m , Markdown.parse(c))
        end
        println(io, Markdown.latex(Markdown.parse("(*Select an answer*)")))

    end
end

function _show_latex(io::IO,  m::MIME"text/latex", x::FillBlankQ)
    q = x.question
    q = replace(q, r"_{4,}"=>raw"``\rule{2.54cm}{0.15mm}``")
    print(io, Markdown.latex(Markdown.parse(q)))
end

function _show_latex(io::IO,  m::MIME"text/latex", x::HotspotQ)
    println(io, "insert image here")
end

function _show_latex(io::IO,  m::MIME"text/latex", x::PlotlyLightQ)
    println(io, "insert image here")
end
