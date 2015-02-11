--modifier pour que ça puisse chercher en profondeur peu importe le nombre de sous tables contenues dans la table
function contains(t, v)
	for k,v1 in pairs(t) do
		if type(v1) == "table" then 
			contains(v1,v)
		else
			if v1 == v then
				return true
			end
		end
	end
	return false
end

function fusion(t1, t2)
	local resultats = {}
	for k,v in pairs(t2) do
		if contains(t1, v) then
			resultats[#resultats+1] = v
		end
	end
	return resultats
end

function chercheRecetteParCritere(recettes)
	resultats = {}
	resultatsTemp = {}	
	critere = { &cIngredient, &cDuree, &outil, &origine, &prix, &cPopularite, &cNom}
	premierPassage = true
	--pour tous les criteres
	for k,v in pairs(seq["&critere"]) do
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
		premierPassage = false
	end
	--resultats contient ici l'ensemble des recettes disposant de tous les critères demandés par l'utilisateur
	return resultats
end

print("test")