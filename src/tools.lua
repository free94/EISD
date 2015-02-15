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
	results = {}
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

function empty(tab)
	return next(tab) == nil
end

function containsTag(tag)
	return not empty(getTag(tag))
end

function containsTagIn(dans, chercher)
	return not empty(getTagIn(dans, chercher))
end


function toMinutes(valeur, unite)
	if string.find(unite:lower(), "h") then
		return tonumber(valeur) * 60
	else
		return tonumber(valeur)
	end
end

function addToSet(set, value)
	if not contains(set, value) then
		set[#set + 1] = value
		return true
	end
	return false
end	