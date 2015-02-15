function concatener(seq, i1, i2)
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
				results[#results + 1] = concatener(seq, tagIndices[1], tagIndices[2])
			end
		end
	end
	return results
end

function getTag(tag)
	local results = {}
	for k,indices in pairs(seq[tag]) do
		results[#results + 1] = concatener(seq, indices[1], indices[2])
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