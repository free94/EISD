partis = dark.pipeline()
partis:pattern([[
	[&role
		( /^[Cc]andidat/ | /^[Aa]dh�r/ | /^[Pp]r�sid/ | ( /^[Ss]ecr�taire$/ /^nationale?$/? ) | /^[Dd]�put�e?$/ )
	]
]])

partis:pattern([[
	[&adhesion
			( /^rejoin/ | /^cr�[ea�]$/ | /^dirige/ )
	]
]])
partis:pattern([[
	[&det
		( /^d[eu]s?$/ | /^l[ea]?s?$/ | /^�$/ | au ) /^'$/?
	]
]])

partis:pattern([[
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
