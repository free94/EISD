question = dark.pipeline()
--question:lexicon("&cIngredient", "lexicon/ingredients.txt")
question:lexicon("&outil", "lexicon/outilsCuisine.txt")

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

