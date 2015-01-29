structure = dark.pipeline()

--[[
	Remarque : comme je ne sais pas matcher les retours à la ligne ni les EOF ni faire des exclusions avec dark,
	je ne trouve pas comment faire détecter extra autrement qu'avec la solution suivante.
	Pour la même raison, le tagging sera erroné dans le cas d'une concaténation de fichiers.
]]

--[=[
structure:pattern([[
		[&temps_preparation Temps de /^préparation*/ /^:$/ &NUM . ]
		[&temps_cuisson Temps de cuisson /^:$/ &NUM . ]
		[&ingredients /^Ingrédient/ /^%($/ pour &NUM . /^%)$/ /^:$/ .*? ]
		[&preparation /^Préparation$/ de la recette /^:$/ .* ]
	]])
structure:pattern("[&extra Remarques /^:$/ .* ]")
structure:pattern("&ingredients [&manipulation .*?] &extra")
]=]

structure:pattern("[&ingredient /^-$/ /^[^P-].*$/+ ]") -- sale !

structure:pattern([[
		[&recette
			(
			[&nom .*?]
			[&temps_preparation Temps de /^préparation*/ /^:$/ &NUM . ]
			[&temps_cuisson Temps de cuisson /^:$/ &NUM . ]
			[&ingredients /^Ingrédient/ /^%($/ pour &NUM . /^%)$/ /^:$/ [&ingredient /^-$/ /^[^-]/+ ]*? ]
			[&preparation /^Préparation$/ de la recette /^:$/ ([&etape /^%u/ .*? /^[%.;%!]+$/ ] | .)*? ]
			[&extra Remarques /^:$/ .* ]
			) | (
			[&nom .*?]
			[&temps_preparation Temps de /^préparation*/ /^:$/ &NUM . ]
			[&temps_cuisson Temps de cuisson /^:$/ &NUM . ]
			[&ingredients /^Ingrédient/ /^%($/ pour &NUM . /^%)$/ /^:$/ .* ]
			[&preparation /^Préparation$/ de la recette /^:$/ ([&etape /^%u/ .*? /^[%.;%!]+$/ ] | .)* ]
			)
		]
	]])


--[[
structure:pattern("[&etape /^%u/ .*? /^[%.;%!]+$/ ]")
structure:pattern("[&preparation /^Préparation$/ de la recette /^:$/ ([&etape /^%u/ .*? /^[%.;%!]+$/ ] | .)*? ]")
structure:pattern("[&ingredient /^-$/ /^[^-]/+ /^!Préparation$/ ] (&ingredient | &preparation) ")
structure:pattern("[&ingredients /^Ingrédient/ /^%($/ pour &NUM . /^%)$/ /^:$/ &ingredient*] &preparation")
structure:pattern("[&temps_cuisson Temps de cuisson /^:$/ &NUM . ] &ingredients")
structure:pattern("[&temps_preparation Temps de /^préparation*/ /^:$/ &NUM . ] &temps_cuisson")
structure:pattern("[&nom .*?] &temps_preparation ")]]