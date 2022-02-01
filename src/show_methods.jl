# show method for html output of question types
function _markdown_to_html(x)
    length(x) == 0 && return("")
    x = Markdown.parse(x)
    x = sprint(io -> Markdown.html(io, x))
    return x
end

function Base.show(io::IO, m::MIME"text/html", x::Numericq)

    ID = randstring()

    FORM = Mustache.render(html_templates["Numericq_form"];
                           ID=ID,
                           PLACEHOLDER = "Numeric answer",
                           UNITS=x.units)

    GRADING_SCRIPT =
        Mustache.render(html_templates["input_grading_script"];
                        ID = ID,
                        CORRECT = "Math.abs(this.value - $(x.val)) <= $(x.tol)"
                        )

    Mustache.render(io,
                    html_templates["question_tpl"];
                    ID = ID,
                    TYPE = "text",
                    STATUS = "",
                    LABEL=_markdown_to_html(x.label),
                    FORM = FORM,
                    GRADING_SCRIPT = GRADING_SCRIPT,
                    HINT = x.hint,
                    )

end


function Base.show(io::IO, m::MIME"text/html", x::Stringq)

    ID = randstring()

    FORM = Mustache.render(html_templates["Stringq_form"];
                           ID=ID,
                           PLACEHOLDER = "Text answer")

    GRADING_SCRIPT =
        Mustache.render(html_templates["input_grading_script"];
                        ID = ID,
                        CORRECT = """RegExp('$(x.re.pattern)').test(this.value)"""
                        )

    Mustache.render(io, html_templates["question_tpl"];
                    ID = ID,
                    TYPE = "text",
                    STATUS = "",
                    LABEL=_markdown_to_html(x.label),
                    FORM = FORM,
                    GRADING_SCRIPT = GRADING_SCRIPT,
                    HINT = x.hint
                    )

end


function _make_item(i, choice)
    choice′ = sprint(io -> Markdown.html(io, Markdown.parse(choice)))
    # strip <p> tag
    choice′ = chomp(choice′)
    choice′ = replace(choice′, r"^<p>" => "")
    choice′ = replace(choice′, r"</p>$" => "")

    return (NO=i, LABEL=choice′, VALUE=i)
end



function Base.show(io::IO, m::MIME"text/html", x::Radioq)

    ID = randstring()

    choices = string.(x.choices)
    items = [_make_item(i, choice) for (i,choice) ∈ enumerate(choices)]

    GRADING_SCRIPT = Mustache.render(html_templates["radio_grading_script"];
                             ID = ID,
                             CORRECT_ANSWER = x.answer
                             )
    FORM = Mustache.render(html_templates["Radioq"];
                           ID = ID,
                           ITEMS = items,
                           INLINE = x.inline ? " inline" : ""
                           )

    Mustache.render(io, html_templates["question_tpl"],
                    ID = ID,
                    TYPE = "radio",
                    FORM = FORM,
                    GRADING_SCRIPT = GRADING_SCRIPT,
                    LABEL=_markdown_to_html(x.label),
                    HINT = x.hint
                    )

end
