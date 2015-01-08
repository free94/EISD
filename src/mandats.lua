local mandat = dark.pipeline()
mandat:model("model/postag-fr")

--créer un lexique lié aux mandats (permet de couvrir la majorité des cas)
--mandat:lexicon("&mandat", "../lexiques/mandats.txt")

mandat:pattern("[&NUMS /^%d+$/]")
mandat:pattern("[&mandat &role .? .? .? &NNC (.? .? .? &date)?]")
--mandat:pattern("[&dateMandat &mandat .? .? .? &NUMS]")
local tag = {
	
	mandat = "magenta",
	PRENOMS = "red",
	--NP = "cyan",
	PER = "yellow",
	SL = "black",
	mois = "yellow"	,
	nom = "dark",
	dateMandat = "red",
}

for line in io.lines() do
	--tokenisation la plus basique
	local seq = mandat(line:gsub("%p", " %1 ")) --on remplace chaque ponctuation par "EspacePonctuationEspace"
	--affichage quasi tabulaire
	seq:dump()
	print(seq:tostring(tag))
end