mandat = dark.pipeline()
mandat:model("model/postag-fr")

--créer un lexique lié aux mandats (permet de couvrir la majorité des cas)
--mandat:lexicon("&mandat", "../lexiques/mandats.txt")

mandat:pattern("[&NUMS /^%d+$/]")

mandat:pattern([[
[&mandat
(/^[Pp]résident/ | /^[Mm]inistre/ | /^[Cc]hef/ | /^[Rr]esponsable/  | /^[Dd]irigeant/ | /^[Ss]ecrétaire/)
.? .? .? &NNC
(.? .? .? &date)?
]
]])
