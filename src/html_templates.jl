## Could tidy up this HTML to make it look nicer
html_templates = Dict()


## input form questions
html_templates["question_tpl"] = mt"""
<form class="mx-2 my-3" name='WeaveQuestion' data-id='{{:ID}}' data-controltype='{{:TYPE}}'>
  <div class='form-group {{:STATUS}}'>
    <div class='controls'>
    <div class="form-floating input-group" id="controls_{{:ID}}">
    {{#:LABEL}}<label for="controls_{{:ID}}">{{{:LABEL}}}</label>{{/:LABEL}}
    {{{:FORM}}}

    {{#:HINT}}
      <span href="#" title='{{{:HINT}}}'>&nbsp;🎁</span>
      <span class='help-inline'><i id='{{:ID}}_hint' class='icon-gift'></i></span>
      <script>$('#{{:ID}}_hint').tooltip({title:'{{{:HINT}}}', html:true, placement:'right'});</script>
    {{/:HINT}}

    </div>
    <div id='{{:ID}}_message'></div>
    </div>


  </div>


</form>

<script text='text/javascript'>
{{{:GRADING_SCRIPT}}
</script>
"""

html_templates["input_grading_script"] = mt"""
document.getElementById("{{:ID}}").addEventListener("change", function() {
  var correct = {{{:CORRECT}}};
  var msgBox = document.getElementById('{{:ID}}_message');
  if(correct) {
    msgBox.innerHTML = "<div class='pluto-output admonition note alert alert-success'><span class='glyphicon glyphicon-thumbs-up'>👍&nbsp;Correct</span></div>";
  } else {
    msgBox.innerHTML = "<div class='pluto-output admonition alert alert-danger'><span class='glyphicon glyphicon-thumbs-down'>👎&nbsp; Incorrect</span></div>";
  }
});
"""

##
html_templates["Numericq_form"] = mt"""
{{#:LABEL}}<label for="{{:ID}}">{{{:LABEL}}}</label>{{/:LABEL}}
<input id="{{:ID}}" type="number" class="form-control u-full-width" placeholder="{{:PLACEHOLDER}}">
{{#:UNITS}}<span class="input-group-addon mx-2">{{{:UNITS}}}</span>{{/:UNITS}}
"""

## Regular expression
html_templates["Stringq_form"] = mt"""
{{#:LABEL}}<label for="{{:ID}}">{{{:LABEL}}}</label>{{/:LABEL}}
<input id="{{:ID}}" type="text" class="form-control u-full-width" placeholder="{{:PLACEHOLDER}}">
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
    if (correct) {
    msgBox.innerHTML = "<div class='pluto-output admonition note alert alert-success'><span class='glyphicon glyphicon-thumbs-up'>👍&nbsp;Correct</span></div>";
  } else {
    msgBox.innerHTML = "<div class='pluto-output admonition alert alert-danger'><span class='glyphicon glyphicon-thumbs-down'>👎&nbsp; Incorrect</span></div>";
  }
})});
"""
