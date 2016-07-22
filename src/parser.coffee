translate = do ->
  dictionary = {
    tipus_fo : 'méreg típusa'
    tipus_eros : 'méreg típusa (erős hatás)'
    tipus_gyenge : 'méreg típusa (gyenge hatás)'
    emeszto : 'emésztőrendszerre ható'
    ideg : 'idegrendszerre ható'
    izom : 'izomrendszerre ható'
    keringesi : 'keringési rendszerre ható'
    semmi : 'semmi'
    emelyges : 'émelygés'
    rosszullet : 'rosszullét'
    fp_vesztes : 'fp vesztés'
    ajulas : 'ájulás'
    halal : 'halál'
    bodulat : 'bódulat'
    alvas : 'alvás'
    gyengeseg : 'gyengeség'
    gorcs : 'görcs'
    benultsag : 'bénultság'
    kabultsag : 'kábultság'
    fajta : 'méreg fajta'
    szint : 'méreg szintje'
    idotartam : 'hatás időtartama'
    hatas : 'hatás'
    kezdet : 'hatás kezdete'
    modositok : 'módosítók'
    tartositas : 'tartósítás'
    etel : 'étel- és italmérgek'
    fegyver : 'fegyvermérgek'
    gaz : 'gáz vagy légimérgek'
    kontakt : 'kontaktmérgek'
    tobb : 'több komponensű mérgek'
    sz2 : '2.', sz3 : '3.', sz4 : '4.', sz5 : '5.', sz6 : '6.', sz7 : '7.'
    sz8: '8.', sz9: '9.', sz10: '10.', sz11: '11.', sz12: '12.', sz13: '13.'
    h1: '1 hónap', h2: '2 hónap', h3: '3 hónap', h4: '4 hónap', h5: '5 hónap', h6: '6 hónap'
    egyszeri : 'egyszeri'
    rovid : 'rövid ideig ható méreg'
    kozepes : 'közepes ideig ható méreg'
    hosszu : 'hosszú ideig ható méreg'
    maradando : 'maradandó'
    azonnali : 'azonnali'
    gyors : 'gyors'
    lassu : 'lassú'
    nagyon_lassu : 'nagyon lassú'
    lappango : 'lappangó'
    egyeb : 'egyéb hatás'
    kulonleges : 'különleges hatás'
    idegen : 'idegen hatás'
    ugyanaz : 'enyhe hatás ugyanaz'
    elhagyas : 'enyhe hatás elhagyása'
    gyengites : 'enyhe hatás gyengítése'
    erosites : 'enyhe hatás erősítése'
    gyenge : 'gyenge hatás'
    eros : 'erős hatás'
    kn : 'kikeverési nehézség'
    van : 'van'
    nincs : 'nincs'
    ar : 'ár (ezüst)'
    beszerzes : 'beszerzés módja'
    vasarlas : 'vásárlás'
    keszites : 'készítés'
  }
  (text) ->
    dictionary[text] or text

difficultyModifiers = {
  tipus_fo : {emeszto : 0, ideg: 0, izom : 0, keringesi : 0}
  tipus_eros : {emeszto : 0, ideg: 0, izom : 0, keringesi : 0}
  tipus_gyenge : {emeszto : 0, ideg: 0, izom : 0, keringesi : 0}
  fajta : {etel : 10, fegyver: 10, gaz : 30, kontakt: 30, tobb : 'tobb'}
  szint : {sz2 : 10, sz3: 20, sz4: 30, sz5 :40, sz6: 50, sz7: 60, sz8: 70, sz9: 80, sz10: 100, sz11: 130, sz12: 170, sz13: 220}
  idotartam : {egyszeri : 10, rovid: 30, kozepes: 50, hosszu: 70, maradando: 100}
  kezdet : {azonnali : 40, gyors: 30, lassu: 10, nagyon_lassu: 20, lappango: 50}
  # tartositas : {h1: 5, h2: 10, h3: 15, h4: 20, h5: 25, h6: 30}
  egyeb : {nincs: 0, van : 50}
  kulonleges : {nincs: 0, van : 50}
  beszerzes : {vasarlas : 0, keszites: 0}
}

specialDifficultyModifiers = {
  eros : {semmi : 0, fp_vesztes: 'fp_vesztes', benultsag: 70, ajulas: 80, alvas: 80, halal: 100, kabultsag: 40, gorcs: 20, gyengeseg: 20, rosszullet: 30, emelyges: 10, bodulat: 40}
  gyenge : {}
}

costMultipliers = {
  emeszto :
    hatas : {semmi: 1, emelyges: 1, rosszullet: 2, fp_vesztes: 4, ajulas: 7, halal: 15}
    szint : {sz2: 2, sz3: 4, sz4: 6, sz5: 8, sz6: 12, sz7: 15, sz8: 20, sz9: 25, sz10: 25, sz11: 25, sz12: 25, sz13: 25}
  ideg :
    hatas : {semmi: 1, emelyges: 1, bodulat: 5, alvas : 7, halal: 15}
    szint : {sz2: 1.5, sz3: 3, sz4: 6, sz5: 9, sz6: 13, sz7: 18, sz8: 24, sz9: 29, sz10: 29, sz11: 29, sz12: 29, sz13: 29}
  izom :
    hatas : {semmi: 1, gyengeseg: 1, gorcs: 7, benultsag: 10, halal: 15}
    szint : {sz2: 2, sz3: 4, sz4: 7, sz5: 10, sz6: 15, sz7: 20, sz8: 27, sz9: 32, sz10: 32, sz11: 32, sz12: 32, sz13: 32}
  keringesi :
    hatas : {semmi: 1, emelyges : 1, kabultsag : 2, fp_vesztes: 4, ajulas: 7, halal: 15}
    szint : {sz2: 2, sz3: 4, sz4: 7, sz5: 10, sz6: 14, sz7: 19, sz8: 26, sz9: 31, sz10: 31, sz11: 31, sz12: 31, sz13: 31}
}

sendError = ->
sendValue = ->

calculateCost = (modifiers) ->
    data = getLevelData(modifiers, ['szint','idotartam','beszerzes'])
    {eros, gyenge, fo} = getPoisonLevelData(data)
    poison = costMultipliers[eros.poisonType]
    effectCost = poison.hatas[eros.effectType]
    levelCost = poison.szint[data.szint]
    durationCost = if data.idotartam is 'maradando' then 3 else 1
    creationCost = if data.beszerzes is 'vasarlas' then 2 else 1
    return levelCost * effectCost * durationCost * creationCost

t = (key) -> _.capitalize(translate(key))

valueProviders =
  tobb : () -> @getNumber(t('tobb'))
  fp_vesztes : () -> @getNumber(t('fp_vesztes'))

valueDifficultyCalculator =
  tobb : (val) -> 30 * val
  fp_vesztes : (val) -> 2 * val

cacheOverride = (name, fn) ->
   cache = null
   cacheKey = ''
   (changed) ->
     key = "#{name}_#{changed}"
     if (key is cacheKey) or (cache is null)
       cache = fn.call(@)
       cacheKey = key
       cache
     else
       cache

for key, provider of valueProviders
  valueProviders[key] = cacheOverride(key, provider)

getDifficultyForModifier = (type, name, changed) ->
    if(type in ['eros','gyenge'])
      if(type is 'gyenge')
        return 0
      difficulty = specialDifficultyModifiers[type]?[name]
    else
      difficulty = difficultyModifiers[type]?[name]
    if typeof difficulty is 'string'
      difficultyKey = difficulty
      difficulty = valueProviders[difficultyKey](changed)
      if isNaN(difficulty)
        sendError(difficultyKey)
      else
        if changed isnt 'ignore'
          sendValue(difficultyKey, difficulty)
      difficulty = valueDifficultyCalculator[difficultyKey](difficulty)
    if difficulty? then difficulty else NaN

calculateDifficulty = (modifiers, changed) ->
  calculateSpecialDifficulty(modifiers) + _(modifiers)
    .map (modifier) -> getDifficultyForModifier(modifier.name, modifier.value, changed)
    .reduce (prev, next) -> prev + next

getPosisonLevels = (label, data) ->
  poisonType = data["tipus_#{label}"]
  poisonLevel = _(costMultipliers).keys().value().indexOf(poisonType)
  if label is 'fo'
    return {poisonLevel, poisonType}
  effectType = data[label]
  effectLevel = _(costMultipliers[poisonType].hatas).keys().value().indexOf(effectType)
  {poisonLevel, effectLevel, poisonType, effectType}

getPoisonLevelData = (data) ->
  attributes = ['eros','gyenge','fo']
  _.reduce attributes, ((res, value) -> _(res).set(value, getPosisonLevels(value, data)) ), {}
    .value()

getLevelData = (modifiers, extraInfo = []) ->
  list = _.concat extraInfo, ['tipus_fo','eros','gyenge','tipus_eros','tipus_gyenge']
  res = _(modifiers).reduce ((res, val) -> if val.name in list then _(res).set(val.name, val.value) else res), {}
  res.value()

checkForError = (key, value) ->
  if isNaN(value)
    sendError(key)
  value

calculateSpecialDifficulty = (modifiers) ->
  data = getLevelData(modifiers, ['idotartam'])
  {eros, gyenge, fo} = getPoisonLevelData(data)
  # for key, fn of specialConditions
  # console.log key, fn(eros, gyenge, fo, data)
  _(specialConditions).reduce ((res, fn, key) -> res + checkForError(key, fn(eros, gyenge, fo, data))), 0

errorMessages =
  overflow : "Az erős hatás szintje nem lehet alacsonyabb a gyenge hatás szintjénél!"
  idegenOverflow : "Nem létezik elegendően magas szintű, az erős idegen hatásnak megfelelő méreg!"
  fp_vesztes : "A beírt értéknek számnak kell lennie!"
  tobb : "A beírt értéknek számnak kell lennie!"

specialConditions = {
  overflow : (eros, gyenge) ->
    if eros.effectLevel < gyenge.effectLevel
      return NaN
    return 0
  idegenOverflow : (eros, gyenge, fo) ->
    if eros.effectLevel >= _(costMultipliers[fo.poisonType].hatas).keys().value().length
      return NaN
    return 0
  idegen : (eros, gyenge, fo) ->
    ret = 0
    if eros.poisonLevel isnt fo.poisonLevel then ret += 20
    if gyenge.poisonLevel isnt fo.poisonLevel then ret += 20
    ret
  ugyanaz : (eros, gyenge, fo, data) ->
    if eros.poisonLevel != gyenge.poisonLevel or eros.effectLevel != gyenge.effectLevel
      return 0
    difficulty = Math.round(getDifficultyForModifier('eros', eros.effectType, 'ignore')/2)
    difficulty += 20 if difficulty > 0
    return difficulty
  gyengites : (eros, gyenge) ->
    if gyenge.effectLevel < eros.effectLevel - 2 and gyenge.effectLevel isnt 0
      return -10
    else
      return 0
    return difficulty
  erosites : (eros, gyenge) ->
    if gyenge.effectLevel == eros.effectLevel - 1 and gyenge.effectLevel isnt 0
      return 10
    else
      return 0
  elhagyas : (eros, gyenge) ->
    if gyenge.effectLevel < eros.effectLevel - 2 and gyenge.effectLevel is 0
      return -20
    else
      return 0
  idotartamHalal : (eros, gyenge, fo,data) ->
    if eros.effectType isnt 'halal'
      return 0
    return -1 * getDifficultyForModifier('idotartam', data['idotartam'])
}

exports = {
  addErrorProvider : (fn) ->
    sendError = (key) ->
      fn(errorMessages[key] or "")
  addDisplayValueProvider : (fn) ->
    sendValue = (key, value) ->
      fn(key, t(key), value)
  addValueProvider : (name, fn) ->
    valueProviders[name] = fn
  init : () ->
  difficultyModifiers : difficultyModifiers
  costMultipliers : costMultipliers
  translate : translate
  specialDifficultyModifiers : specialDifficultyModifiers
  calculateDifficulty : calculateDifficulty
  calculateCost : calculateCost
  t : t
}

window?.parser = exports
global?.parser = exports
