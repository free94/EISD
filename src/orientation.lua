orientation = dark.pipeline()
orientation:pattern([[
	[&orientation
		( /capitaliste/ | /^[Sc]ocialiste/ | /^[Cc]ommuniste/ | /libéral/ | ( /^extrême$/? /^-$/? ( /^gauch/ | /^droite$/ ) )  | /^centre$/ | /^anarchiste/ | /^révolution/ )
	]
]])
