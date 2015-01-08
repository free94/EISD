mandat = dark.pipeline()

--créer un lexique lié aux mandats (permet de couvrir la majorité des cas)
--mandat:lexicon("&mandat", "../lexiques/mandats.txt")

mandat:pattern("[&NUMS /^%d+$/]")
mandat:pattern("[&mandat &role .? .? .? &NNC (.? .? .? &date)?]")
--mandat:pattern("[&dateMandat &mandat .? .? .? &NUMS]")
