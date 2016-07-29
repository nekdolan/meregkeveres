# coffee --compile --output lib src

{ t, addErrorProvider, addValueProvider, difficultyModifiers, specialDifficultyModifiers, negativeDifficultyModifiers
  costMultipliers, calculateDifficulty, calculateCost, addDisplayValueProvider, calculateNegativeDifficulty} = parser

$main = $('#main_container_field')
$secondary = $('#secondary_container_field')
$kn = $('#kn_container_field')
$negativekn = $('#negative_kn_container_field')
$cost = $('#cost_container_field')
$error = $('#error_container_field')
$values = $('#values_container_field')
$form = $('#form_data')
$negative = $('#negative_value_container_filed')


errorProvider = (errorMessage) ->
  $error.html("Hiba: <span>#{errorMessage}</span>" )

getNumber = (label) ->
   prompt("Írj be egy számot (#{label})!", 0)

displayValueProvider = (key, label, value) ->
  $values.append("<div>#{label} : <strong>#{value}</strong></div>")

addValueProvider('getNumber', getNumber)
addErrorProvider(errorProvider)
addDisplayValueProvider(displayValueProvider)

parser.init()

clearDisplayValues = () ->
  $values.html('')

clearErrorMessage = () ->
  $error.html('')

getHtmlDifficultyModifier = (type, names) ->
  html = "<div class='form-group'><label class='col-sm-6 control-label' for='id_#{type}'>#{t(type)}:</label> "
  html += "<div class='col-sm-6'><select class='form-control' id='id_#{type}' name='#{type}'>"
  html += _(names).
    keys().
    reduce ((sum, key)-> "#{sum}\n<option value='#{key}'>#{t(key)}</option>"), ''
  html += "</select></div></div>"

renderModifiers = () -> renderListData($main, difficultyModifiers)
renderNegativeModifiers = () -> renderListData($negative, negativeDifficultyModifiers)
#  content = _(difficultyModifiers)
#    .reduce ((res, modifiers, name) -> "#{res}\n#{getHtmlDifficultyModifier(name, modifiers)}"), ''
#  $main.html(content)

renderListData = ($target, list) ->
  content = _(list)
    .reduce ((res, modifiers, name) -> "#{res}\n#{getHtmlDifficultyModifier(name, modifiers)}"), ''
  $target.html(content)

getHtmlSpecialModifier = (name, effect, selectedValue) ->
  "<label class='radio-inline' for='id_#{name}_#{effect}'>
      <input id='id_#{name}_#{effect}' type='radio' name='#{name}' value='#{effect}'
      #{if effect is selectedValue then "checked='checked'" else ""} />
      #{t(effect)}
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
    .reduce ((res, type) -> "#{res}<div class='form-group' id='#{type}'><label class='col-sm-2 control-label'>#{t(type)}</label> <div class='col-sm-10'>#{renderSpecialModifier(type)}</div></div>"), ''
  $secondary.html(content)

renderSimpleValue = (labelKey, value) ->
  "<span>#{t(labelKey)}: <span class='label label-info'>#{value}</span></span>"

renderCost = () ->
  cost = calculateCost(getFormData())
  $cost.html(renderSimpleValue('ar',cost))

renderDifficulty = (item) ->
  difficulty = calculateDifficulty(getFormData(), $(item).prop('name'))
  value = if difficulty then difficulty else 'Hiba!'
  $kn.html(renderSimpleValue('kn',value))

renderNegativeCost = () ->
  cost = calculateNegativeDifficulty(getFormData())
  $negativekn.html(renderSimpleValue('negative',cost))

getFormData = (attr) ->
  data = $form.serializeArray();
  if !attr then return data
  _(data).find({name : attr})?.value

exportData = () ->

init = () ->
  renderModifiers()
  renderNegativeModifiers()
  renderAllSpecialModifiers()
  renderDifficulty()
  renderCost()
  renderNegativeCost()
  clearErrorMessage()
  clearDisplayValues()
  $('form').on 'change', '#id_tipus_fo', (event) ->
    $('#id_tipus_eros, #id_tipus_gyenge').val($(event.target).val())
  $('form').on 'change', 'select[name^="tipus"]', () ->
    renderAllSpecialModifiers()
  $('form').on 'change', 'select, input', (event) ->
    clearDisplayValues()
    clearErrorMessage()
    renderDifficulty(event.target)
    renderCost()
    renderNegativeCost()

init()
