personne = dark.pipeline()

--créer un lexique de prénoms en parcourant une liste de prénoms classiques (permet de couvrir la majorité des cas)
personne:lexicon("&prenom", "../lexiques/prenoms-fr.txt") --AVEC un prénom par ligne!

personne:pattern("[&SL /^%/$/]") --SL pour slash : création tag SL, reconnaissance du slash grâce à un tag
personne:pattern("[&NP &DET? &ADJ* (&NNC | &NNP)+ &ADJ* ] ")
personne:pattern("[&prenoms (&prenom+ (/^-$/ &prenom)*)]")--Permet de prendre en compte les prénoms composés avec tiret par exemple Jean-Marie
personne:pattern("[&personne ( &prenoms [&nom(/^%u/)*])]")--On prend en compte les noms composés de multiples token par exemple 'Le Pen'

--on considère uniquement le cas où le nom de famille succède le prénom! évite les soucis tels que "Vive Jacques Chirac où Vive est considéré comme le nom de famille !"
