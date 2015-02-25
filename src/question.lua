require('math')
question = dark.pipeline()
question:lexicon("&aliment", "lexicon/aliments.txt")

-- tague les noms de recettes detectes dans la sequence seq
function tagNomRecette(seq)
	for nomRecette, infos in pairs(recettes) do
		if levenshtein(nomRecette, concatener(seq, 1, #seq), 0.15) == true then
			seq:add("&cNom",1,#seq)
			return
		end
	end
end

question:pattern('[&ET "et" | "ni" ]')
question:pattern('[&UNIQUEMENT "uniquement" | "seulement" | "juste" | ("rien" "d" "\'" "autre" ) ]')
question:pattern('[&OU "ou"]')
question:pattern('[&AVEC "avec"]')
question:pattern('[&SANS "sans"]')
question:pattern('[&synonymesCuisiner "faire" | /^pr[ée]parer$/ | "cuisiner" | "concocter" ]')
question:add(tagNomRecette)


question:pattern('[&cDuree [&valeur &NUM] [&unite ( "h" | /^heure/ | /^min/ )] ]')
question:pattern('[&cIngredients ([&ingredient (&valeur &unite "de")? &aliment] .*?)+]')
question:pattern('[&cOutils (&outil .*?)+]')
question:pattern('[&critere &cDuree | &cOutils | &cIngredients | &origine | &prix | cPopularite ]')
question:pattern([[
	[&qListeRecettes
		^ /^[Qq]u/ .* ( &synonymesCuisiner | "recettes" | /^plat/ | /^dessert/ | /^entr[ée]e/ ) .* &critere .*
	]
]])

question:pattern('[&qRecette ( /^[Qq]u/ .* "recette" |  /omment$/ &synonymesCuisiner ) .* ]')
question:pattern('[&qDuree .* /ombien$/ "de" "temps" .* ]')
question:pattern('[&qCuisson .* "temps" "de" "cuisson" .* ]')
question:pattern('[&qPreparation .* "temps" "de" /^pr[ée]paration$/ .* ]')
question:pattern('[&qPourCombien .* /^[Pp]our$/ ("combien" | "quelle" /^quantit/) .* ]')
question:pattern('[&qQuantite .* ("combien" | "quelle" /^quantit/) .* &aliment .* ]')
question:pattern('[&qIngredients .* /^[Qq]u/ .* (/^ingr[ée]dient/ | /^aliment/) .* ]')

question:pattern('[&question &qRecette | &qListeRecettes | &qDuree | &qCuisson | &qPreparation | &qPourCombien | &qQuantite | &qIngredients]')