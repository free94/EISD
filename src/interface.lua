require('quantite')
require('structure')
require('origine')
require('outil')
require('remarque')
require('difficulte')
require('prix')
require('question')

main = dark.pipeline()
main:model("model/postag-fr")
main:add(quantite)
main:add(structure)
main:add(origine)
main:add(outil)
main:add(remarque)
main:add(difficulte)
main:add(prix)
main:add(question)
-- tags a afficher
tags = {--[[
	etape             = 'red',
	quantite          = 'green',
	valeur            = 'green',
	unite             = 'green',
	temps_preparation = 'yellow',
	temps_cuisson = 'yellow',
	ingredientRecette = 'magenta',
	ingredients = 'yellow',
	ingredient = 'green',
	preparation = 'yellow',
	extra = 'yellow',
	origine  = 'magenta',
	outil = 'cyan',
	remarque='red',
	difficulte='green',
	prix ='blue',
	nom = 'yellow',]]
	critere = 'yellow',
	qRecette = 'cyan',
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

function satisfaitCritere(recettes, nomCritere, valeurCritere)
	for recette,infos in pairs(recettes) do
		if not contains(infos[nomCritere], valeurCritere) then
			table.remove(recette)
		end
	end
	return recettes
end

function fusion(t1, t2)
	local resultats = {}
	for k,v in pairs(t2) do
		resultats[#resultats+1] = v
	end
	return resultats
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local recettes = {}

local args = {...}
local laQuestion = args[1]

seq = main(laQuestion:gsub('%p', ' %1 '))
print(seq:tostring(tags))

criteres = { "&ingredient", "&duree", "&outil", "&origine", "&prix", "&popularite", "&nom"}
recettesOk = deepcopy(recettes)
for c,nomCritere in pairs(criteres) do
	tags = getTag(nomCritere)
	for k,valeurCritere in pairs(tags) do
		recettesOk = satisfaitCritere(recettesOk, nomCritere, valeurCritere)
	end
end

print(serialize(recettesOk))



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



