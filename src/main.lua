require('tools')
require('quantite')
require('structure')
require('origine')
require('prix')
require('outil')


main = dark.pipeline()
main:model("model/postag-fr")
main:lexicon("&aliment", "lexicon/aliments.txt")
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
		local recetteTxt = f:read("*all")
		seq = main(recetteTxt:gsub('%p', ' %1 '))
		f:close()

		print(seq:tostring(tags))

		
		nom = getTag("&nom")[1]
		print(nom)
		recettes[nom] = {}

		recettes[nom].enonce = recetteTxt

		recettes[nom].tempsPreparation = {}
		recettes[nom].tempsPreparation.valeur = tonumber(getTagIn("&tempsPreparation", "&valeur")[1])
		recettes[nom].tempsPreparation.unite = getTagIn("&tempsPreparation", "&unite")[1]

		recettes[nom].tempsCuisson = {}
		recettes[nom].tempsCuisson.valeur = tonumber(getTagIn("&tempsCuisson", "&valeur")[1])
		recettes[nom].tempsCuisson.unite = getTagIn("&tempsCuisson", "&unite")[1]
		
		recettes[nom].etapes = getTagIn("&preparation", "&etape")

		recettes[nom].ingredients = {}
		recettes[nom].ingredients = getTagIn("&ingredientsListe", "&ingredientRecette")

		recettes[nom].aliments = {}

		local k, ingredientResults = pairs(seq["&ingredientRecette"])
		local k, valeurResults = pairs(seq["&valeur"])
		local k, uniteResults = pairs(seq["&unite"])
		local k, alimentResults = pairs(seq["&aliment"])
		for k, ingredientIndices in pairs(ingredientResults) do
			local aliment = ""
			for k, alimentIndices in pairs(alimentResults) do
				if(alimentIndices[1]>=ingredientIndices[1] and alimentIndices[2]<=ingredientIndices[2]) then
					aliment = concatener(seq, alimentIndices[1], alimentIndices[2])
					break
				end
			end
			if aliment ~= "" then
				recettes[nom].aliments[aliment] = {}
				for k, valeurIndices in pairs(valeurResults) do
					if(valeurIndices[1]>=ingredientIndices[1] and valeurIndices[2]<=ingredientIndices[2]) then
						recettes[nom].aliments[aliment].quantite = concatener(seq, valeurIndices[1], valeurIndices[2])
						break
					end
				end
				for k, uniteIndices in pairs(uniteResults) do
					if(uniteIndices[1]>=ingredientIndices[1] and uniteIndices[2]<=ingredientIndices[2]) then
						recettes[nom].aliments[aliment].unite = concatener(seq, uniteIndices[1], uniteIndices[2])
						break
					end
				end
			end
		end

		recettes[nom].quantite = {}
		recettes[nom].quantite.valeur = getTagIn("&quantite", "&valeur")[1]
		recettes[nom].quantite.unite = getTagIn("&quantite", "&unite")[1]

		recettes[nom].difficulte = {}

		recettes[nom].origine = getTag("&origine")[1]

		recettes[nom].popularite = #getTag("&avis")

		recettes[nom].remarques = getTag("&remarque")[1]

		recettes[nom].avis = getTag("&avis")

		recettes[nom].prix = getTag("&prix")

		recettes[nom].outils = {}
		for k,o in pairs(getTag("&outil")) do
			if not contains(recettes[nom].outils, o) then
				recettes[nom].outils[#recettes[nom].outils + 1] = o
			end
		end
		--print(serialize(recettes[nom].ingredients))

	end
end
file = io.open("tableRecettes.lua", "w")
io.output(file)
io.write("recettes = "..serialize(recettes))
io.close(file)




