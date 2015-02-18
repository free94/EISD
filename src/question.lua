require('math')
question = dark.pipeline()
question:lexicon("&aliment", "lexicon/aliments.txt")

function tagNomRecette(seq)
	for nomRecette, infos in pairs(recettes) do
		if levenshtein(nomRecette, concatener(seq, 1, #seq), 0.15) == true then
			seq:add("&cNom",1,#seq)
			return
		end
	end
end



--[[
	qListeRecettes :
	Qu'est-ce que je peux faire avec du sucre et du beurre ?
	Quels plats contiennent du sucre et du beurre ?
	J'ai du sucre et du beurre, que puis-je faire ?
	Quelle recette dure moins de 3 minutes ?
	Quelle recette puis-je faire avec un four ou une poêle ?
	Que faire en moins de 3 minutes ?
	Que préparer avec des pommes et des tomates ?
	etc.
]]

question:pattern('[&ET "et" | "ni" ]')
question:pattern('[&UNIQUEMENT "uniquement" | "seulement" | "juste" | ("rien" "d" "\'" "autre" ) ]')
question:pattern('[&OU "ou"]')
question:pattern('[&AVEC "avec"]')
question:pattern('[&SANS "sans"]')
question:pattern('[&synonymesCuisiner "faire" | /^pr[ée]parer$/ | "cuisiner" | "concocter" ]')


question:pattern('[&cDuree [&valeur &NUM] [&unite ( "h" | /^heure/ | /^min/ )] ]')
question:pattern('[&cIngredients ([&ingredient (&valeur &unite "de")? &aliment] .*?)+]')
question:pattern('[&cOutils (&outil .*?)+]')
question:pattern('[&critere &cDuree | &cOutils | &cIngredients | &origine | &prix | cPopularite ]')
question:pattern([[
	[&qListeRecettes 
		.* ( &synonymesCuisiner | "recettes" | /^plat/ | /^dessert/ | /^entr[ée]e/ ) .* &critere .*
	]
]])



--[[
	qRecette :
	Quelle est la recette du pain au chocolat ?
	Comment faire une tarte à la framboise ?
]]

question:add(tagNomRecette)
question:pattern('[&qRecette ( .* "recette" |  "Comment" &synonymesCuisiner ) .* ]')





--[=[


question:pattern([[
	[&qRecette 
		.* /^[Rr]ecette/ .* &critere*? .* | &critere*? .* /^[Rr]ecette/ .*
	]
]])
]=]

--&prix : même pattern pour l'analyse des questions ou du texte, on réutilise le pattern prix existant
--&origine : pareil =)
--&outil : même combat

