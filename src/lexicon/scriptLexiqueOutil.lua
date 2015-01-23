--l'appel à la fonction calculPopularite permet d'avoir en retour le nombre d'avis connus pour la recette indiquée

function nettoyageListeOutils()
	-- Opens a file in append mode
	
	fileIn = assert(io.open("outilsCuisine.txt", "r+"))
	fileOut = assert(io.open("listeOutils.txt", "a"))
	-- sets the default output file as test.lua
	io.output(fileOut)
	io.input(fileIn)
	local reg
	for line in fileIn:lines() do
		reg = string.match(line, "")		
		if reg ~= nil then
			fileOut:write(reg, "\n")
		end
		
	end
	-- closes the open file
	io.close(fileIn)
	io.close(fileOut)	
end

nettoyageListeOutils()
--print(popularite)
