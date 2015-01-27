-- extraction des noms des recettes 
for nom_recette in io.popen([[dir "../corpus/txtrecettes"]]):lines() do
	local nom_sans_recette=string.gsub(nom_recette,"recette_"," ")
	nom_sans_recette=string.gsub(nom_sans_recette,"_%d*%.txt"," ")
	print( string.gsub(nom_sans_recette,"-"," ") )

end








