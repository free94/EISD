--l'appel à la fonction calculPopularite permet d'avoir en retour le nombre d'avis connus pour la recette indiquée

function calculPopularite()
	local popularite = 0
	--fichier = assert(io.open(arg[1], "r"))
	for line in io.lines() do
		if string.find(line,"-=-=-=-=-=-=-", 1) then 
			popularite = popularite + 1
		end
	end
	return popularite
end

local popularite = calculPopularite()
--print(popularite)
