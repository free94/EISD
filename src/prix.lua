prix = dark.pipeline()

prix:pattern([[
	[&prix	 
		(/^pas/? /^peu/? /^très/? /^tres/? /^assez/? /^super/? /^hyper/? /^archi/? /^pas du tout/? /^fort/? (/^cher/ | /^couteu/ | /^onéreu/))
	]
	]])