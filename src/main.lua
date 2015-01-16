require('etape')
require('quantite')
require('quantite')
require('structure')

main = dark.pipeline()
main:model("model/postag-fr")
main:add(etape)
main:add(quantite)
main:add(structure)

-- tags a afficher
tags = {
	--[[etape    = 'red',
  quantite = 'green',
  valeur   = 'green',
  unite    = 'green',]]
  temps_preparation = 'yellow',
  temps_cuisson = 'yellow',
  ingredients = 'yellow',
  preparation = 'yellow',
  manipulation = 'yellow',
  extra = 'yellow'
}

-- affichage
--[[
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
  -- seq:dump()
end
]]

seq = main(io.read("*all"):gsub('%p', ' %1 '))
print(seq:tostring(tags))
