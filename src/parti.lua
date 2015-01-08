parti = dark.pipeline()
parti:pattern([[
	[&role
		( /^[Cc]andidat/ | /^[Aa]dhèr/ | /^[Pp]résid/ | ( /^[Ss]ecrétaire$/ /^nationale?$/? ) | /^[Dd]éputée?$/ )
	]
]])

parti:pattern([[
	[&adhesion
			( /^rejoin/ | /^cré[eaé]$/ | /^dirige/ )
	]
]])
parti:pattern([[
	[&det
		( /^d[eu]s?$/ | /^l[ea]?s?$/ | /^à$/ | au ) /^'$/?
	]
]])

parti:pattern([[
	[&expression_parti
		(
			( &role | &adhesion )
			&det*
			[&parti
				/^[Pp]arti$/? /^%u/ ( /^%u/ | &det )* ( /^%($/ /^[A-Z][A-Z]+$/ /^%)$/ )?
			]
		) | (
			[&parti
				/^[Pp]arti$/ &NNC
			]
		)
	]
]])
