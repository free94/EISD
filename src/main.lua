require('quantite')
require('structure')
require('origine')
require('outil')
require('remarque')
require('difficulte')
require('prix')

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
	etape             = 'red',
	quantite          = 'green',
	valeur            = 'green',
	unite             = 'green',
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

local recettes = {}


local i, t, popen = 0, {}, io.popen
local dir = "../corpus/sub/"
for filename in popen('ls -a "'..dir..'"'):lines() do
    i = i + 1
    t[i] = filename
end

for k, file in pairs(t) do
	if file ~= "." and file ~= ".." then
		print(dir..file)
		local f = assert(io.open(dir..file, "r"))
		seq = main(f:read("*all"):gsub('%p', ' %1 '))
		f:close()

		print(seq:tostring(tags))
		k,nomIndices = pairs(seq["&nom"])
		nom = concatener(nomIndices[1])

		recettes[nom] = {}
		recettes[nom].etapes = {}
		for k,v in pairs(seq["&etape"]) do
			valeur = nil
			valeur = concatener(v)
			recettes[nom].etapes[#recettes[nom].etapes+1] = valeur
		end
	end
end
print(serialize(recettes))






