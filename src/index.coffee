# coffee --compile --output lib src

{ t, addErrorProvider, addValueProvider, difficultyModifiers, specialDifficultyModifiers, negativeDifficultyModifiers
  costMultipliers, calculateDifficulty, calculateCost, addDisplayValueProvider, calculateNegativeDifficulty,
alchemyModifiers, testAlchemy} = parser

$main = $('#main_container_field')
$secondary = $('#secondary_container_field')
$kn = $('#kn_container_field')
$negativekn = $('#negative_kn_container_field')
$cost = $('#cost_container_field')
$error = $('#error_container_field')
$values = $('#values_container_field')
$form = $('#form_data')
$negative = $('#negative_value_container_filed')
$difficultydiff = $('#difference_container_field')
$alchemy = $('#alchemy_container_filed')
$alchemyResult = $('#alchemy_result_container_field')
$export = $('#export')

extraValues = []

errorProvider = (errorMessage) ->
  $error.html("Hiba: <span>#{errorMessage}</span>" )

getNumber = (label) ->
   prompt("Írj be egy számot (#{label})!", 0)

displayValueProvider = (key, label, value) ->
  extraValues.push [label, value]
  $values.append("<div>#{label} : <strong>#{value}</strong></div>")

addValueProvider('getNumber', getNumber)
addErrorProvider(errorProvider)
addDisplayValueProvider(displayValueProvider)

parser.init()

clearDisplayValues = () ->
  extraValues = []
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
renderAlchemyModifiers = () -> renderListData($alchemy, alchemyModifiers)

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

renderSimpleValue = (labelKey, value, type='info') ->
  "<span>#{t(labelKey)}: <span class='label label-#{type}'>#{value}</span></span>"

renderCost = () ->
  cost = calculateCost(getFormData())
  $cost.html(renderSimpleValue('ar',cost))
  cost

renderDifficulty = (item) ->
  formData = getFormData()
  negativeDifficulty = calculateNegativeDifficulty(formData)
  difficulty = calculateDifficulty(formData, $(item).prop('name'), $('#id_meregkeveres').val())
  success = difficulty <= negativeDifficulty
  if success is true
    knValue = 'elegendő'
    type = 'success'
  else
    type = 'danger'
    knValue = 'sok'
  knValue = "#{knValue} #{difficulty}/#{negativeDifficulty}"
  knValue = if difficulty then knValue else 'Hiba!'
  $kn.html(renderSimpleValue('kn',knValue, type))
  success

renderNegativeDifficulty = () ->
  cost = calculateNegativeDifficulty(getFormData())
  $negativekn.html(renderSimpleValue('negative',cost))
  cost

renderAlchemyResult = (alchemyValue) ->
  alchemyValue = getAlchemyValue()
  if alchemyValue.test is true
    diff = 'megfelelő'
    type = 'success'
  else
    diff = 'elégtelen'
    type = 'danger'
  diff = "#{diff} #{alchemyValue.availableAlchemyLevel}/#{alchemyValue.neededAlchemyLevel}"
  $alchemyResult.html(renderSimpleValue('alkímia felszerelés', diff, type))
  alchemyValue.test
  
renderSuccess = (difficultySuccess, alchemyValue) ->
  if (difficultySuccess is true) && (alchemyValue is true)
    diff = 'igen'
    type = 'success'
  else
    diff = 'nem'
    type = 'danger'
  $difficultydiff.html(renderSimpleValue('kikeverhető',diff, type))
  diff is 'igen'

getAlchemyValue = () ->
  alchemyLevel = $('#id_alkimia').val()
  supplyType = $('#id_felszereles').val()
  poisonType = $('#id_fajta').val()
  testAlchemy(supplyType, poisonType, alchemyLevel)

getFormData = (attr) ->
  data = $form.serializeArray();
  if !attr then return data
  _(data).find({name : attr})?.value

exportData = (event) ->
  clearDisplayValues()
  formData = getFormData()
  difficulty = calculateDifficulty(formData, null, $('#id_meregkeveres').val())
  negativeDifficulty = calculateNegativeDifficulty(formData)
  alchemy = getAlchemyValue()
  success =  difficulty <= negativeDifficulty and alchemy.test
  cost = calculateCost(formData)

  if success is false
    errorProvider('A mérget nem lehet kikeverni, ezért az nem exportálható!')
    return

  name = prompt('Írj be egy fájlnevet a méregnek!', "mereg_#{(new Date()*1)}")
  if !name then return

  results = [
    ['Név', name]
    ['Kikeverési nehézség', difficulty]
    ['Karakter KN értéke', negativeDifficulty]
    ['Alkímia szint', alchemy.availableAlchemyLevel]
    ['Szükséges alkímia szint', alchemy.neededAlchemyLevel]
    ['A méreg ára', "#{cost} ezüst"]
  ]
  data = _.map formData, (row) -> [t(row.name), t(row.value)]
  data = _.concat(results, data, extraValues)
  saveData(name, 'mereg', data)

init = () ->
  renderModifiers()
  renderNegativeModifiers()
  renderAlchemyModifiers()
  renderAllSpecialModifiers()
  difficultySuccess = renderDifficulty()
  alchemy = renderAlchemyResult()
  renderSuccess(difficultySuccess, alchemy)
  renderCost()
  clearErrorMessage()
  clearDisplayValues()
  $export.click exportData
  $('form').on 'change', '#id_tipus_fo', (event) ->
    $('#id_tipus_eros, #id_tipus_gyenge').val($(event.target).val())
  $('form').on 'change', 'select[name^="tipus"]', () ->
    renderAllSpecialModifiers()
  $('form').on 'change', 'select, input', (event) ->
    clearDisplayValues()
    clearErrorMessage()
    renderCost()
    difficultySuccess = renderDifficulty(event.target)
    alchemy = renderAlchemyResult()
    renderSuccess(difficultySuccess, alchemy)

init()
