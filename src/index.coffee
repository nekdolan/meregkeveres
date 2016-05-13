# coffee --compile --output lib src

{t, addValueProvider, difficultyModifiers, specialDifficultyModifiers, costMultipliers, calculateDifficulty, calculateCost} = parser

$main = $('#main_container_field')
$secondary = $('#secondary_container_field')
$kn = $('#kn_container_field')
$cost = $('#cost_container_field')

getNumber = (label) ->
   prompt("Írj be egy számot (#{label})!", 0)

addValueProvider('getNumber', getNumber)
parser.init()

getHtmlDifficultyModifier = (type, names) ->
  html = "<p><label for='id_#{type}'>#{t(type)}:</label> "
  html += "<select id='id_#{type}' name='#{type}'>"
  html += _(names)
    .keys()
    .reduce ((sum, key)-> "#{sum}\n<option value='#{key}'>#{t(key)}</option>"), ''
  html += "</select></p>"

renderModifiers = () ->
  content = _(difficultyModifiers)
    .reduce ((res, modifiers, name) -> "#{res}\n#{getHtmlDifficultyModifier(name, modifiers)}"), ''
  $main.html(content)

getHtmlSpecialModifier = (name, effect, selectedValue) ->
  "<input id='id_#{name}_#{effect}' type='radio' name='#{name}' value='#{effect}' #{if effect is selectedValue then "checked='checked'" else ""} />
  <label for='id_#{name}_#{effect}'>#{t(effect)}</label> "

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
    .reduce ((res, type) -> "#{res}<div id='#{type}'>#{t(type)}<br />#{renderSpecialModifier(type)}</div>\n"), ''
  $secondary.html(content)

renderCost = () ->
  cost = calculateCost(getFormData())
  $cost.html("<p>#{t('ar')}: #{cost}</p>")

renderDifficulty = (item) ->
  difficulty = calculateDifficulty(getFormData(), $(item).prop('name'))
  value = if difficulty then difficulty else 'Hiba!'
  $kn.html("<p>#{t('kn')}: #{value}</p>")

getFormData = (attr) ->
  data = $('form').serializeArray();
  if !attr then return data
  _(data).find({name : attr})?.value

init = () ->
  renderModifiers()
  renderAllSpecialModifiers()
  renderDifficulty()
  renderCost()
  $('form').on 'change', 'select[name^="tipus"]', () ->
    renderAllSpecialModifiers()
  $('form').on 'change', 'select, input', (event) ->
    renderDifficulty(event.target)
    renderCost()

init()
