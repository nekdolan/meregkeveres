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
    sz0: '0.', sz1: '1.', sz2 : '2.', sz3 : '3.', sz4 : '4.', sz5 : '5.', sz6 : '6.'
    sz7 : '7.', sz8: '8.', sz9: '9.', sz10: '10.', sz11: '11.', sz12: '12.', sz13: '13.'
    h1: '1 hónap', h2: '2 hónap', h3: '3 hónap', h4: '4 hónap', h5: '5 hónap', h6: '6 hónap'
    egyszeri : 'egyszeri (1 kör)'
    rovid : 'rövid ideig ható méreg (K6x10 perc)'
    kozepes : 'közepes ideig ható méreg (K6 óra)'
    hosszu : 'hosszú ideig ható méreg (K6 nap)'
    maradando : 'maradandó'
    azonnali : 'azonnali (K10 szegmens)'
    gyors : 'gyors (K6 kör)'
    lassu : 'lassú (2K6 óra)'
    nagyon_lassu : 'nagyon lassú (K6 nap)'
    lappango : 'lappangó (speciális)'
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
    negative : 'karakter KN értéke'
    van : 'van'
    nincs : 'nincs'
    ar : 'ár (ezüst)'
    beszerzes : 'beszerzés módja'
    vasarlas : 'vásárlás'
    keszites : 'készítés'
    meregkeveres : 'méregkeverés'
    herbalizmus : 'herbalizmus'
    asvanytan : 'ásványtan'
    elettan : 'élettan'
    anatomia : 'anatómia'
    gyakorlat : 'gyakorlat'
    recept : 'recept'
    kikeheverto : 'kikeverhető'
    af : 'alapfok'
    mf : 'mesterfok'
    alkimia : 'alkímia'
    alkalmi : 'alkalmi'
    alap : 'alap'
    bovitett : 'bővített'
    laboratorium : 'laboratórium'
    felszereles : 'felszerelés'
    k3 : 'k6/2', k5 : 'k10/2', k6: 'k6', k10 : 'k10'
    fp_vesztes_eros : "Fp vesztés (erős)"
    fp_vesztes_eros_dice : "Kocka típusa"
    fp_vesztes_eros_amount : "Kockák száma"
    fp_vesztes_gyenge : "Fp vesztés (gyenge)"
    fp_vesztes_gyenge_dice : "Kocka típusa"
    fp_vesztes_gyenge_amount : "Kockák száma"
    tobb_amount : "Komponensek száma"

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

negativeDifficultyModifiers = {
  meregkeveres : {nincs: 0, af: 100, mf : 200}
  herbalizmus : {nincs: 0, af: 8, mf : 15}
  elettan : {nincs: 0, af: 8, mf : 15}
  recept : {nincs: 0, van: 50}
}

alchemyModifiers = {
  alkimia : {nincs: 0, af: 'af', mf : 'mf'}
  felszereles : {alkalmi: 1,alap: 2,bovitett: 3,laboratorium: 4}
}

hiddenModifiers = {
  fp_vesztes_eros : {
    inputs : {
      dice : {k6 : 6, k10 : 10}
      amount : 1
    }
    calculate : (modifiers) -> "#{modifiers[1].value}#{modifiers[0].value}"
  }
  fp_vesztes_gyenge : {
    inputs : {
      dice : {k3: 3, k5 : 5, k6 : 6, k10: 10}
      amount : 1
    }
    calculate : (modifiers) -> "#{modifiers[1].value}#{modifiers[0].value}"
  }
  tobb : {
    inputs : {
      amount : 2
    }
    calculate : (modifiers) -> "#{modifiers[0].value}"
  }
}

alchemy = {
    poisonDifficulty : [0, 100, 140, 180, 220, 260, 300, 340]
    levels: { 
      nincs : [1,2,3,4]
      af: [1,2,2,3,3,4]
      mf: [1,1,2,2,3,3,3,4]
    }
}

testAlchemy = (supplyType, difficulty, alchemyLevel) ->
  supplyLevel = alchemyModifiers.felszereles[supplyType]
  availableAlchemyLevel = alchemy.levels[alchemyLevel].lastIndexOf(supplyLevel)+1
  neededAlchemyLevel = _.findIndex alchemy.poisonDifficulty, (num) -> num > (difficulty or 0)
  {
    test : availableAlchemyLevel >= neededAlchemyLevel
    availableAlchemyLevel
    neededAlchemyLevel
  }

calculateSkillModifiers = (modifiers) ->
  meregkeveres = getModifierValue(modifiers, 'meregkeveres')
  if meregkeveres isnt 'mf'
    fajta = getModifierValue(modifiers, 'fajta')
    szint = getModifierValue(modifiers, 'szint')
    if fajta in ['gaz','kontakt','tobb']
      sendError('fajta_error')
      return NaN
    if szint in ['sz6', 'sz7', 'sz8', 'sz9', 'sz10', 'sz11', 'sz12', 'sz13']
      sendError('szint_error')
      return NaN
  return 0

specialDifficultyModifiers = {
  eros : {semmi : 0, fp_vesztes: 'fp_vesztes', benultsag: 70, ajulas: 80, alvas: 80, halal: 100, kabultsag: 40, gorcs: 20, gyengeseg: 20, rosszullet: 30, emelyges: 10, bodulat: 40}
  gyenge : {fp_vesztes: 'fp_vesztes'}
}

specialDifficultyModifierEffects = {
  labels: ['Erő','All.','Gyo.','Ügy.','Ake.','Aszt.','Int.','Érz.','KÉ','TÉ','VÉ','CÉ','varázslás']
  semmi : [0,0,0,0,0,0,0,0,0,0,0,0,'igen']
  halal : [0,0,0,0,0,0,0,0,0,0,0,0,'nem']
  ajulas : [0,0,0,0,0,0,0,0,0,0,0,0,'nem']
#  fp_vesztes : [0,0,0,0,0,0,0,0,0,0,0,0,'nem']
  kabultsag : [-2,-2,-2,-5,-5,-5,0,-4,15,-20,-25,0,'nem']
  gorcs : [-8,0,-8,-8,0,0,0,0,-30,-40,-35,-15,'nem']
  gyengeseg : ['1/2',-2,'3/4','3/4',0,0,0,0,-15,-20,-25,0,'igen']
  rosszullet : ['1/2',-4,'1/2','1/2',-2,0,0,-4,-20,-40,-40,-20,'nem']
  emelyges : ['3/4',-2,'3/4','1/4',0,0,0,-5,-10,-20,-15,-10,'igen']
  bodulat : [0,0,'1/2','3/4',-10,-5,-5,-8,-30,-50,-50,-30,'nem']
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

calculateCost = (modifiers) ->
    data = getLevelData(modifiers, ['szint','idotartam','beszerzes'])
    {eros, gyenge, fo} = getPoisonLevelData(data)
    poison = costMultipliers[eros.poisonType]
    effectCost = poison.hatas[eros.effectType]
    levelCost = poison.szint[data.szint]
    durationCost = if data.idotartam is 'maradando' then 4 else 1
    creationCost = if data.beszerzes is 'vasarlas' then 2 else 1
    return levelCost * effectCost * durationCost * creationCost

t = (key) -> _.capitalize(translate(key))

valueProviders =
  tobb : () -> @getNumber('tobb')
  fp_vesztes_eros : (effect) -> @getNumber('fp_vesztes_eros')
  fp_vesztes_gyenge : (effect) -> @getNumber('fp_vesztes_gyenge')

valueDifficultyCalculator =
  tobb : (val) -> 30 * val
  fp_vesztes_eros : (val) -> 2 * val
  fp_vesztes_gyenge : (val) -> val

getDifficultyForModifier = (type, name, changed, charLevel) ->
    if(type in ['eros','gyenge'])
      if(type is 'gyenge' and name isnt 'fp_vesztes')
        return 0
      difficulty = specialDifficultyModifiers[type]?[name]
    else
      if difficultyModifiers[type]?[name]
        difficulty = difficultyModifiers[type][name]
      else
        difficulty = 0
    if typeof difficulty is 'string'
      difficultyKey = difficulty + if(type in ['eros','gyenge']) then "_#{type}" else ""
      difficulty = valueProviders[difficultyKey]()
      if isNaN(difficulty)
        sendError(difficultyKey)
      else
        if changed isnt 'ignore'
          if charLevel isnt 'mf' and difficulty > 15
            sendError('fp_overflow')
            return NaN
      difficulty = valueDifficultyCalculator[difficultyKey](difficulty)
    if difficulty? then difficulty else NaN

calculateDifficulty = (modifiers, changed, charLevel) ->
  calculateSkillModifiers(modifiers) + calculateSpecialDifficulty(modifiers) + _(modifiers)
    .map (modifier) -> getDifficultyForModifier(modifier.name, modifier.value, changed, charLevel)
    .reduce (prev, next) -> prev + next

getModifierValue = (modifiers, attr) ->
  (_(modifiers).find (modifier) -> modifier.name is attr).value

calculateNegativeDifficulty = (modifiers) ->
  _(modifiers)
    .filter (modifier) -> negativeDifficultyModifiers[modifier.name]?
    .map (modifier) -> negativeDifficultyModifiers[modifier.name][modifier.value]
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
  _(specialConditions).reduce ((res, fn, key) -> res + checkForError(key, fn(eros, gyenge, fo, data))), 0

errorMessages =
  ugyanaz : "A gyenge hatás fp értéke nem lehet az erős hatás fp értékének felénél több"
  overflow : "Az erős hatás szintje nem lehet alacsonyabb vagy egyenlő a gyenge hatás szintjénél!"
  idegenOverflow : "Nem létezik elegendően magas szintű, az erős idegen hatásnak megfelelő méreg!"
  noIdenticalEffect : "Két hatás nem lehet azonos!"
  fp_vesztes : "A beírt értéknek számnak kell lennie!"
  fp_overflow : 'Az fp vesztés nem lehet 15-nél nagyobb ha nincs méregkeverés mf-je a kalandozónak'
  tobb : "A beírt értéknek számnak kell lennie!"
  fajta_error : "Ezt a típust csak mesterfokú méregkeverés képzettséggel lehet kikeverni!"
  szint_error : "Ilyen szintű mérget csak mesterfokú méregkeverés képzettséggel lehet kikeverni!"

specialConditions = {
  overflow : (eros, gyenge) ->
    if eros.effectLevel < gyenge.effectLevel and gyenge.effectLevel isnt 0
      return NaN
    return 0
  noIdenticalEffect : (eros, gyenge) ->
    if eros.effectType is gyenge.effectType and eros.effectLevel isnt 0 and eros.effectType isnt 'fp_vesztes'
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
    if eros.poisonLevel != gyenge.poisonLevel or eros.effectLevel != gyenge.effectLevel or eros.effectType isnt 'fp_vesztes'
      return 0
    difficultyEros = getDifficultyForModifier('eros', eros.effectType, 'ignore')
    difficultyGyenge = getDifficultyForModifier('gyenge', eros.effectType, 'ignore')
    if difficultyEros / 4 < difficultyGyenge
      return NaN
    return 20
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
  addValueProvider : (name, fn) ->
    valueProviders[name] = fn
  init : () ->
  difficultyModifiers : difficultyModifiers
  negativeDifficultyModifiers : negativeDifficultyModifiers
  costMultipliers : costMultipliers
  translate : translate
  specialDifficultyModifiers : specialDifficultyModifiers
  calculateDifficulty : calculateDifficulty
  calculateNegativeDifficulty : calculateNegativeDifficulty
  calculateCost : calculateCost
  alchemyModifiers : alchemyModifiers
  testAlchemy : testAlchemy
  hiddenModifiers : hiddenModifiers
  specialDifficultyModifierEffects : specialDifficultyModifierEffects
  t : t
}

window?.parser = exports
global?.parser = exports
