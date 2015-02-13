prix = dark.pipeline()

prix:pattern([[
		[&prix
			[&pasCher ((/^pas/ | /^peu/? | /^pas du tout/?)  (/^cher/ | /^chèr/ | /^couteu/ | /^onéreu/))] |
			[&cher ((/^très/? /^tres/? /^assez/? /^super/? /^hyper/? /^archi/? /^fort/?) (/^cher/ | /^chèr/ | /^couteu/ | /^onéreu/ | /^onereu/))] |
			[&cout (.? (/^couté/ | /^coute/) (&valeur &unite )) |	(/^[0-9]+[€]/)]
		]	
	]])