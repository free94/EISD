require('math')
question = dark.pipeline()
--question:lexicon("&cIngredient", "lexicon/ingredients.txt")
question:lexicon("&outil", "lexicon/outilsCuisine.txt")

function nomRecette(seq)
	local str1 = concatener(seq, 1, #seq)
	for str2, infos in pairs(recettes) do
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
	    print(distance[len1][len2])
    	if distance[len1][len2] < 5 then -- VALEUR A REGLER
			pat = dark.pattern('[&nom "'..str1..'"]')
			return function(seq)
				return pat(seq)
			end
		end
	end
	return function(seq) return seq end
end


question:add(nomRecette)
question:pattern([[
	[&critere 
		&cIngredient | &cDuree | &outil | &origine | &prix | &cPopularite | &cNom
	]
]])

question:pattern([[
	[&qRecette 
		.* /^[Rr]ecette/ .* &critere*? .* | &critere*? .* /^[Rr]ecette/ .*
	]
]])

--&prix : même pattern pour l'analyse des questions ou du texte, on réutilise le pattern prix existant
--&origine : pareil =)
--&outil : même combat

