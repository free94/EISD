require('etape')
require('avis')
require('quantite')

main = dark.pipeline()
main:model("model/postag-fr")
main:add(etape)
main:add(avis)
main:add(quantite)

-- tags a afficher
tags = {
	etape    = 'red',
  quantite = 'green',
  valeur   = 'green',
  unite    = 'green',
}

-- affichage
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
  -- seq:dump()
end
