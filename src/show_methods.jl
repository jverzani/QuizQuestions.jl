# This is called when converting radio button labels from LaTeX
# adjust by setting ENV["QQ_LaTeX_delimiters"]
function Markdown.tohtml(io::IO, l::Markdown.LaTeX)
    o, c = get(ENV, "QQ_LaTeX_delimiters", ("\\(", "\\)"))
    print(io, o) # not print(io, '$', '$')
    print(io, l.formula)
    print(io, c)
    # works with KaTeX -- but not weave
    # println(io, raw"""<span class="math inline">""") #\\\\(")
    # println(io, l.formula)
    # println(io, raw"</span>") #\\\\)")
end


# show method for html output of question types
function _markdown_to_html(x)
    length(x) == 0 && return("")
    x = Markdown.parse(x)
    x = sprint(io -> Markdown.html(io, x))
    x = replace(x, r"^<p>"=>"", r"</p>$"=>"")
    return x
end

function Base.show(io::IO, m::MIME"text/html", x::Question)
    ID = randstring()

    FORM, GRADING_SCRIPT = prepare_question(x, ID)

    Mustache.render(io, html_templates["question_tpl"];
                    ID = ID,
                    STATUS = "",
                    LABEL=_markdown_to_html(x.label),
                    HINT = length(x.label) > 0 ? x.hint : "",
                    EXPLANATION = _markdown_to_html(x.explanation),
                    FORM = FORM,
                    GRADING_SCRIPT = GRADING_SCRIPT
                    )
end

function prepare_question(x::Numericq, ID)

    FORM = Mustache.render(html_templates["inputq_form"];
                           ID=ID,
                           PLACEHOLDER = isnothing(x.placeholder) ? "Numeric answer" : x.placeholder,
                           UNITS=x.units,
                           TYPE="number",
                           HINT = length(x.label) == 0 ? x.hint : ""
                           )


    GRADING_SCRIPT =
        Mustache.render(html_templates["input_grading_script"];
                        ID = ID,
                        CORRECT_ANSWER = "(Math.abs(this.value - $(x.val)) <= $(x.atol))",
                        INCORRECT = "Incorrect",
                        CORRECT = "Correct"
                        )
    (FORM, GRADING_SCRIPT)
end


function prepare_question(x::Stringq, ID)

    FORM = Mustache.render(html_templates["inputq_form"];
                           ID=ID,
                           PLACEHOLDER = isnothing(x.placeholder) ? "Text answer" : x.placeholder,
                           TYPE="text",
                           HINT = length(x.label) == 0 ? x.hint : ""
                           )

    GRADING_SCRIPT =
        Mustache.render(html_templates["input_grading_script"];
                        ID = ID,
                        CORRECT_ANSWER = """RegExp('$(x.re.pattern)').test(this.value)""",
                        INCORRECT = "Incorrect",
                        CORRECT = "Correct"
                        )
    (FORM, GRADING_SCRIPT)

end


function _make_item(i, choice)
    choice′ = sprint(io -> Markdown.html(io, Markdown.parse(choice)))
    # strip <p> tag
    choice′ = chomp(choice′)
    choice′ = replace(choice′, r"^<p>" => "")
    choice′ = replace(choice′, r"</p>$" => "")

    return (NO=i, LABEL=choice′, VALUE=i)
end



function prepare_question(x::Radioq, ID)
    choices = string.(x.choices)
    items = [_make_item(i, choice) for (i,choice) ∈ enumerate(choices)]

    GRADING_SCRIPT = Mustache.render(html_templates["radio_grading_script"];
                             ID = ID,
                                     CORRECT_ANSWER = x.answer,
                                     INCORRECT = "Incorrect",
                                     CORRECT = "Correct"
                                     )
    FORM = Mustache.render(html_templates["Radioq"];
                           ID = ID,
                           ITEMS = items,
                           INLINE = x.inline ? " inline" : ""
                           )

    (FORM, GRADING_SCRIPT)

end

function prepare_question(x::Buttonq, ID)

    n = length(x.choices)
    choices = _markdown_to_html.(x.choices)
    buttons = [(i=i, TEXT=_markdown_to_html(x.choices[i]), ANSWER=x.answer[i]) for i ∈ 1:n]


    GRADING_SCRIPT = nothing
    FORM = Mustache.render(html_templates["Buttonq"];
                           ID = ID,
                           BUTTONS = buttons,
                           GREEN = x.colors.GREEN,
                           RED = x.colors.RED,
                           BLUE = x.colors.BLUE,
                           CORRECT = "✓",
                           INCORRECT="⨉"
                           )
    (FORM, GRADING_SCRIPT)

end

function prepare_question(x::Multiq, ID)

    choices = string.(x.choices)
    items = [_make_item(i, choice) for (i,choice) ∈ enumerate(choices)]

    GRADING_SCRIPT = Mustache.render(html_templates["multi_grading_script"];
                                     ID = ID,
                                     CORRECT_ANSWER = x.answer,
                                     INCORRECT = "Not yet",
                                     CORRECT = "Correct",
                             )
    FORM = Mustache.render(html_templates["Multiq"];
                           ID = ID,
                           ITEMS = items,
                           INLINE = x.inline ? " inline" : ""
                           )
    (FORM, GRADING_SCRIPT)

end

function prepare_question(x::MultiButtonq, ID)

    n = length(x.choices)
    choices = _markdown_to_html.(x.choices)
    buttons = [(i=i, TEXT=_markdown_to_html(x.choices[i])) for i ∈ 1:n]
    BLUE = "#0033CC11"

    GRADING_SCRIPT = Mustache.render(html_templates["multi_button_grading_script"];
                                     ID = ID,
                                     CORRECT_ANSWER = length(x.answer) > 0 ? x.answer : "[]",
                                     SELECTED_COLOR = BLUE,
                                     INCORRECT = "Something isn't correct",
                                     CORRECT = "Correct",
                                     CORRECT_flag = "✓ ",
                                     INCORRECT_flag ="⨉ "

                                     )

    FORM = Mustache.render(html_templates["MultiButtonq"];
                           ID = ID,
                           BUTTONS = buttons,
                           )
    (FORM, GRADING_SCRIPT)

end

function prepare_question(x::Matchq, ID)

    BLANK = "Choose..."
    ANSWER_CHOICES = [(INDEX=i, LABEL=_markdown_to_html(label)) for (i, label) in enumerate(x.choices)]
    items = [(ID=ID, NO=i, BLANK=BLANK,  QUESTION=_markdown_to_html(question), ANSWER_CHOICES=ANSWER_CHOICES) for (i,question) ∈ enumerate(x.questions)]
    GRADING_SCRIPT = Mustache.render(html_templates["matchq_grading_script"];
                                     ID = ID,
                                     CORRECT_ANSWER = collect(string.(x.answer)),
                                     INCORRECT = "Not yet",
                                     CORRECT = "Correct",
                                     )
    FORM = Mustache.render(html_templates["Matchq"];
                           ID = ID,
                           ITEMS = items,

                           )
    (FORM, GRADING_SCRIPT)
end


## ----
## blank creates BLANK, GRADING_SCRIPT
function blank(x::FillBlankChoiceQ, ID)
    _blank = "Choose..."

    ANSWER_CHOICES = [(INDEX=i, LABEL=_markdown_to_html(choice)) for
                      (i,choice) ∈ enumerate(x.choices)]
    BLANK = Mustache.render(html_templates["fill_in_blank_select"],
                            ID = ID,
                            BLANK=_blank,
                            ANSWER_CHOICES = ANSWER_CHOICES)

    GRADING_SCRIPT = Mustache.render(html_templates["matchq_grading_script"];
                                     ID = ID,
                                     CORRECT_ANSWER = collect(string.(x.answer)),
                                     INCORRECT = "Not yet",
                                     CORRECT = "Correct",
                                     )
    (BLANK, GRADING_SCRIPT)
end

function blank(x::FillBlankStringQ, ID)
    PLACEHOLDER = isnothing(x.placeholder) ? "answer here..." : x.placeholder
    BLANK = Mustache.render(html_templates["fill_in_blank_input"],
                            ID = ID,
                            TYPE="text",
                            PLACEHOLDER=PLACEHOLDER)

    GRADING_SCRIPT =
        Mustache.render(html_templates["input_grading_script"];
                        ID = ID,
                        CORRECT_ANSWER = """RegExp('$(x.re.pattern)').test(this.value)""",
                        INCORRECT = "Incorrect",
                        CORRECT = "Correct"
                        )
        (BLANK, GRADING_SCRIPT)
end

function blank(x::FillBlankNumericQ, ID)
    PLACEHOLDER = isnothing(x.placeholder) ? "answer here..." : x.placeholder
    BLANK = Mustache.render(html_templates["fill_in_blank_input"],
                            ID = ID,
                            TYPE="number",
                            PLACEHOLDER=PLACEHOLDER)
    GRADING_SCRIPT =
        Mustache.render(html_templates["input_grading_script"];
                        ID = ID,
                        CORRECT_ANSWER = "(Math.abs(this.value - $(x.val)) <= $(x.atol))",
                        INCORRECT = "Incorrect",
                        CORRECT = "Correct"
                        )
        (BLANK, GRADING_SCRIPT)
end



function prepare_question(x::FillBlankQ, ID)

    BLANK, GRADING_SCRIPT = blank(x, ID)

    question = _markdown_to_html(x.question)
    question = replace(question, r"_{4,}" => "{{{:BLANK}}}")
    FORM = Mustache.render(question; BLANK=BLANK)

    (FORM, GRADING_SCRIPT)
end

## ----
function prepare_question(x::HotspotQ, ID)

    x₀,x₁ = extrema(x.xs)
    y₀,y₁ = extrema(x.ys)

    CORRECT_ANSWER = isnothing(x.correct_answer) ?
        "(x >= $(x₀) && x <= $(x₁) && y >= $(y₀) && y <= $(y₁));" :
        x.correct_answer

    GRADING_SCRIPT =
        Mustache.render(html_templates["hotspot_grading_script"];
                        ID = ID,
                        CORRECT_ANSWER = CORRECT_ANSWER,
                        INCORRECT = "Incorrect",
                        CORRECT = "Correct"
                        )


    IMG = base64encode(read(x.imgfile, String))
    FORM = Mustache.render(html_templates["hotspot"]; ID=ID, IMG=IMG)

    (FORM, GRADING_SCRIPT)
end

handle_inf(x) = x == Inf ? "Infinity" : x == -Inf ? "-Infinity" : x
function prepare_question(x::PlotlyLightQ, ID)
    p = x.p
    p.id = ID

    x₀, x₁ = handle_inf.(x.xs)
    y₀, y₁ = handle_inf.(x.ys)
    CORRECT_ANSWER = isnothing(x.correct_answer) ?
        "(x >= $(x₀) && x <= $(x₁) && y >= $(y₀) && y <= $(y₁));" :
        x.correct_answer


    GRADING_SCRIPT =
        Mustache.render(html_templates["plotlylight_grading_script"];
                        ID = ID,
                        CORRECT_ANSWER = CORRECT_ANSWER,
                        INCORRECT = "Incorrect",
                        CORRECT = "Correct"
                        )

    FORM = sprint(io -> show(io, "text/html", p))
    FORM = "<script>window.PlotlyConfig = {MathJaxConfig: 'local'};</script>\n" * FORM

    (FORM, GRADING_SCRIPT)
end
