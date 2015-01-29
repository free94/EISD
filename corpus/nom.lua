local nom_sans_recette=string.gsub(arg[1],"recette_"," ")
nom_sans_recette=string.gsub(nom_sans_recette,"_%d*%.txt"," ")
local nom_final=string.gsub(nom_sans_recette,"-"," ")
