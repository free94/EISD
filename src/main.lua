require('date')
require('parti')
require('mandat')
require('orientation')
require('personne')

main = dark.pipeline()
main:model("model/postag-fr")
main:add(parti)
main:add(mandat)
main:add(date)
main:add(orientation)
main:add(personne)

-- tags a afficher
tags = {
  date  = 'red',
  jour  = 'yellow',
  mois  = 'yellow',
  annee = 'yellow',

  personne = "blue",
  nom = "cyan",
  prenom = "cyan",

  parti = "green",
  orientation = "green",
  mandat = "magenta",
}

-- affichage
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
end
