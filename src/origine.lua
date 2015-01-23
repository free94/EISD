origine = dark.pipeline()

origine:pattern([[
	[&origine
	(/^[Dd]$/ .? origine (&ADJ | /^%u/*)) | ( .? /^%à$/ .? .? origine)
	]
 ]])
