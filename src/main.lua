require('quantite')
require('structure')
require('origine')
require ('outil')
require ('remarque')
require ('difficulte')
require ('prix')

main = dark.pipeline()
main:model("model/postag-fr")
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
	prix ='blue',
	nom = 'yellow',
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

function concatener(indices)
	valeur = nil
	for i = indices[1], indices[2], 1 do
		if valeur == nil then
			valeur = seq[i].token
		else
			valeur = valeur.." "..seq[i].token
		end
	end
	return valeur
end

recettes = {}

k,nom = pairs(seq["&nom"])
recettes[nom] = {}
recettes[nom].etapes = {}
for k,v in pairs(seq["&etape"]) do
	valeur = nil
	valeur = concatener(v)
	recettes[nom].etapes[#recettes[nom].etapes+1] = valeur
end

print(serialize(recettes))
