require('tools')
require('quantite')
require('structure')
require('origine')
require('outil')
require('prix')
require('question')

main = dark.pipeline()
main:model("model/postag-fr")
main:add(quantite)
main:add(structure)
main:add(origine)
main:add(outil)
main:add(prix)
main:add(question)


tags = {
	critere = 'yellow',
	qListeRecettes = 'cyan',
	qRecette = 'cyan',
	aliment = 'red',
	cIngredients = 'green'
}

dofile("tableRecettes.lua")

local args = {...}
local laQuestion = args[1]

seq = main(laQuestion:gsub('%p', ' %1 '))
print(seq:tostring(tags))

if containsTag("&qRecette") and containsTag("&cNom") then
	local question = getTag("&qRecette")[1]
	for nomRecette, infos in pairs(recettes) do
		if levenshtein(nomRecette, question, 0.15) then
			print(recettes[nomRecette].enonce)
		end
	end
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function resultat(recettesOk)
	for nomRecette, score in spairs(recettesOk, function(t,a,b) return t[b] < t[a] end) do
		--print("["..score.."] "..nomRecette)
		print("- "..nomRecette)
	end
end

function stringliste(liste)
	local res = liste[1]
	for i=2,#liste do
		if i == #liste then res = res.." et "..liste[i]
		else res = res..", "..liste[i]
		end
	end
	return res
end

if containsTag("&qListeRecettes") then
	local reponses = {}
	local recettesOk = {}

	for nomRecette, infos in pairs(recettes) do
		recettesOk[nomRecette] = 0
	end
	


	if containsTag("&cDuree") then
		reponses[1] = "en moins de "..getTag("&cDuree")[1]
		local dureeMax = toMinutes(getTagIn("&cDuree","&valeur")[1],getTagIn("&cDuree","&unite")[1])
		for nomRecette, score in pairs(recettesOk) do
			local duree = toMinutes(recettes[nomRecette].tempsCuisson.valeur, recettes[nomRecette].tempsCuisson.unite) + toMinutes(recettes[nomRecette].tempsPreparation.valeur, recettes[nomRecette].tempsPreparation.unite)
			if duree > dureeMax then
				recettesOk[nomRecette] = nil
			else
				recettesOk[nomRecette] = recettesOk[nomRecette] + duree / dureeMax -- si l'utilisateur dit qu'il a trois heures devant lui, on ne va pas lui proposer de faire une tartine de confiture...
			end
		end
	end
	if containsTag("&cOutils") then
		local sans = containsTag("&SANS")
		local uniquement = containsTag("&UNIQUEMENT")
		local instruments = {}
		local tagsOutils = getTagIn("&cOutils", "&outil")
		for k,o in pairs(tagsOutils) do
			addToSet(instruments, o)
		end

		if sans then
			for nomRecette, score in pairs(recettesOk) do
				for k,o in pairs(tagsOutils) do	
					if contains(recettes[nomRecette].outils, o) then
						recettesOk[nomRecette] = nil
						break
					end
				end
			end
			reponses[#reponses + 1] = "sans "..stringliste(instruments)
		elseif uniquement then
			for nomRecette, score in pairs(recettesOk) do
				for k,o in pairs(recettes[nomRecette].outils) do
					if not contains(tagsOutils, o) then
						recettesOk[nomRecette] = nil
						break
					end
				end
			end
			reponses[#reponses + 1] = "avec uniquement "..stringliste(instruments)
		else
			for nomRecette, score in pairs(recettesOk) do
				local scorebefore = recettesOk[nomRecette]
				for k,o in pairs(tagsOutils) do
					if contains(recettes[nomRecette].outils, o) then
						recettesOk[nomRecette] = recettesOk[nomRecette] + ( 1 / #tagsOutils )
					end
				end
				if recettesOk[nomRecette] - scorebefore == 0 then
					recettesOk[nomRecette] = nil
				end
			end
			reponses[#reponses + 1] = "avec "..stringliste(instruments)
		end
	end
	print("Voici ce qu'il est possible de faire "..stringliste(reponses).." :")
	resultat(recettesOk)

	--[[
	--TODO : rajouter la notion de quantite dans les questions sur les ingrédients
	if containsTag("&cIngredients") then
		local sans = containsTag("&SANS")
		local ou = containsTagIn("&cIngredients", "&OU")
		local aliments = {}

		if sans then
			local recettesOk = deepcopy(recettes)
			for nomRecette, infos in pairs(recettesOk) do
				for k,o in pairs(getTagIn("&cIngredients", "&aliment")) do	
					addToSet(aliments, o)
					if contains(recettesOk[nomRecette].aliments, o) then
						recettesOk[nomRecette] = nil
						break
					end
				end
			end
			print("Voici les recettes qu'il est possible de faire sans "..stringliste(aliments, "et").." :")
			resultat(recettesOk)
		elseif ou then
			local recettesOk = {}
			for nomRecette, infos in pairs(recettesOk) do
				local garder = false
				for k,o in pairs(getTagIn("&cIngredients", "&aliment")) do
					addToSet(aliments, o)	
					if contains(recettes[nomRecette].aliments, o) then
						garder = true
						break
					end
				end
				if garder then
					recettesOk[nomRecette] = infos
				end
			end
			print("Voici les recettes qu'il est possible de faire avec "..stringliste(aliments, "ou").." :")
			resultat(recettesOk)
		else -- "avec" et "et"
			local recettesOk = deepcopy(recettesOk)
			for nomRecette, infos in pairs(recettes) do
				for k,o in pairs(getTagIn("&cIngredients", "&aliment")) do	
					addToSet(aliments, o)
					if not contains(recettesOk[nomRecette].aliments, o) then
						recettesOk[nomRecette] = nil
						break
					end
				end
			end
			print("Voici les recettes qu'il est possible de faire avec "..stringliste(aliments, "et").." :")
			resultat(recettesOk)
		end
	end
	]]
end



--[[
-- CARCASSES DE CODE EN VRAC
--]]


--[[
criteres = {
	duree = "",
	outils = "&outil",
	ingredients = "&ingredientRecette",
	origine = "&origine",
	prix = "&prix",
	popularite = "&popularite",
	nom = "&nom",
}


function satisfaitCritere(recettes, nomCritere, valeurCritere)
	for recette,infos in pairs(recettes) do
		if nomCritere == "prix" then
			--appliquer pattern prix sur valeurCritere
		elseif nomCritere == "nom" and recette ~= valeurCritere then
			recettes[recette] = nil
		elseif nomCritere == "duree" and toMinutes(infos.tempsCuisson.valeur, infos.tempsCuisson.unite) + toMinutes(infos.tempsPreparation.valeur, infos.tempsPreparation.unite) > tonumber(valeurCritere) then
			recettes[recette] = nil
		elseif not contains(infos[nomCritere], valeurCritere) then
			recettes[recette] = nil
		end
	end
	return recettes
end


]]


	--[[recettesOk = deepcopy(recettes)
	for nomCritere,tagCritere in pairs(criteres) do
		if nomCritere ~= nil then
			tags = getTag(tagCritere)
			--print(serialize(tags))
			for k,valeurCritere in pairs(tags) do
				recettesOk = satisfaitCritere(recettesOk, nomCritere, valeurCritere)
			end
		end
	end
	resultat(recettesOk)
	print("Vous pouvez préparer les recettes suivantes : ")
	resultat(recettesOk)


			local recettesOk = {}
			for nomRecette, infos in pairs(recettes) do
				local garder = false
				for k,o in pairs(getTagIn("&cOutils", "&outil")) do
					addToSet(instruments, o)	
					if contains(recettes[nomRecette].outils, o) then
						garder = true
						break
					end
				end
				if garder then
					recettesOk[nomRecette] = infos
				end
			end
			print("Voici les recettes qu'il est possible de faire avec "..stringliste(instruments, "ou").." :")
			resultat(recettesOk)
		else -- "avec" et "et"
			local recettesOk = deepcopy(recettes)
			for nomRecette, infos in pairs(recettes) do
				for k,o in pairs(getTagIn("&cOutils", "&outil")) do	
					addToSet(instruments, o)
					if not contains(recettesOk[nomRecette].outils, o) then
						recettesOk[nomRecette] = nil
						break
					end
				end
			end
			print("Voici les recettes qu'il est possible de faire avec "..stringliste(instruments, "et").." :")
			resultat(recettesOk)
		end




		--si notre tag n'est pas nul et qu'il est bien demandé par l'utilisateur
		if	v ~= nil then
			--recherche dans notre table ce critere, parcours de toute la table recettes
			for k2,v2 in pairs(recettes) do
				--getTag renvoi la string contenue dans un tag
				if string.gmatch(k2["&k"], &critere) then 
					--on a une recette contenant le critere courant recherche
					if premierPassage == true then
						resultats[#resultats+1] = nomRecette
					else
						if contains(resultats, nomRecette) then
							resultatsTemp[#resultatsTemp+1] = nomRecette
						end
						--fusion des deux tables pour ne garder que les recettes contenant l'ensemble des criteres
						--resultats = fusion(resultatsTemp, resultats)
					end				
				end
				
			end
							
		end
]]
--print(laQuestion)

--[[
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
		recettes[nom].tempsPreparation.valeur = getTagIn("&temps_preparation", "&valeur")[1]
		recettes[nom].tempsPreparation.unite = getTagIn("&temps_preparation", "&unite")[1]

		recettes[nom].tempsCuisson = {}
		recettes[nom].tempsCuisson.valeur = getTagIn("&temps_cuisson", "&valeur")[1]
		recettes[nom].tempsCuisson.unite = getTagIn("&temps_cuisson", "&unite")[1]
		
		recettes[nom].etapes = getTagIn("&preparation", "&etape")

		recettes[nom].ingredients = {}
		recettes[nom].ingredients = getTagIn("&ingredients", "&NNC")
		--print(serialize(recettes[nom].ingredients))


	end
end

print(serialize(recettes))

]]