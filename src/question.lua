questions = dark.pipeline()
questions:lexicon("&cIngredient", "lexicon/ingredients.txt")
questions:lexicon("&outils", "lexicon/outilsCuisine.txt")

questions:pattern([[
	[&qRecette 
		.* "recette" .* &critere*? .* | &critere*? .* "recette" .*
	]
]])

--&prix : même pattern pour l'analyse des questions ou du texte, on réutilise le pattern prix existant
--&origine : pareil =)
--&outil : même combat
questions:pattern([[
	[&critere 
		&cIngredient | &cDuree | &outil | &origine | &prix | &cPopularite | &cNom
	]
]])

critere = { &cIngredient, &cDuree, &outil, &origine, &prix, &cPopularite, &cNom}
