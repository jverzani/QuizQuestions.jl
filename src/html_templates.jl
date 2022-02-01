html_templates = Dict()

html_templates["question_tpl"] = mt"""
<form  class="mx-2 my-3" name="WeaveQuestion" data-id="{{ID}}" data-controltype="{{TYPE}}">
<div class="form-group {{status}}">
{{{form}}}
{{#hint}}
<i class="bi bi-gift-fill"></i>

<!--<script>$("#{{ID}}_hint").tooltip({title:"{{{hint}}}", html:true, placement:"right"});</script>-->
{{/hint}}
<div id="{{ID}}_message"></div>
</div>
</form>
<script text="text/javascript">
{{{script}}}
</script>
"""

## input form questions
html_templates["input_form_tpl"] = mt"""
<form class="mx-2 my-3" name='WeaveQuestion' data-id='{{ID}}' data-controltype='{{TYPE}}'>
<div class='form-group {{status}}'>

<div class='controls'>
{{{FORM}}}
{{#hint}}
<span class='help-inline'><i id='{{ID}}_hint' class='icon-gift'></i></span>

<script>$('#{{ID}}_hint').tooltip({title:'{{{hint}}}', html:true, placement:'right'});</script>
{{/hint}}

<div class="form-floating input-group">
{{{INPUT_FORM}}
</div>

<div id='{{ID}}_message'></div>
</div>
</div>
</form>
<script text='text/javascript'>
document.getElementById("{{ID}}").addEventListener("change", function() {
  var correct = {{{correct}}};
  var msgBox = document.getElementById('{{ID}}_message');
  if(correct) {
    msgBox.innerHTML = "<div class='pluto-output admonition note alert alert-success'><span class='glyphicon glyphicon-thumbs-up'>👍&nbsp;Correct</span></div>";
  } else {
    msgBox.innerHTML = "<div class='pluto-output admonition alert alert-danger'><span class='glyphicon glyphicon-thumbs-down'>👎&nbsp; Incorrect</span></div>";
  }
});
</script>
"""


## Numeric questions
html_templates["Numericq"] = mt"""
<form class="mx-2 my-3" name='WeaveQuestion' data-id='{{ID}}' data-controltype='{{TYPE}}'>
<div class='form-group {{status}}'>

<div class='controls'>
{{{form}}}
{{#hint}}
<span class='help-inline'><i id='{{ID}}_hint' class='icon-gift'></i></span>

<script>$('#{{ID}}_hint').tooltip({title:'{{{hint}}}', html:true, placement:'right'});</script>
{{/hint}}

<div class="form-floating input-group">
<input id="{{ID}}" type="number" class="form-control" placeholder="Numeric answer">
<label for="{{ID}}">Numeric answer</label>
{{#units}}<span class="input-group-addon mx-2">{{{units}}}</span>{{/units}}
</div>

<div id='{{ID}}_message'></div>
</div>
</div>
</form>
<script text='text/javascript'>
document.getElementById("{{ID}}").addEventListener("change", function() {
  var correct = {{{correct}}};
  var msgBox = document.getElementById('{{ID}}_message');
  if(correct) {
    msgBox.innerHTML = "<div class='pluto-output admonition note alert alert-success'><span class='glyphicon glyphicon-thumbs-up'>👍&nbsp;Correct</span></div>";
  } else {
    msgBox.innerHTML = "<div class='pluto-output admonition alert alert-danger'><span class='glyphicon glyphicon-thumbs-down'>👎&nbsp; Incorrect</span></div>";
  }
});
</script>
"""

## Regular expression
html_templates["Stringq_form"] = mt"""
<input id="{{:ID}}" type="text" class="form-control" placeholder="Text answer">
<label for="{{:ID}}">Text answer</label>
"""

## Multiple choice (one of many)
html_templates["Radioq"] = mt"""
{{#items}}
<div class="form-check">
  <input class="form-check-input" type="radio" name="radio_{{ID}}" id="radio_{{ID}}_{{value}}" value="{{value}}">
    {{{label}}}
</div>
{{/items}}
"""
html_templates["radio_script_tpl"] = """
document.querySelectorAll('input[name="radio_{{ID}}"]').forEach(function(rb) {
rb.addEventListener("change", function() {
    var correct = rb.value == {{correct_answer}};
    var msgBox = document.getElementById('{{ID}}_message');
    if (correct) {
    msgBox.innerHTML = "<div class='pluto-output admonition note alert alert-success'><span class='glyphicon glyphicon-thumbs-up'>👍&nbsp;Correct</span></div>";
  } else {
    msgBox.innerHTML = "<div class='pluto-output admonition alert alert-danger'><span class='glyphicon glyphicon-thumbs-down'>👎&nbsp; Incorrect</span></div>";
  }
})});
"""
