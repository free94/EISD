-- pipelines

require('date')
require('partisPolitiques')
require('mandats')
require('orientation')
require('personne')

main = dark.pipeline()
main:add(partis)
main:add(mandat)
main:add(date)
main:add(orientation)
main:add(personne)

-- tags a afficher
tags = {
  jour  = 'yellow',
  mois  = 'yellow',
  annee = 'yellow',
  date  = 'red',
  parti = "blue",
  mandat = "magenta",
  PER = "white",
  nom = "cyan",
  PRENOMS = "cyan",
  orientation = "green",
}

-- affichage
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
end
