## Could tidy up this HTML to make it look nicer
html_templates = Dict()

# thumbs up/down don't show in my editor
grading_partial = """
  if(correct) {
    msgBox.innerHTML = "<div class='pluto-output admonition note alert alert-success'><span> 👍&nbsp; {{#:CORRECT}}{{{:CORRECT}}}{{/:CORRECT}}{{^:CORRECT}}Correct{{/:CORRECT}} </span></div>";
    var explanation = document.getElementById("explanation_{{:ID}}")
    if (explanation != null) {
       explanation.style.display = "none";
    }
  } else {
    msgBox.innerHTML = "<div class='pluto-output admonition alert alert-danger'><span>👎&nbsp; {{#:INCORRECT}}{{{:INCORRECT}}}{{/:INCORRECT}}{{^:INCORRECT}}Incorrect{{/:INCORRECT}} </span></div>";
    var explanation = document.getElementById("explanation_{{:ID}}")
    if (explanation != null) {
       explanation.style.display = "block";
    }
  }
"""

## Basic question
## has label and hint option.
## Hint is put with label when present; otherwise, it appears at bottom of form.
## this is overridden with input widget in how show method is called
html_templates["question_tpl"] = mt"""
<form class="mx-2 my-3 mw-100" name='WeaveQuestion' data-id='{{:ID}}' data-controltype='{{:TYPE}}'>
  <div class='form-group {{:STATUS}}'>
    <div class='controls'>
    {{#:LABEL}}
        <label for="controls_{{:ID}}">{{{:LABEL}}}{{#:HINT}}<span href="#" title="{{{:HINT}}}">&nbsp;🎁</span>{{/:HINT}}
</label>
    {{/:LABEL}}
      <div class="form" id="controls_{{:ID}}">
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
html_templates["inputq_form"] = mt"""
</br>
<div class="input-group">
    <input id="{{:ID}}" type="{{:TYPE}}" class="form-control" placeholder="{{:PLACEHOLDER}}">
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
html_templates["Buttonq"] = mt"""
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
	    {{#:GREEN}}this.style.background = "{{{:GREEN}}}";{{/:GREEN}}
	    var text = this.innerHTML;
	    this.innerHTML = "<em>{{{:INCORRECT}}</em>&nbsp;" + text ;
            var explanation = document.getElementById("explanation_{{:ID}}")
            if (explanation != null) {
               explanation.style.display = "block";
            }
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
    var  correct =  (a.length === b.length && a.find((v,i) => v !== b[i]) === undefined)
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
<table>
{{#:ITEMS}}
<tr>
  <td>
   <label for "select_{{:ID}}">{{{:QUESTION}}}</label>
  </td>
  <td>
  <select name = "select_{{:ID}}" id="select_{{:ID}}">
     <option value=0 selected="selected">{{{:BLANK}}}</option>
     {{#:ANSWER_CHOICES}}
     <option value="{{:INDEX}}">{{{:LABEL}}}</option>
    {{/:ANSWER_CHOICES}}
  </select>
  </td>
<tr>
{{/:ITEMS}}
</table>
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
  <select name = "select_{{:ID}}" id="select_{{:ID}}">
     <option value=0 selected="selected">{{{:BLANK}}}</option>
     {{#:ANSWER_CHOICES}}
     <option value="{{:INDEX}}">{{{:LABEL}}}</option>
    {{/:ANSWER_CHOICES}}
  </select>
"""

html_templates["fill_in_blank_input"] = """
<input id="{{:ID}}" type="{{:TYPE}}" class="form-{{^:INLINE}}control{{/:INLINE}}" placeholder="{{:PLACEHOLDER}}">
"""

## -------
html_templates["hotspot"] = """
<div>
<img  id="hotspot_{{{:ID}}}" src="data:image/gif;base64,{{{:IMG}}}"/>
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
