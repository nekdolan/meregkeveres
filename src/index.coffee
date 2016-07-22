# coffee --compile --output lib src

{ t, addErrorProvider, addValueProvider, difficultyModifiers, specialDifficultyModifiers,
  costMultipliers, calculateDifficulty, calculateCost, addDisplayValueProvider} = parser

$main = $('#main_container_field')
$secondary = $('#secondary_container_field')
$kn = $('#kn_container_field')
$cost = $('#cost_container_field')
$error = $('#error_container_field')
$values = $('#values_container_field')
$form = $('#form_data')

errorProvider = (errorMessage) ->
  $error.html("Hiba: <span>#{errorMessage}</span>" )

getNumber = (label) ->
   prompt("Írj be egy számot (#{label})!", 0)

displayValueProvider = (key, label, value) ->
  $values.append("<div>#{label}</span>: <span class='simple_value'>#{value}</div>")

addValueProvider('getNumber', getNumber)
addErrorProvider(errorProvider)
addDisplayValueProvider(displayValueProvider)

parser.init()

clearDisplayValues = () ->
  $values.html('')

clearErrorMessage = () ->
  $error.html('')

getHtmlDifficultyModifier = (type, names) ->
  html = "<div class='pure-control-group'><label for='id_#{type}'>#{t(type)}:</label> "
  html += "<select id='id_#{type}' name='#{type}'>"
  html += _(names)
    .keys()
    .reduce ((sum, key)-> "#{sum}\n<option value='#{key}'>#{t(key)}</option>"), ''
  html += "</select></div>"

renderModifiers = () ->
  content = _(difficultyModifiers)
    .reduce ((res, modifiers, name) -> "#{res}\n#{getHtmlDifficultyModifier(name, modifiers)}"), ''
  $main.html(content)

getHtmlSpecialModifier = (name, effect, selectedValue) ->
  "<label class='pure-radio' for='id_#{name}_#{effect}'>
      <input id='id_#{name}_#{effect}' type='radio' name='#{name}' value='#{effect}'
      #{if effect is selectedValue then "checked='checked'" else ""} />  #{t(effect)}
  </label>"

renderSpecialModifier = (name) ->
  poisonType = getFormData("tipus_#{name}")
  effects = _(costMultipliers[poisonType].hatas).keys()
  selectedValue = getFormData(name)
  if(effects.indexOf(selectedValue) is -1)
    selectedValue = effects.first()
  effects.reduce ((res, effectName) -> "#{res}\n#{getHtmlSpecialModifier(name, effectName, selectedValue)}"), ''

renderAllSpecialModifiers = () ->
  content = _(specialDifficultyModifiers)
    .keys()
    .reduce ((res, type) -> "#{res}<div class='pure-u-1-2' id='#{type}'><legend>#{t(type)}</legend> <div class='pure-controls'>#{renderSpecialModifier(type)}</div></div>\n"), ''
  $secondary.html(content)

renderSimpleValue = (labelKey, value) ->
  "<span>#{t(labelKey)}: <span class='simple_value'>#{value}</span></span>"

renderCost = () ->
  cost = calculateCost(getFormData())
  $cost.html(renderSimpleValue('ar',cost))

renderDifficulty = (item) ->
  difficulty = calculateDifficulty(getFormData(), $(item).prop('name'))
  # console.log $(item).prop('name') + ' ' + difficulty
  value = if difficulty then difficulty else 'Hiba!'
  $kn.html(renderSimpleValue('kn',value))

getFormData = (attr) ->
  data = $form.serializeArray();
  if !attr then return data
  _(data).find({name : attr})?.value

exportData = () ->

init = () ->
  renderModifiers()
  renderAllSpecialModifiers()
  renderDifficulty()
  renderCost()
  clearErrorMessage()
  clearDisplayValues()
  $('form').on 'change', 'select[name^="tipus"]', () ->
    renderAllSpecialModifiers()
  $('form').on 'change', 'select, input', (event) ->
    clearDisplayValues()
    clearErrorMessage()
    renderDifficulty(event.target)
    renderCost()

init()
