structure = dark.pipeline()

--[[
	Remarque : comme je ne sais pas matcher les retours à la ligne ni les EOF ni faire des exclusions avec dark,
	je ne trouve pas comment faire détecter extra autrement qu'avec la solution suivante.
	Pour la même raison, le tagging sera erroné dans le cas d'une concaténation de fichiers.
]]

structure:pattern([[
		[&temps_preparation Temps de /^préparation*/ /^:$/ &NUM . ]
		[&temps_cuisson Temps de cuisson /^:$/ &NUM . ]
		[&ingredients /^Ingrédient/ /^%($/ pour &NUM . /^%)$/ /^:$/ .*? ]
		[&preparation /^Préparation$/ de la recette /^:$/ .*? ]
		( /^%z$/ | [&extra Remarques /^:$/ .* ] )
	]])

--structure:pattern("&ingredients [&manipulation .*?] &extra")
