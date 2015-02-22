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
	qListeRecettes = 'cyan',
	qRecette = 'cyan',
	qDuree = 'cyan',
	qCuisson = 'cyan',
	qPreparation = 'cyan',
	qPourCombien = 'cyan',
	qQuantite = 'cyan',
	qIngredients = 'cyan',
	critere = 'yellow',
	cDuree = 'red',
	cIngredients = 'red',
	cOutils = 'red',
	aliment = 'green',
	cNom = 'blue'
}

dofile("tableRecettes.lua")

-- local args = {...}
-- local laQuestion = args[1]


local state = {}

local done = false
os.execute("clear")
print("Bonjour cuisinier en herbe. As-tu des questions à me poser ?")

while not done do

	io.write("\n> ")
	laQuestion = io.read()

	seq = main(laQuestion:gsub('%p', ' %1 '))
	--print(seq:tostring(tags))

	local stateLess = state.typeQuestion == "qRecette" and not containsTag("&question")
	if (containsTag("&qRecette") or stateLess) and containsTag("&cNom") then
	    local question = laQuestion
	    if not stateLess then
	      state.typeQuestion = "qRecette"
	  	  question = getTag("&qRecette")[1]
	    end
	  	for nomRecette, infos in pairs(recettes) do
	  		if levenshtein(nomRecette, question, 0.15) then
	  			state.recetteCourante = nomRecette
	  			print(recettes[nomRecette].enonce)
	  		end
		end
	end

	stateLess = state.typeQuestion == "qListeRecettes" and not containsTag("&question")
	if containsTag("&qListeRecettes") or stateLess then
	    local reponses = {}
	    local recettesOk = {}
	    local sans = containsTag("&SANS")
	    local uniquement = containsTag("&UNIQUEMENT")

	    if not stateLess then
	    	state.typeQuestion = "qListeRecettes"
	    	for nomRecette, infos in pairs(recettes) do
	    		recettesOk[nomRecette] = 0
	    	end
	    else
	    	recettesOk = deepcopy(state.recettesOk)
	    end

	  	if containsTag("&cDuree") then
	  		local dureeMax = uniteStandard(getTagIn("&cDuree","&valeur")[1],getTagIn("&cDuree","&unite")[1])
	  		--reponses[1] = "en moins de "..getTag("&cDuree")[1]
	  		reponses[1] = "en moins de "..dureeMax.." minutes"
	  		for nomRecette, score in pairs(recettesOk) do
	  			local duree = uniteStandard(recettes[nomRecette].tempsCuisson.valeur, recettes[nomRecette].tempsCuisson.unite) + uniteStandard(recettes[nomRecette].tempsPreparation.valeur, recettes[nomRecette].tempsPreparation.unite)
	  			if duree > dureeMax then
	  				recettesOk[nomRecette] = nil
	  			else
	  				recettesOk[nomRecette] = recettesOk[nomRecette] + duree / dureeMax -- si l'utilisateur dit qu'il a trois heures devant lui, on ne va pas lui proposer de faire une tartine de confiture...
	  			end
	  		end
	  	end
	  	if containsTag("&cOutils") then
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

	  	if containsTag("&cIngredients") then
	  		local aliments = {}
	  		local setAliments = {}
	  		local k, ingredientResults = pairs(seq["&ingredient"])
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
	  				setAliments[#setAliments + 1] = aliment
	  				aliments[aliment] = "unknown"
	  				for k, valeurIndices in pairs(valeurResults) do
	  					if(valeurIndices[1]>=ingredientIndices[1] and valeurIndices[2]<=ingredientIndices[2]) then
	  						aliments[aliment] = concatener(seq, valeurIndices[1], valeurIndices[2])
	  						break
	  					end
	  				end
	  				for k, uniteIndices in pairs(uniteResults) do
	  					if(uniteIndices[1]>=ingredientIndices[1] and uniteIndices[2]<=ingredientIndices[2]) then
	  						local unite = concatener(seq, uniteIndices[1], uniteIndices[2])
	  						setAliments[#setAliments] = aliments[aliment].." "..unite.." de "..aliment
	  						aliments[aliment] = uniteStandard(aliments[aliment],unite)
	  						break
	  					end
	  				end
	  			end
	  		end

	  		local tagsAliments = getTagIn("&cIngredients", "&aliment")
	  		if sans then
	  			for nomRecette, score in pairs(recettesOk) do
	  				for k,a in pairs(tagsAliments) do
	  					if contains(recettes[nomRecette].aliments, a) then
	  						recettesOk[nomRecette] = nil
	  						break
	  					end
	  				end
	  			end
	  			reponses[#reponses + 1] = "sans "..stringliste(setAliments)
	  		elseif uniquement then
	  			for nomRecette, score in pairs(recettesOk) do
	  				for k,a in pairs(recettes[nomRecette].aliments) do
	  					if not contains(tagsAliments, a) or uniteStandard(recettes[nomRecette].aliments[a].quantite, recettes[nomRecette].aliments[a].unite) > aliments[a] then
	  						recettesOk[nomRecette] = nil
	  						break
	  					end
	  				end
	  			end
	  			reponses[#reponses + 1] = "avec uniquement "..stringliste(setAliments)
	  		else
	  			for nomRecette, score in pairs(recettesOk) do
	  				local scorebefore = recettesOk[nomRecette]
	  				for k,a in pairs(tagsAliments) do
	  					if contains(recettes[nomRecette].aliments, a) and (aliments[a] == "unknown" or not empty(recettes[nomRecette].aliments[a]) and uniteStandard(recettes[nomRecette].aliments[a].quantite, recettes[nomRecette].aliments[a].unite) <= aliments[a]) then
	  						recettesOk[nomRecette] = recettesOk[nomRecette] + ( 1 / tablelength(tagsAliments) )
	            end
	  				end
	  				if recettesOk[nomRecette] - scorebefore == 0 then
	  					recettesOk[nomRecette] = nil
	  				end
	  			end
	  			reponses[#reponses + 1] = "avec "..stringliste(setAliments)
	  		end
	  	end

	  	local len = tablelength(recettesOk)
	    if len > 0 then
	    	if len == 1 then
	    		for nomRecette, score in pairs(recettesOk) do
	    			state.recetteCourante = nomRecette
	    			break
	    		end
	    	end
	    	if not stateLess then print("Voici ce qu'il est possible de faire "..stringliste(reponses).." :") end
	    	resultat(recettesOk)
	    	state.recettesOk = recettesOk
	    else
	    	print("On ne peut malheureusement rien faire "..stringliste(reponses)..".")
	    end
	end

	if containsTag("&qDuree") then
		local nomRecette = getRecette(recettes, laQuestion, state)

		if nomRecette ~= nil then
			if recettes[nomRecette].tempsCuisson.valeur == 0 then
				print("Il faut "..recettes[nomRecette].tempsPreparation.valeur.." "..recettes[nomRecette].tempsPreparation.unite.." pour faire \""..nomRecette.."\".")
			else
				local temps = uniteStandard(recettes[nomRecette].tempsPreparation.valeur, recettes[nomRecette].tempsPreparation.unite) + uniteStandard(recettes[nomRecette].tempsCuisson.valeur, recettes[nomRecette].tempsCuisson.unite)
		  		print("Il faut "..temps.." minutes pour faire \""..nomRecette.."\", dont "..recettes[nomRecette].tempsPreparation.valeur.." "..recettes[nomRecette].tempsPreparation.unite.." de préparation et "..recettes[nomRecette].tempsCuisson.valeur.." "..recettes[nomRecette].tempsCuisson.unite.." de cuisson.")
		  	end
		else sorry() end
	end
	if containsTag("&qCuisson") then
		local nomRecette = getRecette(recettes, laQuestion, state)

		if nomRecette ~= nil then
			if recettes[nomRecette].tempsCuisson.valeur == 0 then
				print("Il n'y a pas de cuisson dans la recette \""..nomRecette.."\".")
			else
		  		print("Il y a "..recettes[nomRecette].tempsCuisson.valeur.." "..recettes[nomRecette].tempsCuisson.unite.." de cuisson dans la recette \""..nomRecette.."\".")
		  	end
		else sorry() end
	end
	if containsTag("&qPreparation") then
		local nomRecette = getRecette(recettes, laQuestion, state)

		if nomRecette ~= nil then
			print("Il faut "..recettes[nomRecette].tempsPreparation.valeur.." "..recettes[nomRecette].tempsPreparation.unite.." de préparation pour faire \""..nomRecette.."\".")
		else sorry() end
	end
	if containsTag("&qPourCombien") then
		local nomRecette = getRecette(recettes, laQuestion, state)

		if nomRecette ~= nil then
			print("La recette \""..nomRecette.."\" est prévue pour "..recettes[nomRecette].pour.valeur.." "..recettes[nomRecette].pour.unite..".")
		else sorry() end
	end
	if containsTag("&qPourCombien") then
		local nomRecette = getRecette(recettes, laQuestion, state)

		if nomRecette ~= nil then
			print("La recette \""..nomRecette.."\" est prévue pour "..recettes[nomRecette].pour.valeur.." "..recettes[nomRecette].pour.unite..".")
		else sorry() end
	end
	stateLess = state.typeQuestion == "qQuantite" and not containsTag("&question")
	if containsTag("&qQuantite") or (stateLess and containsTag("&aliment")) then
		local nomRecette = getRecette(recettes, laQuestion, state)
		local aliment = getTag("&aliment")[1]
		state.typeQuestion = "qQuantite"

		if nomRecette ~= nil then
			local alimentRecette = getSimilarIn(recettes[nomRecette].aliments,aliment) 
			if alimentRecette ~= nil then
				if empty(recettes[nomRecette].aliments[alimentRecette]) then
					print("Je ne sais pas trop...")
				else
					print("Pour faire \""..nomRecette.."\", il faut "..recettes[nomRecette].aliments[alimentRecette].quantite.." "..recettes[nomRecette].aliments[alimentRecette].unite.." de "..alimentRecette..".")
				end
			else
				print("Sauf erreur de ma part, il n'y a pas de "..aliment.." dans la recette \""..nomRecette.."\".")
			end
		else sorry() end
	end
	if containsTag("&qIngredients") then
		local nomRecette = getRecette(recettes, laQuestion, state)

		if nomRecette ~= nil then
			print("Voici les ingredients nécessaires pour faire \""..nomRecette.."\" : "..stringliste(recettes[nomRecette].ingredients)..".")
		else sorry() end
	end
end


--[[
-- CARCASSES DE CODE EN VRAC
--]]

	--[[

  -- if not repondu then
  --   if state.typeQuestion == "qRecette" then
  --     for nomRecette, infos in pairs(recettes) do
  --       if levenshtein(nomRecette, laQuestion, 0.15) then
  --         print(recettes[nomRecette].enonce)
  --       end
  --     end
  --   end
  --   if state.typeQuestion == "qListeRecettes" then
  --
  --   end
  -- end

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
