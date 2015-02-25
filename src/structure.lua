structure = dark.pipeline()


structure:pattern("'-' [&ingredientRecette /^[^P-].*/+ ] ")
structure:pattern("[&etape /^%u/ .*? /^[%.;%!]+$/ ] ")
structure:pattern([[ [&preparation "Préparation" de la recette ":" .*? ] ]])
structure:pattern([[
		[&recette
			[&nom .*?]
			[&tempsPreparation Temps de "préparation" ":" &NUM . ]
			[&tempsCuisson Temps de cuisson ":" &NUM . ]
			[&ingredients "Ingrédients" ( "(" pour [&pour (&quantite | &NUM) ] .*? ")" )? ":" [&ingredientsListe .*?] ]
			[&preparation "Préparation" de la recette ":" .*? ]
			([&extra Remarques ":" [&remarque .* ] ] | $)
		]
	]])