require('quantite')
require('structure')
require('origine')
require('prix')
require('outil')

main = dark.pipeline()
main:model("model/postag-fr")
main:add(quantite)
main:add(structure)
main:add(origine)
main:add(prix)
main:add(outil)
-- tags a afficher
tags = {--[[
	etape             = 'red',
	quantite          = 'red',
	valeur            = 'green',
	unite             = 'green',
	tempsPreparation = 'yellow',
	tempsCuisson = 'yellow',]]
	ingredientRecette = 'magenta',
	ingredients = 'yellow',
	ingredient = 'green',
	--[[preparation = 'yellow',
	extra = 'yellow',
	origine  = 'magenta',]]
	outil = 'cyan',
	--[[remarque='red',
	prix ='blue',
	nom = 'yellow',]]
	ingredientsListe = 'blue',
	remarque = 'red'
}

-- affichage
--[[
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
  --seq:dump()
end
]]


function concatener(i1, i2)
	local valeur = nil
	for i = i1, i2, 1 do
		if valeur == nil then
			valeur = seq[i].token
		else
			valeur = valeur.." "..seq[i].token
		end
	end
	return valeur
end

function getTagIn(wrap, tag)
	local k, wrapResults = pairs(seq[wrap])
	local k, tagResults = pairs(seq[tag])
	results = {}
	for k, tagIndices in pairs(tagResults) do
		for k, wrapIndices in pairs(wrapResults) do
			if(tagIndices[1]>=wrapIndices[1] and tagIndices[2]<=wrapIndices[2]) then
				results[#results + 1] = concatener(tagIndices[1], tagIndices[2])
			end
		end
	end
	return results
end

function getTag(tag)
	local results = {}
	for k,indices in pairs(seq[tag]) do
		results[#results + 1] = concatener(indices[1], indices[2])
	end
	return results
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

		
		nom = getTag("&nom")[1]
		print(nom)
		recettes[nom] = {}

		recettes[nom].tempsPreparation = {}
		recettes[nom].tempsPreparation.valeur = tonumber(getTagIn("&tempsPreparation", "&valeur")[1])
		recettes[nom].tempsPreparation.unite = getTagIn("&tempsPreparation", "&unite")[1]

		recettes[nom].tempsCuisson = {}
		recettes[nom].tempsCuisson.valeur = tonumber(getTagIn("&tempsCuisson", "&valeur")[1])
		recettes[nom].tempsCuisson.unite = getTagIn("&tempsCuisson", "&unite")[1]
		
		recettes[nom].etapes = getTagIn("&preparation", "&etape")

		recettes[nom].ingredients = {}
		recettes[nom].ingredients = getTagIn("&ingredientsListe", "&ingredientRecette")

		recettes[nom].quantite = {}
		recettes[nom].quantite.valeur = getTagIn("&quantite", "&valeur")[1]
		recettes[nom].quantite.unite = getTagIn("&quantite", "&unite")[1]

		recettes[nom].difficulte = {}

		recettes[nom].origine = getTag("&origine")[1]

		recettes[nom].popularite = #getTag("&avis")

		recettes[nom].remarques = getTag("&remarque")[1]

		recettes[nom].avis = getTag("&avis")

		recettes[nom].prix = getTag("&prix")

		recettes[nom].outils = getTag("&outil")
		--print(serialize(recettes[nom].ingredients))

	end
end
file = io.open("tableRecettes.lua", "w")
io.output(file)
io.write("recettes = "..serialize(recettes))
io.close(file)





