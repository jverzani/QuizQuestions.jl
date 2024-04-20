## Could tidy up this HTML to make it look nicer
html_templates = Dict()

# code to support scorecard widget
scorecard_correct_partial = """
  const correct_answer   = new CustomEvent("quizquestion_answer", {bubbles:true, detail:{correct: 1}});
  this.dispatchEvent(correct_answer);
  //typeof correct_answer   != "undefined" && this.dispatchEvent(correct_answer);
"""

scorecard_incorrect_partial = """
  const incorrect_answer = new CustomEvent("quizquestion_answer", {bubbles:true, detail:{correct: 0}});
  this.dispatchEvent(incorrect_answer);
  //typeof incorrect_answer != "undefined" && this.dispatchEvent(incorrect_answer);
"""

# thumbs up/down don't show in my editor
grading_partial = """

  if(correct) {
    msgBox.innerHTML = "<div class='pluto-output admonition note alert alert-success'><span> 👍&nbsp; {{#:CORRECT}}{{{:CORRECT}}}{{/:CORRECT}}{{^:CORRECT}}Correct{{/:CORRECT}} </span></div>";
    var explanation = document.getElementById("explanation_{{:ID}}")
    if (explanation != null) {
       explanation.style.display = "none";
    }
    $(scorecard_correct_partial)
  } else {
    msgBox.innerHTML = "<div class='pluto-output admonition alert alert-danger'><span>👎&nbsp; {{#:INCORRECT}}{{{:INCORRECT}}}{{/:INCORRECT}}{{^:INCORRECT}}Incorrect{{/:INCORRECT}} </span></div>";
    var explanation = document.getElementById("explanation_{{:ID}}")
    if (explanation != null) {
       explanation.style.display = "block";
    }
    $(scorecard_incorrect_partial)
  }
"""

## Basic question
## has label and hint option.
## Hint is put with label when present; otherwise, it appears at bottom of form.
## this is overridden with input widget in how show method is called
html_templates["question_tpl"] = mt"""
<script>
var ID = "{{:ID}}"
</script>
<form class="mx-2 my-3 mw-100" name='WeaveQuestion' data-id='{{:ID}}' data-controltype='{{:TYPE}}' onSubmit='return false;'>
  <div class='form-group {{:STATUS}}'>
    <div class='controls'>
      <div class="form" id="controls_{{:ID}}" correct='-1' attempts='0'>
    {{#:LABEL}}
    {{{:LABEL}}}
            {{#:HINT}}<span href="#" title="{{{:HINT}}}">&nbsp;🎁</span>{{/:HINT}}
    {{/:LABEL}}
        <div style="padding-top: 5px">
    {{{:FORM}}}
    {{^:LABEL}}{{#:HINT}}<label for="controls_{{:ID}}"><span href="#" title="{{{:HINT}}}">&nbsp;🎁</span></label>{{/:HINT}}{{/:LABEL}}
        </div>
      </div>
      <div id='{{:ID}}_message' style="padding-bottom: 15px"></div>
      {{#:EXPLANATION}}
      <div id="explanation_{{:ID}}" class='pluto-output admonition alert alert-danger' style="display:none;;background-color:#D3D3D366;">{{{:EXPLANATION}}}</div>
      {{/:EXPLANATION}}
    </div>
  </div>
</form>
<script>
document.getElementById('controls_{{:ID}}').addEventListener("quizquestion_answer", (e) => {
	      var o = document.getElementById('controls_{{:ID}}')
	      var atts = Number(o.getAttribute("attempts"))
	      o.setAttribute("correct",  e.detail.correct);
	      o.setAttribute("attempts", atts + 1)
	  }, true)
</script>

<script text='text/javascript'>
{{{:GRADING_SCRIPT}}
</script>
"""

html_templates["input_grading_script"] = jmt"""
document.getElementById("{{:ID}}").addEventListener("change", function() {
  var correct = {{{:CORRECT_ANSWER}}};
  var msgBox = document.getElementById('{{:ID}}_message');
  $(grading_partial)
});
"""

##
html_templates["custom_grading_script"] = jmt"""
{{{:RUNONCE}}}
document.getElementById("{{:ID}}").addEventListener("change", function() {
  {{{:SNIPPET}}}
  var msgBox = document.getElementById('{{:ID}}_message');
  $(grading_partial)
});
"""

##
html_templates["inputq_form"] = mt"""
</br>
<div class="input-group" aria-label="Input form: {{:PLACEHOLDER}}">
    <input id="{{:ID}}" type="{{:TYPE}}" class="form-control" placeholder="{{:PLACEHOLDER}}" aria-label="{{:PLACEHOLDER}}">
    {{#:UNITS}}
    <span class="input-group-append">&nbsp;{{{:UNITS}}}&nbsp;</span>
    {{/:UNITS}}
    {{#:HINT}}
    <span  class="input-group-append" href="#" title="{{{:HINT}}}">&nbsp;🎁</span>
    {{/:HINT}}
</div>
"""


## Multiple choice (one of many)
## XXX add {{INLINE}}
## We do *not* use sibling elements, as suggested by Bootstrap here
html_templates["Radioq"] = mt"""
<fieldset style="border:0px">
<legend style="display: none" aria-label="Select an item">Select an item</legend>
{{#:ITEMS}}
<div class="form-check">
    <label class="form-check-label" for="radio_{{:ID}}_{{:VALUE}}">
      <input class="form-check-input" type="radio" name="radio_{{:ID}}"
              id="radio_{{:ID}}_{{:VALUE}}" value="{{:VALUE}}">
      </input>
      <span class="label-body px-1">
        {{{:LABEL}}}
      </span>
    </label>
</div>
{{/:ITEMS}}
</fieldset>
"""

html_templates["radio_grading_script"] = """
document.querySelectorAll('input[name="radio_{{:ID}}"]').forEach(function(rb) {
rb.addEventListener("change", function() {
    var correct = rb.value == {{:CORRECT_ANSWER}};
    var msgBox = document.getElementById('{{:ID}}_message');
    $(grading_partial)
})});
"""
## ----
html_templates["Buttonq"] = jmt"""
<div id="buttongroup_{{:ID}}" class="btn-group-vertical w-100">
  {{#:BUTTONS}}
  <button type="button" class="btn toggle-btn px-4 my-1 btn-light btn-block active" aria-pressed="false" id="button_{{:ID}}_{{:i}}" value="{{:ANSWER}}" style="width:100%;text-align:left; padding-left:10px; {{#:BLUE}}background:{{{:BLUE}}}{{/:BLUE}}" onclick="return false;">
    {{{:TEXT}}
  </button>
  {{/:BUTTONS}}
</div>
<script>
document.querySelectorAll('[id^="button_{{:ID}}_"]').forEach(function(btn) {
    btn.addEventListener("click", function(btn) {
	var correct = this.value == "correct";
	var id = this.id;

	if (!correct) {
            $(scorecard_incorrect_partial)
	    {{#:GREEN}}this.style.background = "{{{:GREEN}}}";{{/:GREEN}}
	    var text = this.innerHTML;
	    this.innerHTML = "<em>{{{:INCORRECT}}</em>&nbsp;" + text ;
            var explanation = document.getElementById("explanation_{{:ID}}")
            if (explanation != null) {
               explanation.style.display = "block";
            }
	} else {
          $(scorecard_correct_partial)
        }
	document.querySelectorAll('[id^="button_{{:ID}}_"]').forEach(function(btn) {
	    btn.disabled = true;
            btn.setAttribute("aria-pressed", "true");
	    if (btn.value == "correct") {
                {{#:RED}}btn.style.background = "{{{:RED}}}";{{/:RED}}
		var text = btn.innerHTML;
		btn.innerHTML =  " <em>{{{:CORRECT}}}</em>&nbsp;" + text ;
		btn.style.fontSize = "1.1rem";
		btn.style.color = "black";
                btn.style.borderRadius = "12px";
	    }
	});
    });
})
</script>
"""



html_templates["Multiq"] = mt"""
{{#:ITEMS}}
<div class="form-check">
  <label>
    <input class="form-check-input" type="checkbox" name="check_{{:ID}}"
              id="check_{{:ID}}_{{:VALUE}}" value="{{:VALUE}}">
      <span class="label-body">
        {{{:LABEL}}}
      </span>
    </input>
  </label>
</div>
{{/:ITEMS}}
"""

html_templates["multi_grading_script"] = """
document.querySelectorAll('input[name="check_{{:ID}}"]').forEach(function(rb) {
rb.addEventListener("change", function() {
    var choice_buttons = document.getElementsByName("check_{{:ID}}");
    var selected = [];
    for (var i=0; i < choice_buttons.length; i++) {
        if (choice_buttons[i].checked) {
           selected.push(i+1)
        }
    }
    var a = selected;
    var b = {{{:CORRECT_ANSWER}}};
    // https://stackoverflow.com/questions/7837456/how-to-compare-arrays-in-javascript
    var correct =  (a.length === b.length && a.find((v,i) => v !== b[i]) === undefined)
    var msgBox = document.getElementById('{{:ID}}_message');
    $(grading_partial)
})});
"""

html_templates["MultiButtonq"] = mt"""
<div id="buttongroup_{{:ID}}" class="btn-group-vertical w-100">
  {{#:BUTTONS}}
  <button type="button" class="btn toggle-btn px-4 my-1  btn-light btn-block active" aria-pressed="false"
    id="button_{{:ID}}_{{:i}}" name="{{:i}}" value="unclicked"
    style="width:100%;text-align:left; padding-left:10px; {{#:BLUE}}background:{{{:BLUE}}}{{/:BLUE}}" onclick="return false;">
      {{{:TEXT}}
  </button>
  {{/:BUTTONS}}
  <div class="col mt-1 align-self-center">
  <button id="button_{{:ID}}-done" class="btn btn-primary"
     style="display:block; margin:auto;text-align:center;{{#:BLUE}}background:{{{:BLUE}}}{{/:BLUE}}" onclick="return false;">
      DONE
  </button>
  </div>
</div>

"""

html_templates["multi_button_grading_script"] = """

// toggle button select
document.querySelectorAll('[id^="button_{{:ID}}_"]').forEach(function(btn) {
    btn.addEventListener("click", function(btn) {
	var unclicked = (this.value == "unclicked")
	if (unclicked) {
            this.style.background = "{{{:SELECTED_COLOR}}}";
	    this.value = "clicked";
            this.setAttribute("aria-pressed", "true");
	} else {
	    this.style.background = null;
	    this.value="unclicked";
            this.setAttribute("aria-pressed", "false");
	}
    });
})

// grade question
document.querySelector('[id^="button_{{:ID}}-done"]').addEventListener("click", function() {
                this.disabled = true;
    var multi_choice_buttons = document.querySelectorAll('[id^="button_{{:ID}}_"]');
    var selected = [];
    var correct = {{{:CORRECT_ANSWER}}};
    for (var i=0; i < multi_choice_buttons.length; i++) {
	var btn = multi_choice_buttons[i];
        btn.disabled = true;
	var btn_txt = btn.innerHTML;
	if (multi_choice_buttons[i].value == "clicked") {
	    selected.push(i+1)
	    if (correct.indexOf(i+1) < 0) {
		btn.innerHTML = "{{{:INCORRECT_flag}}}" + btn_txt
	    } else {
		btn.innerHTML =  "{{{:CORRECT_flag}}}" + btn_txt
                btn.style.fontSize = "1.1rem";
                btn.style.borderRadius = "12px";
            }
	} else {
	    if (correct.indexOf(i+1) < 0) {
		btn.innerHTML =  "{{{:INCORRECT_flag}}}" + btn_txt
	    } else {
		btn.innerHTML =  "{{{:CORRECT_flag}}}" + btn_txt
                btn.style.fontSize = "1.1rem";
                btn.style.borderRadius = "12px";
	    }
	}
      }
      var a = selected;
      var b = {{{:CORRECT_ANSWER}}}
          // https://stackoverflow.com/questions/7837456/how-to-compare-arrays-in-javascript
      var  correct =  (a.length === b.length && a.find((v,i) => v !== b[i]) === undefined)
      var msgBox = document.getElementById('{{:ID}}_message');
      $(grading_partial)
})
"""

## ----

html_templates["Matchq"] = mt"""
<div style="display: grid;grid-template-columns: 1fr 5fr">
{{#:ITEMS}}

<div>
  <select name = "select_{{:ID}}" id="select_{{:ID}}" aria-label="Select one">
     <option value=0 selected="selected">{{{:BLANK}}}</option>
     {{#:ANSWER_CHOICES}}
     <option value="{{:INDEX}}">{{{:LABEL}}}</option>
    {{/:ANSWER_CHOICES}}
  </select>
</div>
<div>{{{:QUESTION}}}</div>

{{/:ITEMS}}
</div>

"""

html_templates["matchq_grading_script"] = """
      function callback(element, iterator) {
	  element.addEventListener("change", function() {
	      var a = [];
	      var selectors = document.querySelectorAll('[id ^= "select_{{:ID}}"]');
	      Array.prototype.forEach.call(selectors, function (element, iterator) {
		 a.push(element.value);
	      })
              var b = {{{:CORRECT_ANSWER}}};
              // https://stackoverflow.com/questions/7837456/how-to-compare-arrays-in-javascript
              var correct =  (a.length === b.length && a.find((v,i) => v !== b[i]) === undefined)
              var msgBox = document.getElementById('{{:ID}}_message');
              $(grading_partial)
	  })
      }
      Array.prototype.forEach.call(document.querySelectorAll('[id ^= "select_{{:ID}}"]'), callback);
"""


## ----

html_templates["fill_in_blank_select"] = """
  <select name = "select_{{:ID}}" id="select_{{:ID}}" aria-label"Make a selection">
     <option value="0" selected="selected">{{{:BLANK}}}</option>
     {{#:ANSWER_CHOICES}}
     <option value="{{:INDEX}}">{{{:LABEL}}}</option>
    {{/:ANSWER_CHOICES}}
  </select>
<label for="select_{{:ID}}" style="left: -100vw; position: absolute;">Make a selection</label>
"""

html_templates["fill_in_blank_input"] = """
<input id="{{:ID}}" type="{{:TYPE}}" class="form-{{^:INLINE}}control{{/:INLINE}}" placeholder="{{:PLACEHOLDER}}" aria-label="Fill in the blank">
<label for="{{:ID}}" style="left: -100vw; position: absolute;">Fill in the blank</label>
"""


## -------
html_templates["hotspot"] = """
<div aria-label="Hotspot question for selection from an image">
<img  id="hotspot_{{{:ID}}}" alt="Image for hotspot selection" src="data:image/gif;base64,{{{:IMG}}}" />
</div>
"""

html_templates["hotspot_grading_script"] = """
  document.getElementById("hotspot_{{{:ID}}}").addEventListener("click", function(e) {
      var u = e.offsetX;
      var v = e.offsetY;
      var w = this.offsetWidth;
      var h = this.offsetHeight

      var x = u/w;
      var y = (h-v)/h

      var correct = {{{:CORRECT_ANSWER}}}
      var msgBox = document.getElementById('{{:ID}}_message');
      $(grading_partial)

  })
"""

## -----
## -------
html_templates["plotlylight_grading_script"] = """
document.getElementById("{{{:ID}}}").on("plotly_click", function(e) {
      var x = e.points[0].x
      var y = e.points[0].y

      var correct = {{{:CORRECT_ANSWER}}}
      var msgBox = document.getElementById('{{:ID}}_message');
      $(grading_partial)

  })
"""


## ------
## keep scorecard by reading values in each form control box.
html_templates["scorecard_tpl"] = """
<div id="scorecard"></div>
<script>
//      const correct_answer   = new CustomEvent("quizquestion_answer", {bubbles:true, detail:{correct: 1}});
//      const incorrect_answer = new CustomEvent("quizquestion_answer", {bubbles:true, detail:{correct: 0}});
      window.addEventListener("quizquestion_answer",
        (e) => {
            // compute values for each here!
            var score = []; // array of arrays
            var n = 0;
            var n_correct = 0;
            var n_attempted = 0;
            var n_attempts = 0;

            document.querySelectorAll('[id^="controls_"]').forEach(function(o) {
                var correct = Number(o.getAttribute("correct"));
                var attempts = Number(o.getAttribute("attempts"));
                var attempted = 0
                n++
                if (correct == 1) {
                  n_correct++
                  n_attempted++
                  attempted = 1
                } else if (correct == 0) {
                  n_attempted++
                  attempted = 1
                } else {
                  // no attempt
                }
                n_attempts += attempts
               	score.push([correct, attempts, attempted]);
            });

        // debug
        console.log("attempted", n_attempted, "total attempts", n_attempts, "correct", n_correct, "questions", n);

        var completed = (n_attempted == n);
        {{#:ONCOMPLETION}}if (completed) { {{/:ONCOMPLETION}}

	var percent_correct = (n_correct / n) * 100;
        var percent_attempted = (n_attempted / n) * 100;

	{{{:MESSAGE}}}

	txt = txt.replace("{{:attempted}}", n_attempted);
	txt = txt.replace("{{:total_attempts}}", n_attempts)    ;
	txt = txt.replace("{{:correct}}", n_correct);
	txt = txt.replace("{{:total_questions}}", n);
        {{#:ONCOMPLETION}}
        } else {
	    // not completed
	    txt = "{{:NOT_COMPLETED_MSG}}";
        }
        {{/:ONCOMPLETION}}

        var el = document.getElementById("scorecard")
        if (el !== null && txt.length > 0) {
	    el.innerHTML = txt;
        }

    }, false);

</script>
"""
