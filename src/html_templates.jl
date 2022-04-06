## Could tidy up this HTML to make it look nicer
html_templates = Dict()

grading_partial = """
  if(correct) {
    msgBox.innerHTML = "<div class='pluto-output admonition note alert alert-success'><span class='glyphicon glyphicon-thumbs-up'>👍&nbsp; {{#:CORRECT}}{{{:CORRECT}}}{{/:CORRECT}}{{^:CORRECT}}Correct{{/:CORRECT}} </span></div>";
  } else {
    msgBox.innerHTML = "<div class='pluto-output admonition alert alert-danger'><span class='glyphicon glyphicon-thumbs-down'>👎&nbsp; {{#:INCORRECT}}{{{:INCORRECT}}}{{/:INCORRECT}}{{^:INCORRECT}}Incorrect{{/:INCORRECT}} </span></div>";
  }
"""

## Basic question
## has label and hint option.
## Hint is put with label when present; otherwise, it appears at bottom of form.
## this is overridden with input widget in how show method is called
html_templates["question_tpl"] = mt"""
<form class="mx-2 my-3" name='WeaveQuestion' data-id='{{:ID}}' data-controltype='{{:TYPE}}'>
  <div class='form-group {{:STATUS}}'>
    <div class='controls'>
      <div class="form-floating input-group" id="controls_{{:ID}}">
    {{#:LABEL}}
        <label for="controls_{{:ID}}">{{{:LABEL}}}{{#:HINT}}<span href="#" title='{{{:HINT}}}'>&nbsp;🎁</span>{{/:HINT}}
</label>
    {{/:LABEL}}
        <div style="padding-top: 5px">
    {{{:FORM}}}
    {{^:LABEL}}{{#:HINT}}<label for="controls_{{:ID}}"><span href="#" title='{{{:HINT}}}'>&nbsp;🎁</span></label>{{/:HINT}}{{/:LABEL}}
        </div>
      </div>
      <div id='{{:ID}}_message' style="padding-bottom: 15px">
      </div>
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
<div class="row">
  <span style="width:90%">
    <input id="{{:ID}}" type="{{:TYPE}}" class="form-control" placeholder="{{:PLACEHOLDER}}">
  </span>
  <span style="width:10%">{{#:UNITS}}{{{:UNITS}}}{{/:UNITS}}{{#:HINT}}<span href="#" title='{{{:HINT}}}'>&nbsp;🎁</span>{{/:HINT}}
  </span>
</div>
"""

## Multiple choice (one of many)
## XXX add {{INLINE}}
html_templates["Radioq"] = mt"""
{{#:ITEMS}}
<div class="form-check">
  <label>
    <input class="form-check-input" type="radio" name="radio_{{:ID}}"
              id="radio_{{:ID}}_{{:VALUE}}" value="{{:VALUE}}">
      <span = class="label-body">
        {{{:LABEL}}}
      </span>
    </input>
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

html_templates["Multiq"] = mt"""
{{#:ITEMS}}
<div class="form-check">
  <label>
    <input class="form-check-input" type="checkbox" name="check_{{:ID}}"
              id="check_{{:ID}}_{{:VALUE}}" value="{{:VALUE}}">
      <span = class="label-body">
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
    selected = [];
    for (var i=0; i < choice_buttons.length; i++) {
        if (choice_buttons[i].checked) {
           selected.push(i+1)
        }
    }
    var a = selected;
    b = {{{:CORRECT_ANSWER}}};
    // https://stackoverflow.com/questions/7837456/how-to-compare-arrays-in-javascript
    correct =  (a.length === b.length && a.find((v,i) => v !== b[i]) === undefined)
    var msgBox = document.getElementById('{{:ID}}_message');
    $(grading_partial)
})});
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
  <select name = "select_{{:ID}}" id="select_{{:ID}}_{{:NO}}">
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
              b = {{{:CORRECT_ANSWER}}};
              // https://stackoverflow.com/questions/7837456/how-to-compare-arrays-in-javascript
              correct =  (a.length === b.length && a.find((v,i) => v !== b[i]) === undefined)
              var msgBox = document.getElementById('{{:ID}}_message');
              $(grading_partial)
	  })
      }
      Array.prototype.forEach.call(document.querySelectorAll('[id ^= "select_{{:ID}}"]'), callback);
"""
