-- pipelines

require('date')
require('partisPolitiques')
require('mandats')

main = dark.pipeline()
main:add(partis)
main:add(mandat)
main:add(date)

-- tags a afficher
tags = {
  jour  = 'yellow',
  mois  = 'yellow',
  annee = 'yellow',
  date  = 'red',
  parti = "blue",
  mandat = "magenta",
  PER = "white",
  NOM = "cyan",
  PRENOMS = "cyan",
}

-- affichage
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
end
