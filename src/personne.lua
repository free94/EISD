local personne = dark.pipeline()
personne:model("model/postag-fr")

--créer un lexique de prénoms en parcourant une liste de prénoms classiques (permet de couvrir la majorité des cas)
personne:lexicon("&prenom", "../lexiques/prenoms-fr.txt") --AVEC un prénom par ligne!

personne:pattern("[&SL /^%/$/]") --SL pour slash : création tag SL, reconnaissance du slash grâce à un tag
personne:pattern("[&NP &DET? &ADJ* (&NNC | &NNP)+ &ADJ* ] ")
personne:pattern("[&PRENOMS (&prenom+ (/^-$/ &prenom)*)]")--Permet de prendre en compte les prénoms composés avec tiret par exemple Jean-Marie
personne:pattern("[&PER ( &PRENOMS [&nom(&NNP | /^%u/)*])]")--On prend en compte les noms composés de multiples token par exemple 'Le Pen'

--on considère uniquement le cas où le nom de famille succède le prénom! évite les soucis tels que "Vive Jacques Chirac où Vive est considéré comme le nom de famille !"
local tag = {
	
	PRENOMS = "red",
	--NP = "cyan",
	PER = "yellow",
	SL = "black",
	mois = "yellow"	,
	nom = "dark",
	prenom ="magenta",
	ne_le = "magenta"
}

for line in io.lines() do
	--tokenisation la plus basique
	local seq = personne(line:gsub("%p", " %1 ")) --on remplace chaque ponctuation par "EspacePonctuationEspace"
	--affichage quasi tabulaire
	seq:dump()
	print(seq:tostring(tag))
end