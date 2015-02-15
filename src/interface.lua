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
	qRecette = 'cyan',
}

criteres = {
	duree = "",--[[
	outils = "&outil",
	ingredients = "&ingredient",
	origine = "&origine",
	prix = "&prix",
	popularite = "&popularite",
	nom = "&nom",]]
}

dofile("tableRecettes.lua")

function toMinutes(valeur, unite)
	if string.find(unite:lower(), "h") then
		return valeur * 60
	else
		return valeur
	end
end

function satisfaitCritere(recettes, nomCritere, valeurCritere)
	for recette,infos in pairs(recettes) do
		if nomCritere == "nom" and recette ~= valeurCritere then
			recettes.remove(recette)
		elseif nomCritere == "duree" and toMinutes(infos.tempsCuisson.valeur, infos.tempsCuisson.unite) + toMinutes(infos.tempsPreparation.valeur, infos.tempsPreparation.unite) > tonumber(valeurCritere) then
			recettes.remove(recette)
		elseif not contains(infos[nomCritere], valeurCritere) then
			recettes.remove(infos)
		end
	end
	return recettes
end





local args = {...}
local laQuestion = args[1]
--laQuestion = "Quelles recettes utilisent un four ?"

seq = main(laQuestion:gsub('%p', ' %1 '))
print(seq:tostring(tags))
recettesOk = deepcopy(recettes)
for nomCritere,tagCritere in pairs(criteres) do
	print(tagCritere)
	tags = getTag(tagCritere)
	for k,valeurCritere in pairs(tags) do
		recettesOk = satisfaitCritere(recettesOk, nomCritere, valeurCritere)
	end
end

for recette, infos in pairs(recettesOk) do
	print(recette)
end












--[[
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



