structure = dark.pipeline()

--[[
	Remarque : comme je ne sais pas matcher les retours à la ligne ni les EOF ni faire des exclusions avec dark,
	je ne trouve pas comment faire détecter extra autrement qu'avec la solution suivante.
	Pour la même raison, le tagging sera erroné dans le cas d'une concaténation de fichiers.
]]

--[=[
structure:pattern([[
		[&tempsPreparation Temps de /^préparation*/ /^:$/ &NUM . ]
		[&tempsCuisson Temps de cuisson /^:$/ &NUM . ]
		[&ingredients /^Ingrédient/ /^%($/ pour &NUM . /^%)$/ /^:$/ .*? ]
		[&preparation /^Préparation$/ de la recette /^:$/ .* ]
	]])
structure:pattern("[&extra Remarques /^:$/ .* ]")
structure:pattern("&ingredients [&manipulation .*?] &extra")
local function test(seq, pos)
	if seq[pos].token == "toto" then
		return true
	end
	return false
end
structure:pattern("[&ingredient '-' @test + ] ('Préparation' | '-') ")
]=]

structure:pattern("[&ingredient &NNC &ADJ? (de &NNC)? &ADJ? ]")
structure:pattern("[&ingredientRecette '-' /^[^P-].*/+ ] ")
structure:pattern("[&etape /^%u/ .*? /^[%.;%!]+$/ ] ")

structure:pattern([[
		[&recette
			[&nom .*?]
			[&tempsPreparation Temps de "préparation" ":" &NUM . ]
			[&tempsCuisson Temps de cuisson ":" &NUM . ]
			[&ingredients "Ingrédients" "(" pour &NUM . ")" ":" .*? ]
			[&preparation "Préparation" de la recette ":" .*? ]
			([&extra Remarques ":" .* ] | $)
		]
	]])


--[[
structure:pattern("[&etape /^%u/ .*? /^[%.;%!]+$/ ]")
structure:pattern("[&preparation /^Préparation$/ de la recette /^:$/ ([&etape /^%u/ .*? /^[%.;%!]+$/ ] | .)*? ]")
structure:pattern("[&ingredient /^-$/ /^[^-]/+ /^!Préparation$/ ] (&ingredient | &preparation) ")
structure:pattern("[&ingredients /^Ingrédient/ /^%($/ pour &NUM . /^%)$/ /^:$/ &ingredient*] &preparation")
structure:pattern("[&tempsCuisson Temps de cuisson /^:$/ &NUM . ] &ingredients")
structure:pattern("[&tempsPreparation Temps de /^préparation*/ /^:$/ &NUM . ] &tempsCuisson")
structure:pattern("[&nom .*?] &tempsPreparation ")]]