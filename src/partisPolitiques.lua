local partis = dark.pipeline()
partis:pattern([[
	[&role
		( /^[Cc]andidat/ | /^[Aa]dhèr/ | /^[Pp]résid/ | ( /^[Ss]ecrétaire$/ /^nationale?$/? ) | /^[Dd]éputée?$/ )
	]
]])

partis:pattern([[
	[&adhesion
			( /^rejoin/ | /^cré[eaé]$/ | /^dirige/ )
	]
]])
partis:pattern([[
	[&det
		( /^d[eu]s?$/ | /^l[ea]?s?$/ | /^à$/ | au ) /^'$/?
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

local tags = {
	parti = "red",
}

for line in io.lines() do
	line = line:gsub("(%p)", " %1 ")
	print(partis(line):tostring(tags))
end