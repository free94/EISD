require('etape')
require('quantite')
require('structure')
require('origine')
require ('outil')
require ('remarque')
require ('difficulte')
require ('prix')

main = dark.pipeline()
main:model("model/postag-fr")
main:add(etape)
main:add(quantite)
main:add(structure)
main:add(origine)
main:add(outil)
main:add(remarque)
main:add(difficulte)
main:add(prix)
-- tags a afficher
tags = {
	etape    = 'red',
	quantite = 'green',
	valeur   = 'green',
	unite    = 'green',
	temps_preparation = 'yellow',
	temps_cuisson = 'yellow',
	ingredients = 'yellow',
	ingredient = 'magenta',
	preparation = 'yellow',
	manipulation = 'yellow',
	extra = 'yellow',
	origine  = 'magenta',
	outil = 'cyan',
	remarque='red',
	difficulte='green',
	prix ='blue'
}

-- affichage
--[[
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
  --seq:dump()
end
]]

seq = main(io.read("*all"):gsub('%p', ' %1 '))
print(seq:tostring(tags))
--seq:dump()
