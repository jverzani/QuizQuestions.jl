function Base.show(io::IO, m::MIME"text/html", x::Numericq)
    ID = randstring()
    Mustache.render(io, html_templates["Numericq"],
                    Dict("ID" => ID,
                         "TYPE" => "numeric",
                         "selector" => "#" * ID,
                         "status" => "",
                         "hint" => x.hint,
                         "units" => x.units,
                         "correct" => "Math.abs(this.value - $(x.val)) <= $(x.tol)"
                         ))

end


function Base.show(io::IO, m::MIME"text/html", x::Stringq)

    ID = randstring()

    form_tpl = html_templates["Stringq_form"]
    FORM = Mustache.render(form_tpl, ID=ID)

    tpl = html_templates["input_form_tpl"]

    Mustache.render(io, tpl,
                    Dict("ID" => ID,
                         "TYPE" => "text",
                         "selector" => "#" * ID,
                         "status" => "",
                         "form" => "",
                         "hint" => x.hint,
                         "INPUT_FORM" => FORM,
                         "correct" => """RegExp('$(x.re.pattern)').test(this.value)"""
                         )
                    )

end


function _markdown_to_html(x)
    length(x) == 0 && return("")
    x = Markdown.parse(x)
    x = sprint(io -> Markdown.html(io, x))
    return x
end

function _make_item(i, choice)
    choice′ = sprint(io -> Markdown.html(io, Markdown.parse(choice)))
    # strip <p> tag
    choice′ = chomp(choice′)
    choice′ = replace(choice′, r"^<p>" => "")
    choice′ = replace(choice′, r"</p>$" => "")


    item = Dict("no"=>i,
                "label"=> choice′,
                "value"=>i
                )
end



function Base.show(io::IO, m::MIME"text/html", x::Radioq)

    ID = randstring()

    tpl = html_templates["Radioq"]
    choices = string.(x.choices)
    items = Dict[]

    ## make items
    items = [_make_item(i, choice) for (i,choice) ∈ enumerate(choices)]

    script = Mustache.render(html_templates["radio_script_tpl"],
                             Dict("ID"=>ID,
                                  "correct_answer" => x.answer,
                                  "selector" => "input:radio[name='radio_$ID']",
                                  "correct" => "this.value == $(x.answer)"))

    form = Mustache.render(tpl, Dict("ID"=>ID, "items"=>items,
                                     "inline" => x.inline ? " inline" : ""
                                     ))

    Mustache.render(io, html_templates["question_tpl"],
                    Dict("form" => form,
                         "script" => script,
                         "TYPE" => "radio",
                         "ID" => ID,
                         "hint"=> _markdown_to_html(x.hint)))

end
