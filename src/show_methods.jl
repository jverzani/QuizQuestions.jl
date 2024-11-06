# This is called when converting radio button labels from LaTeX
# adjust to $ by setting ENV["QQ_LaTeX_dollar_delimiters"] = true
# type piracy is being taken here!!
# Quarto --> ("\\(", "\\)")
# Weave  --> ("\\(", "\\)")
# Documenter -->  ("\$", "\$")
# Pluto --> ?

function Markdown.tohtml(io::IO, l::Markdown.LaTeX)
    dollars = get(ENV, "QQ_LaTeX_dollar_delimiters", "false")
    o,c = dollars == "true" ? ("\$", "\$") : ("\\(", "\\)")
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
    x = replace(x, r"\n<p>"=>" ", r"</p>$"=>" ")
    return x
end

## Show text/html
function Base.show(io::IO, m::MIME"text/html", x::Question)
    # hashing would be more "github friendly" *but*, we might have questions
    # repeated (eg `yesonq(true)`, say). So we use a random string for the ID
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
                           UNITS=_markdown_to_html(x.units),
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
                        CORRECT_ANSWER = """RegExp('$(x.re.pattern)').test(this.value.replaceAll(RegExp('$(x.filter.pattern)', 'g'), ''))""",
                        INCORRECT = "Incorrect",
                        CORRECT = "Correct"
                        )
    (FORM, GRADING_SCRIPT)

end

function prepare_question(x::Scriptq, ID)

    FORM = Mustache.render(html_templates["inputq_form"];
                           ID=ID,
                           PLACEHOLDER = isnothing(x.placeholder) ? "Text answer" : x.placeholder,
                           TYPE="text",
                           HINT = length(x.label) == 0 ? x.hint : ""
                           )

    GRADING_SCRIPT =
        Mustache.render(html_templates["function_grading_script"];
                        ID = ID,
                        FUNCTION = x.funct,
                        INCORRECT = "Incorrect",
                        CORRECT = "Correct"
                        )
    (FORM, GRADING_SCRIPT)

end

function _make_item(i, choice, ID)
    choice′ = sprint(io -> Markdown.html(io, Markdown.parse(choice)))
    # strip <p> tag
    choice′ = chomp(choice′)
    choice′ = replace(choice′, r"^<p>" => "")
    choice′ = replace(choice′, r"</p>$" => "")

    return (NO=i, LABEL=choice′, VALUE=i, ID=ID)
end



function prepare_question(x::Radioq, ID)
    choices = string.(x.choices)
    items = [_make_item(i, choice, ID) for (i,choice) ∈ enumerate(choices)]

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
    buttons = [(i=i, TEXT=_markdown_to_html(x.choices[i]),
                ANSWER=x.answer[i], ID=ID) for i ∈ 1:n]


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
    items = [_make_item(i, choice, ID) for (i,choice) ∈ enumerate(choices)]

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
    buttons = [(i=i, TEXT=_markdown_to_html(x.choices[i]), ID=ID) for i ∈ 1:n]
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
    ANSWER_CHOICES = [(INDEX=i, LABEL=_markdown_to_html(label), ID=ID) for (i, label) in enumerate(x.choices)]
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

    ANSWER_CHOICES = [(INDEX=i, LABEL=_markdown_to_html(choice), ID=ID) for
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
                            INLINE=true,
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
                            INLINE=true,
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
#    p.id = ID

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

    FORM = sprint(io -> show(io, MIME("text/html"), p, id=ID))
    FORM = "<script>window.PlotlyConfig = {MathJaxConfig: 'local'};</script>\n" * FORM

    (FORM, GRADING_SCRIPT)
end


## ---
function Base.show(io::IO, m::MIME"text/html", x::Scorecard)
    tpl = html_templates["scorecard_tpl"]
    which_percent = x.WHICH_PERCENT == :attempted ? "percent_attempted" : "percent_correct"
    ## make javascript conditions
    msg = IOBuffer()

    for (i, pr) ∈ enumerate(x.values)
        I, txt = pr
        if length(I) == 2
            l,r = I
            lbrace, rbrace = (">=", ifelse(r==100, "<=", "<"))
        else
            l,r,braces = I
            braces ∈ ("[]", "[)", "(]", "()") || throw(ArgumentError("""brace specification is incorrect. Use one of "[]", "[)", "(]", "()" """))
            lbrace = ifelse(braces[1:1] == "[", ">=", ">")
            rbrace = ifelse(braces[2:2] == "]", "<=", "<")
        end
        txt = replace(txt, "\"" => "“")
        println(msg, "if ($which_percent $lbrace $l && $which_percent $rbrace $r) {",)
        println(msg, """var txt = `\n$txt\n`;""") # use `` for javascript multiline string
        print(msg, "}")
        print(msg, ifelse(i < length(x.values), " else ", "\n"))
    end

    Mustache.render(io, tpl;
                    MESSAGE=String(take!(msg)),
                    ONCOMPLETION=x.ONCOMPLETION,
                    NOT_COMPLETED_MSG=x.NOT_COMPLETED_MSG,
                    attempted = "{{:attempted}}", # hack
                    total_attempts = "{{:total_attempts}}",
                    correct = "{{:correct}}",
                    total_questions = "{{:total_questions}}"
                    )
end


## ---- text/plain useful with typst conversion via quarto
function Base.show(io::IO, m::MIME"text/plain", q::Question)
    length(q.label) > 0 && show(io, MIME("text/plain"), Markdown.parse(string(q.label)))
    _show_plain(io, m, q)
    println(io, "")
    if length(q.hint) > 0
        print(io, "hint: ")
        show(io, MIME("text/plain"), Markdown.parse(string(q.hint)))
    end
end

function _show_plain(io, m::MIME"text/plain", q::Union{Stringq, Numericq})
    println(io, "")
    println(io, "___________________________________________________")
end

function _show_plain(io, m::MIME"text/plain", q::Union{Scriptq})
    println(io, "Answer below:")
    for _ in 1:6
        println(io, "")
    end
end


function _show_plain(io::IO, m::MIME"text/plain",
                   q::Union{Radioq, Multiq, MultiButtonq})
    for c ∈ q.labels
        print(io, "⃞ ")
        show(io, MIME("text/plain"), Markdown.parse(string(c)))
        println(io, "")
    end
end

function _show_plain(io::IO, m::MIME"text/plain",
                   q::Union{Buttonq})
    for c ∈ q.choices
        print(io, "⃞ ")
        show(io, MIME("text/plain"), Markdown.parse(string(c)))
        println(io, "")
    end
end


function _show_plain(io::IO, m::MIME"text/plain", q::T) where {T <: Union{Matchq}}
    println(io, "Match as appropriate:")
    qs, cs = q.questions, q.choices
    for _ in (length(qs) +1):length(cs)
        push!(qs, "")
    end
    println(io, "A                       B")
    println(io, "-------------------------")
    for (q,c) ∈ zip(qs, cs)
        show(io, MIME("text/plain"), Markdown.parse(string(q)))
        print(io, "\\t")
        show(io, MIME("text/plain"), Markdown.parse(string(c)))
        println(io, "")
    end
end


function _show_plain(io::IO, m::MIME"text/plain", q::T) where {T <: FillBlankQ}
    println(io, q.question)
end

function _show_plain(io::IO, m::MIME"text/plain", q::T) where {T <: Union{FillBlankChoiceQ}}
    println(io, q.question)
    println(io, "Choose one:")
        for c ∈ q.choices
        print(io, "⃞ ")
        show(io, MIME("text/plain"), Markdown.parse(string(c)))
        println(io, "")
    end
end

function _show_plain(io::IO, m::MIME"text/plain", q::T) where {T <: Union{HotspotQ, PlotlyLightQ}}
    println(io, "⚠⚠⚠ Unable to display in text output ⚠⚠⚠")
end

function Base.show(io::IO, m::MIME"text/plain", q::Scorecard)
    nothing
end
