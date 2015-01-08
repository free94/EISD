require('date')
require('parti')
require('mandat')
require('orientation')
require('personne')

main = dark.pipeline()
main:model("model/postag-fr")
main:add(date)
main:add(personne)
main:add(parti)
main:add(mandat)
main:add(orientation)

-- tags a afficher
tags = {
  date        = 'red',
  jour        = 'red',
  mois        = 'red',
  annee       = 'red',

  personne    = 'blue',
  nom         = 'cyan',
  prenoms     = 'cyan',

  parti       = 'yellow',
  orientation = 'green',
  mandat      = 'magenta',
}

-- affichage
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
end
