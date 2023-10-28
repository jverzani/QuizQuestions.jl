var documenterSearchIndex = {"docs":
[{"location":"#QuizQuestions","page":"QuizQuestions","title":"QuizQuestions","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"QuizQuestions allows the inclusion of self-grading quiz questions within a Documenter, Weave, quarto,  or Pluto HTML page.","category":"page"},{"location":"#Basics","page":"QuizQuestions","title":"Basics","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The basic idea is:","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"load the package:","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"using QuizQuestions\nusing LaTeXStrings # helper for using math notation","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"create a question with Julia code:","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"choices = [\"one\", L\"2\", L\"\\sqrt{9}\"]\nquestion = \"Which is largest?\"\nanswer = 3\nradioq(choices, answer; label=question, hint=\"A hint\")","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"repeat as desired.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The quizzes are written in markdown with the questions in Julia blocks. The above code cells would be enclosed in triple-backtick blocks and would typically have their contents hidden from the user. How this is done varies between Documenter, Weave, quarto, and Pluto. The examples directory shows examples of each.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"For each question:","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The show method of the object for the text/html mime type inserts the necessary HTML and JavaScript code to show the input widget and grading logic.\nthe optional hint argument allows a text-only hint available to the user on hover.\nThe optional label argument is used to flag the question.\nThe optional explanation argument is used to give feedback to the user in case there is an incorrect answer given.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"For example, the question can be asked in the body of the document (the position of any hint will be different):","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"answer = sqrt(2)\ntol = 1e-3\nnumericq(answer, tol,\n    label=L\"What is $\\sqrt{2}$?\",\n\thint=\"you need to be within 1/1000\")","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"note: Using Documenter adjustment\nMath  markup using LaTeX in Markdown may be done with different delimiters. There are paired dollar signs (or double dollar signs); paired  \\( and \\) (or \\[, \\])  delimiters; double backticks (which require no escaping); or even math flavors for triple backtick blocks. When displaying LaTeX in HTML, the paired parentheses are used. However with Documenter paired dollar signs are needed for markup used by QuizQuestions. As of v\"0.3.21\", placing the line ENV[\"QQ_LaTeX_dollar_delimiters\"] = true in make.jl will instruct that. This package documentation illustrates.","category":"page"},{"location":"#Examples-of-question-types","page":"QuizQuestions","title":"Examples of question types","text":"","category":"section"},{"location":"#Choice-questions-(one-from-many)","page":"QuizQuestions","title":"Choice questions (one from many)","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The radioq question was shown above.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The buttonq question is alternative to radio buttons where the correct answer is shown after the first choice. If this choice is wrong, the explanation is shown along with the correct answer.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"buttonq([L\"1 + 1\", L\"2+2\", L\"-1 + -1\"], 1;\n    label = L\"Which adds to $2$?\",\n\texplanation=\"Add 'em up\")","category":"page"},{"location":"#Multiple-choices-(one-or-more-from-many)","page":"QuizQuestions","title":"Multiple choices (one or more from many)","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"A multiple choice question (one or more from many) can be constructed with multiq:","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"choices =[\n\t\"Four score and seven years ago\",\n\t\"Lorum ipsum\",\n\t\"The quick brown fox jumped over the lazy dog\",\n\t\"One and one and one makes three\"\n]\nanswer = (1, 4)\nmultiq(choices, answer,\n    label=\"Select the sentences with numbers (one or more)\")","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The multibuttonq question is similar, but it uses a \"done\" button to initiate the grading. This allows for answers with 0, 1, or more correct answers.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"choices =[\n\t\"Four score and seven years ago\",\n\t\"Lorum ipsum\",\n\t\"The quick brown fox jumped over the lazy dog\",\n\t\"One and one and one makes three\"\n]\nanswer = (1, 4)\nmultibuttonq(choices, answer,\n    label=\"Select the sentences with numbers (one or more)\")","category":"page"},{"location":"#Numeric-answers","page":"QuizQuestions","title":"Numeric answers","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"Questions with numeric answers use numericq. The question is graded when the input widget loses focus.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"answer = 1 + 1\nnumericq(answer;\n    label=L\"1 + 1?\",\n\thint=\"Do the math\")","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"Numeric questions can have an absolute tolerance set to allow for rounding.","category":"page"},{"location":"#Text-response","page":"QuizQuestions","title":"Text response","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"A question graded by a regular expression can be asked with stringq. The question is graded when the input widget loses focus.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"stringq(r\"^Washington\"; label=\"Who was the first US president?\",\n        placeholder=\"last name\")","category":"page"},{"location":"#Matching","page":"QuizQuestions","title":"Matching","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"A question involving matching can be asked with matchq.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"questions = (\"Select a Volvo\", \"Select a Mercedes\", \"Select an Audi\")\nchoices = (\"XC90\", \"A4\", \"GLE 350\", \"X1\") # may be more than questions\nanswer = (1,3,2) # indices of choices that match correct answer for each question\nmatchq(questions, choices, answer;\n    label=\"For each question, select the correct answer.\")","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The above shows that the number of choices need not match the number of questions. When they do, a dictionary can be used to specify the choices and the answers will be computed:","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"d = Dict(\"Select a Volvo\" => \"XC90\", \"Select a Mercedes\" => \"GLE 350\",\n         \"Select an Audi\" => \"A4\")\nmatchq(d, label=\"Match the manufacture with a model\")","category":"page"},{"location":"#Fill-in-the-blank-questions","page":"QuizQuestions","title":"Fill-in-the-blank questions","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"Fill-in-the blank questions can be asked with fillblankq. Answers can be gathered and graded in different manners.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"question = \"The quick brown fox jumped over the ____ dog\"\nfillblankq(question, (\"lazy\", \"brown\", \"sleeping\"), 1)","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"(like stringq)","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"question = \"The quick brown fox jumped over the ____ dog\"\nfillblankq(question, r\"^lazy$\")","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"(like numericq)","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"question = \"____ `` + 2  = 4``\"\nfillblankq(question, 2)","category":"page"},{"location":"#Select-from-an-image-question","page":"QuizQuestions","title":"Select from an image question","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The hotspotq shows an image, specified by a file, and grades an answer correct if a mouse click is in a specified rectangular region. The region is given in terms of (xmin,xmax) and (ymin, ymax) as if the entire region was in 01 times 01, though the correct_answer argument allows for more complicated regions.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"using Plots\np1 = plot(x -> x^2, axis=nothing, legend=false)\np2 = plot(x -> x^3, axis=nothing, legend=false)\np3 = plot(x -> -x^2, axis=nothing, legend=false)\np4 = plot(x -> -x^3, axis=nothing, legend=false)\nl = @layout [a b; c d]\np = plot(p1, p2, p3, p4, layout=l)\nimgfile = tempname() * \".png\"\nsavefig(p, imgfile)\nhotspotq(imgfile, (0,1/2), (0, 1/2),\n    label=L\"What best matches the graph of $f(x) = -x^4$?\")","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The PlotlyLight package provides a very lightweight interface for producing JavaScript based graphs with the plotly.js library. The plotlylight type allows questions involving an (x,y) selection from a graph ((x,y) is a point on a graph).","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"note: Note\nThe plotlylight question type does not work with Documenter.","category":"page"},{"location":"#Reference","page":"QuizQuestions","title":"Reference","text":"","category":"section"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"The available question types are listed below. If others are desirable, open an issue on the GitHub repository.","category":"page"},{"location":"","page":"QuizQuestions","title":"QuizQuestions","text":"radioq\nbuttonq\nyesnoq\nbooleanq\nmultiq\nmultibuttonq\nmatchq\nnumericq\nstringq\nfillblankq\nhotspotq\nplotlylightq","category":"page"},{"location":"#QuizQuestions.radioq","page":"QuizQuestions","title":"QuizQuestions.radioq","text":"radioq(choices, answer; label=\"\", hint=\"\", explanation=\"\", keep_order=false)\n\nMultiple choice question (one of several)\n\nArguments:\n\nchoices: indexable collection of choices. As seen in the example, choices can be formatted with markdown.\nanswer::Int: index of correct choice\nkeep_order::Boolean: if true keeps display order of choices, otherwise they are shuffled\ninline::Bool: hint to render inline (or not) if supported\nlabel: optional label for the form element\nhint: optional plain-text hint that can be seen on hover\nexplanation: text to display on a wrong selection\n\nExample:\n\nchoices = [\"beta\", raw\"``\\beta``\", \"`beta`\"]\nanswer = 2\nradioq(choices, answer; hint=\"Which is the Greek symbol?\")\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.buttonq","page":"QuizQuestions","title":"QuizQuestions.buttonq","text":"buttonq(choices, answer; label=\"\", hint=\"\", [colors])\n\nUse buttons for multiple choice (one of many). Show answer after first click.\n\nArguments:\n\nchoices: indexable collection of choices. As seen in the example, choices can be formatted with markdown.\nanswer::Int: index of correct choice\nlabel: optional label for the form element\nhint: optional plain-text hint that can be seen on hover\nexplanation: text to display on a wrong selection\n\nExample:\n\nchoices = [\"beta\", raw\"``\\beta``\", \"`beta`\"]\nanswer = 2\nexplanation = \"The other two answers are not a symbol, but a name\"\nbuttonq(choices, answer; label=\"Which is the Greek symbol?\",\n        explanation=explanation)\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.yesnoq","page":"QuizQuestions","title":"QuizQuestions.yesnoq","text":"yesnoq(ans; [label, hint, explanation])\n\nBoolean question with yes or no labels.\n\nExamples:\n\nyesnoq(\"yes\")\nyesnoq(true)\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.booleanq","page":"QuizQuestions","title":"QuizQuestions.booleanq","text":"booleanq(ans; [label, hint, explanation])\n\nTrue of false questions:\n\nExample:\n\nbooleanq(true; label=\"Does it hurt...\")\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.multiq","page":"QuizQuestions","title":"QuizQuestions.multiq","text":"multiq(choices, answers; label=\"\", hint=\"\", explanation=\"\", keep_order=false)\n\nMultiple choice question (one or more of several)\n\nArguments:\n\nchoices: indexable collection of choices. As seen in the example, choices can be formatted with markdown.\nanswers::Vector{Int}: index of correct choice(s)\nkeep_order::Boolean: if true keeps display order of choices, otherwise they are shuffled\ninline::Bool: hint to render inline (or not) if supported\nlabel: optional label for the form element\nhint: optional plain-text hint that can be seen on hover\nexplanation: text to display on a wrong selection\n\nExample\n\nchoices = [\"pear\", \"tomato\", \"banana\"]\nanswers = [1,3]\nmultiq(choices, answers; label=\"yellow foods\", hint=\"not the red one!\")\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.multibuttonq","page":"QuizQuestions","title":"QuizQuestions.multibuttonq","text":"multibuttonq(choices, answers; label=\"\", hint=\"\", explanation=\"\", keep_order=false)\n\nMultiple choice question (zero, one or more of several) using buttons and a \"done\" button to reveal  the answers and whether the user input is correct.\n\nArguments:\n\nchoices: indexable collection of choices. As seen in the example, choices can be formatted with markdown.\nanswers::Vector{Int}: index of correct choice(s)\nkeep_order::Boolean: if true keeps display order of choices, otherwise they are shuffled\ninline::Bool: hint to render inline (or not) if supported\nlabel: optional label for the form element\nhint: optional plain-text hint that can be seen on hover\nexplanation: text to display on a wrong selection\n\nExample\n\nchoices = [\"pear\", \"tomato\", \"banana\"]\nanswers = [1,3]\nmultibuttonq(choices, answers; label=\"yellow foods\", hint=\"not the red one!\")\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.matchq","page":"QuizQuestions","title":"QuizQuestions.matchq","text":"matchq(questions, choices, answers; label=\"\", hint=\"\", explanation=\"\")\nmatchq(d::Dictionary; label=\"\", hint=\"\", explanation=\"\")\n\nUse a drop down to select the right match for each question.\n\nArguments:\n\nquestions: Indexable collection of questions\nchoices: indexable collection of choices for each question. As seen in the example, choices can be formatted with markdown.\nanswers: for each question, the index from choices of the correct answer\nd: As an alternative, a dictionary of questions and answers can be specified. The choices will be taken from the values then randomized, the answers will be computed\nlabel: optional label for the form element\nhint: optional plain-text hint that can be seen on hover\nexplanation: text to display on a wrong selection\n\nExamples\n\nquestions = (\"Select a Volvo\", \"Select a Mercedes\", \"Select an Audi\")\nchoices = (\"XC90\", \"A4\", \"GLE 350\", \"X1\") # may be more than questions\nanswer = (1,3,2) # indices of correct\nmatchq(questions, choices, answer)\n\nThis example uses a dictionary to specify the questions and choices:\n\nd = Dict(\"Select a Volvo\" => \"XC90\", \"Select a Mercedes\" => \"GLE 250\")\nmatchq(d)\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.numericq","page":"QuizQuestions","title":"QuizQuestions.numericq","text":"numericq(value, atol=1e-3; label=\"\", hint=\"\", units=\"\", explanation=\"\", placeholder=nothing)\n\nMatch a numeric answer\n\nArguments:\n\nvalue: the numeric answer\natol: answer - value le atol is used to determine correctness\nlabel: optional label for the form element\nhint: optional plain-text hint that can be seen on hover\nunits: a string indicating expected units\nplaceholder: text shown when input widget is initially drawn\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.stringq","page":"QuizQuestions","title":"QuizQuestions.stringq","text":"stringq(re::Regex; label=\"\", hint=\"\", explanation=\"\", placeholder=\"\")\n\nMatch string answer with regular expression\n\nArguments:\n\nre: a regular expression for grading\nlabel: optional label for the form element\nhint: optional plain-text hint that can be seen on hover\nexplanation: text to display on a wrong selection\nplaceholder: text shown when input widget is initially drawn\n\nExample\n\nre = Regex(\"^abc\")\nstringq(re, label=\"First 3 letters...\")\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.fillblankq","page":"QuizQuestions","title":"QuizQuestions.fillblankq","text":"fillblankq(question answer::Regex; placeholder=nothing, [label, hint, explanation])\nfillblankq(question, choices, answer; keep_order=false,[label, hint, explanation])\nfillblankq(question, val, atol=0; placeholder=nothing, [label, hint, explanation])\n\nPresent a fill-in-the-blank question where the blank can be a selection, a number, or a string graded by a regular expression.\n\nquestion: A string. Use ____ (4 or more under scores) to indicate the blank.\n\nOther rguments from stringq, radioq, and numericq\n\nExamples\n\nquestion = \"The quick brown fox jumped over the ____ dog\"\nfillblankq(question, r\"lazy\")\nfillblankq(question, (\"lazy\", \"brown\", \"sleeping\"), 1)\nfillblankq(\"____ ``+ 2  = 4``\", 2)\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.hotspotq","page":"QuizQuestions","title":"QuizQuestions.hotspotq","text":"hotspotq(imagefile, xs, ys=(0,1); label=\"\", hint=\"\", explanation=\"\",\n    correct_answer=nothing)\n\nQuestion type to check if user clicks in a specified region of an image.\n\nimgfile: File of an image. The images will be encoded and embedded in the web page.\nxs: iterable specifying (xmin, xmax) with 0 <= xmin <= xmax <= 1\nys: iterable specifying (ymin, ymax)\ncorrect_answer: A text snippet of JavaScript which can be specified to add more complicated logic to test if an answer is correct. It must use x and y for the coordinates of the click.\n\nExamples\n\nusing Plots\np1 = plot(x -> x^2, axis=nothing, legend=false)\np2 = plot(x -> x^3, axis=nothing, legend=false)\np3 = plot(x -> -x^2, axis=nothing, legend=false)\np4 = plot(x -> -x^3, axis=nothing, legend=false)\nl = @layout [a b; c d]\np = plot(p1, p2, p3, p4, layout=l)\nimgfile = tempname() * \".png\"\nsavefig(p, imgfile)\nhotspotq(imgfile, (0,1/2), (0, 1/2), label=\"What best matches the graph of ``f(x) = -x^4``?\")\n\nnote: Note\nThe display of the image is not adjusted by this question type and must be managed separately.\n\n\n\n\n\n","category":"function"},{"location":"#QuizQuestions.plotlylightq","page":"QuizQuestions","title":"QuizQuestions.plotlylightq","text":"plotlylightq(p, xs=(-Inf, Inf), ys=(-Inf, Inf);\n             label=\"\", hint=\"\", explanation=\"\",\n             correct_answer=nothing)\n\nFrom a plotly graph of a function present a question about the x-y point on a graph shown on hover. (For figures with multiple graphs, the hover of the first one is taken. For parameterized plots, the hover may be computed in an unexpected manner.)\n\nBy default, correct answers select a value on the graph with x in the range specified by xs and y in the range specified by ys.\n\nxs: specifies interval for selected point [x₀,x₁], defaults to (-Inf,Inf)\nys: range [y₀,y₁]\ncorrect_answer: When specified, allows more advanced notions of correct. This is a JavaScript code snippet with x and y representing the hovered point on the graph that is highlighted on clicking.\n\nExamples\n\nusing PlotlyLight\nxs = range(0, 2pi, length=100)\nys = sin.(xs)\np = Plot(Config(x=xs, y=ys))\nplotlylightq(p, (3,Inf); label=\"Click a value with ``x>3``\")\n\nAn example where the default grading script needs modification. Note also, the x, y values refer to the first graph. (One could modify their definition in correct answer; they are found through x=e.points[0].x, y=e.points[0].y.)\n\nxs = range(0, 2pi, length=100)\nys = sin.(xs)\np = Plot(Config(x=xs, y=ys));\npush!(p.data, Config(x=xs, y=cos.(xs)));  # add layer\nquestion = \"Click a value where `sin(x)` is increasing\"\n# evalute pi/2 as no pi in JavaScript, also Inf -> Infinity\ncorrect_answer = \"((x >= 0 && x <= 1.5707963267948966) || (x >= 4.71238898038469 && x <= 6.283185307179586))\"\nplotlylightq(p; label=question, correct_answer=correct_answer)\n\nnote: Note\nThe use of PlotlyLight graphics works with Weave and Pluto, but is unusable from quarto and Documenter.\n\n\n\n\n\n","category":"function"}]
}
