
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

function getTag(tag)
	local results = {}
	if tag ~= "" then
		for k,indices in pairs(seq[tag]) do
			results[#results + 1] = concatener(seq, indices[1], indices[2])
		end
	end
	return results
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

function contains(t, v)
	for k,v1 in pairs(t) do
		if k == v then return true
		elseif type(v1) == "table" then contains(v1,v)
		elseif v1 == v then return true
		end
	end
	return false
end

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

function levenshteinAB(a,b,tolerance)
	if string.len(a)<=string.len(b) then return levenshtein(a,b,tolerance)
	else return levenshtein(b,a,tolerance) end
end

function empty(tab)
	return next(tab) == nil
end

function containsTag(tag)
	return not empty(getTag(tag))
end

function containsTagIn(dans, chercher)
	return not empty(getTagIn(dans, chercher))
end

--[[
function toMinutes(valeur, unite)
	if string.find(unite:lower(), "h") then
		return tonumber(valeur) * 60
	else
		return tonumber(valeur)
	end
end
]]

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

function addToSet(set, value)
	if not contains(set, value) then
		set[#set + 1] = value
		return true
	end
	return false
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

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

function getSimilarIn(table, string)
	for k,v1 in pairs(table) do
		if levenshteinAB(string,k, 0.15) then return k
		elseif type(v1) == "table" then getSimilarIn(v1,string)
		elseif levenshteinAB(string,v1, 0.15) then return v1
		end
	end
	return nil
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
	local nbMax = 30
	for nomRecette, score in spairs(recettesOk, function(t,a,b) return t[b] < t[a] end) do
		if nbMax == 0 then
			print("...")
			return
		end
		--print("["..score.."] "..nomRecette)
		print("- "..nomRecette)
		nbMax = nbMax - 1
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