require('math')
question = dark.pipeline()
--question:lexicon("&cIngredient", "lexicon/ingredients.txt")

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
	Quelle recette puis-je faire avec un four ?
	Que faire en moins de 3 minutes ?
	Que préparer avec des pommes et des tomates ?
]]

question:pattern('[&ET "et"]')
question:pattern('[&OU "ou"]')
question:pattern('[&AVEC "avec"]')
question:pattern('[&SANS "sans"]')
question:pattern('[&synonymesCuisiner "faire" | /^pr[ée]parer$/ | "cuisiner" | "concocter" ]')


question:pattern('[&cDuree [&valeur &NUM] [&unite ( "h" | /^heure/ | /^min/ )] ]')
question:pattern('[&cIngredients &avecOuSans? .* (&nomIngredient .*)+]') --il faudra creer &nomIngredient avec un lexique d'ingrédients
question:pattern('[&cOutils (&outil .*)+]')
question:pattern('[&critere cIngredients | &cDuree | &cOutils | &origine | &prix | cPopularite ]')
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

