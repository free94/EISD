day   = '^[0-3]?%d%a*$'
month = '^[0-1]?%d$'
year  = '%d%d%d%d'

date = dark.pipeline()

-- noms de jours et des mois
date:lexicon('&jour', 'lexiques/jours.txt')
date:lexicon('&mois', 'lexiques/mois.txt')

-- un nombre a quatre chiffre est consideree comme une annee
date:pattern('[&annee (/%d%d%d%d/) ]')

-- une date est :
--  - au format xx/xx/xxxx,
--  - ecrite literalement (e.g. 1er mars 2004).
date:pattern(
[[
  [&date
    ([&jour /%d+/] /%//)? ([&mois /%d+/] /%// &annee) |
    ([&jour /%d+%a*/] &mois) | (&mois &annee)
  ]
]]
)
