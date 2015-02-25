require('tools')
require('quantite')
require('structure')
require('origine')
require('prix')
require('outil')
require('avis')

-- PARAMETRES
local dir = "../corpus/txtrecettes/" -- dossier contenant le corpus de recettes
local diravis = "../corpus/txtavis/" -- dossier contenant les avis sur les recettes
local baseDeDonnees = "tableRecettes.lua" -- nom du fichier a creer

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
	-- tag_sans_& = 'couleur'
	]]
	recette = 'red',
	avis = 'blue'
}

local recettes = {}


local i, t, popen = 0, {}, io.popen
for filename in popen('ls -a "'..dir..'"'):lines() do
    i = i + 1
    t[i] = filename
end

for k, file in pairs(t) do
	--file = "recette_confiture-de-peches-de-vigne-a-la-lavande_95698.txt"
	if file ~= "." and file ~= ".." then
		print(dir..file)

		local f = assert(io.open(dir..file, "r"))
		local recetteTxt = f:read("*all")
		
		seq = main(recetteTxt:gsub('%p', ' %1 '))
		f:close()

		--print(seq:tostring(tags))


		-- Construction de la base de donnees

		nom = getTag("&nom")[1]
		--print(nom)
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

		recettes[nom].pour = {}
		if containsTagIn("&pour", "&quantite") then
			recettes[nom].pour.valeur = tonumber(getTagIn("&pour", "&valeur")[1])
			recettes[nom].pour.unite = getTagIn("&pour", "&unite")[1]
		else
			recettes[nom].pour.valeur = tonumber(getTagIn("&pour", "&NUM")[1])
			recettes[nom].pour.unite = "personnes"
		end

		recettes[nom].aliments = {}

		local k, ingredientResults = pairs(seq["&ingredientRecette"])
		local k, valeurResults = pairs(seq["&valeur"])
		local k, uniteResults = pairs(seq["&unite"])
		local k, alimentResults = pairs(seq["&aliment"])

		-- Galipettes pour associer la quantite d'un ingredient a son aliment 
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

		recettes[nom].remarques = getTag("&remarque")[1]

		recettes[nom].prix = getTag("&prix")

		recettes[nom].outils = {}
		for k,o in pairs(getTag("&outil")) do
			if not contains(recettes[nom].outils, o) then
				recettes[nom].outils[#recettes[nom].outils + 1] = o
			end
		end

	end
end

main:add(avis)

local i, t, popen = 0, {}, io.popen
for filename in popen('ls -a "'..diravis..'"'):lines() do
    i = i + 1
    t[i] = filename
end

for k, file in pairs(t) do
	if file ~= "." and file ~= ".." then
		print(diravis..file)
		local f = assert(io.open(diravis..file, "r"))
		local avisTxt = f:read("*all")
		f:close()
		
		seq = main(avisTxt:gsub('%p', ' %1 '))
		--print(seq:tostring(tags))
		
		local tagAvis = getTag("&avis")
		nom = tagAvis[1]

		table.remove(tagAvis, 1)
		if recettes[nom] ~= nil then
			recettes[nom].avis = tagAvis
			recettes[nom].popularite = #tagAvis
		end
	end
end



file = io.open(baseDeDonnees, "w")
io.output(file)
io.write("recettes = "..serialize(recettes))
io.close(file)
