
-- retourne la concatenation des tokens de la sequence seq qui sont compris entre les indices i1 et i2
function concatener(seq, i1, i2)
	local valeur = nil
	if i1 == i2 then return seq[i1].token end
	for i = i1, i2, 1 do
		if valeur == nil then
			valeur = seq[i].token
		else
			valeur = valeur.." "..seq[i].token
		end
	end
	return valeur
end

-- retourne les chaines de caracteres correspondant a la concatenation des tokens portant le tag "tag" et qui sont a l'interieur d'un tag "wrap"
function getTagIn(wrap, tag)
	local k, wrapResults = pairs(seq[wrap])
	local k, tagResults = pairs(seq[tag])
	local results = {}
	for k, tagIndices in pairs(tagResults) do
		for k, wrapIndices in pairs(wrapResults) do
			if(tagIndices[1]>=wrapIndices[1] and tagIndices[2]<=wrapIndices[2]) then
				results[#results + 1] = concatener(seq, tagIndices[1], tagIndices[2])
			end
		end
	end
	return results
end

-- retourne les chaines de caracteres correspondant a la concatenation des tokens portant le tag "tag"
function getTag(tag)
	local results = {}
	if tag ~= "" then
		for k,indices in pairs(seq[tag]) do
			results[#results + 1] = concatener(seq, indices[1], indices[2])
		end
	end
	return results
end

-- retourne une table contenant les paires de la table t1 et celles de t2
function fusion(t1, t2)
	local resultats = {}
	for k,v in pairs(t2) do
		resultats[#resultats+1] = v
	end
	return resultats
end

-- retourne un clone de la table orig
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

-- teste si la table t contient v (que ce soit en tant que clef ou valeur)
function contains(t, v)
	for k,v1 in pairs(t) do
		if k == v then return true
		elseif type(v1) == "table" then contains(v1,v)
		elseif v1 == v then return true
		end
	end
	return false
end

-- teste si la chaine "dans" contient a peu pres la chaine "chercher", le degre de permissivite etant "tolerance"  
function levenshtein(chercher, dans, tolerance)
	local str1  = dans
	local str2 = chercher
    local len1, len2 = #str1, #str2
	local char1, char2, distance = {}, {}, {}
	str1:gsub('.', function (c) table.insert(char1, c) end)
	str2:gsub('.', function (c) table.insert(char2, c) end)
	for i = 0, len1 do distance[i] = {} end
	for i = 0, len1 do distance[i][0] = i end
	for i = 0, len2 do distance[0][i] = i end
	for i = 1, len1 do
    	for j = 1, len2 do
        	distance[i][j] = math.min(
            	distance[i-1][j  ] + 1,
            	distance[i  ][j-1] + 1,
            	distance[i-1][j-1] + (char1[i] == char2[j] and 0 or 1)
			)
    	end
	end
	return distance[len1][len2] - (#str1-#str2) <= tolerance*#str2
end

-- teste si les chaines a et b sont similaires, le degre de permissivite etant "tolerance"
function levenshteinAB(a,b,tolerance)
	if string.len(a)<=string.len(b) then return levenshtein(a,b,tolerance)
	else return levenshtein(b,a,tolerance) end
end

-- teste si la table tab est vide
function empty(tab)
	return next(tab) == nil
end

-- teste si la derniere sequence contient le tag "tag"
function containsTag(tag)
	return not empty(getTag(tag))
end

-- teste si la derniere sequence contient le tag "chercher" a l'interieur d'un tag "dans"
function containsTagIn(dans, chercher)
	return not empty(getTagIn(dans, chercher))
end

-- convertit la valeur dans une unite standard
function uniteStandard(valeur, unite)
	unite = unite:lower()
	valeur = tonumber(valeur)
	if unite == "h" or unite == "heure" or unite == "heures" then
		return valeur * 60
	elseif unite == "l" or unite == "litre" or unite == "litres" then
		return valeur * 1000
	elseif unite == "cl" then
		return valeur * 10
	elseif unite == "kg" or unites == "kilo" or unite == "kilos" then
		return valeur * 1000
	end
	return valeur
end

-- ajoute la valeur "value" dans la table "set" sauf si elle est deja presente
function addToSet(set, value)
	if not contains(set, value) then
		set[#set + 1] = value
		return true
	end
	return false
end

-- retourne la taille de la table T
function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

-- retourne le nom de la recette contenue dans la question ou, s'il n'y en a pas, le nom de la derniere recette utilise
function getRecette(recettes, question, state)
	if containsTag("&cNom") then 
		for nomRecette, infos in pairs(recettes) do
			if levenshtein(nomRecette, question, 0.15) then
				state.recetteCourante = nomRecette
				return nomRecette
			end
		end
	elseif contains(state,"recetteCourante") then
		return state.recetteCourante
	end
	return nil
end

-- retourne une chaine d'excuse
sorryIndex = 1
function sorry()
	local rep =
	{
		[1] = "Pardonnez-moi, je ne trouve pas de réponse.",
		[2] = "Excusez-moi, je ne parviens pas à répondre.",
		[3] = "Désolé, je n'arrive pas à répondre.",
		[4] = "Je n'ai pas réponse à tout !",
	}
	print(rep[sorryIndex])
	if sorryIndex == #rep then sorryIndex = 1
	else sorryIndex = sorryIndex + 1 end
end

-- retourne une chaine similaire a string presente dans table
function getSimilarIn(table, string)
	for k,v1 in pairs(table) do
		if levenshteinAB(string,k, 0.15) then return k
		elseif type(v1) == "table" then getSimilarIn(v1,string)
		elseif levenshteinAB(string,v1, 0.15) then return v1
		end
	end
	return nil
end

-- enumerateur qui prend en parametre un comparateur
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

-- affiche les noms et scores des recettes contenu dans la table recettesOk dont le schema est {[nom_recette] = score,}
function resultat(recettesOk)
	local nbMax = 30
	for nomRecette, score in spairs(recettesOk, function(t,a,b) return t[b] < t[a] end) do
		if nbMax == 0 then
			print("...")
			return
		end
		print("["..score.."] "..nomRecette)
		--print("- "..nomRecette)
		nbMax = nbMax - 1
	end
end

-- concatene une liste de chaines avec des ',' et "et"
function stringliste(liste)
	local res = liste[1]
	for i=2,#liste do
		if i == #liste then res = res.." et "..liste[i]
		else res = res..", "..liste[i]
		end
	end
	return res
end