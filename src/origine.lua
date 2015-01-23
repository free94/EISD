origine = dark.pipeline()
origine:lexicon("&origines", "lexicon/gentiles.txt")
origine:pattern([[
	[&origine
	(/^[Dd]$/ .? origine (&ADJ | /^%u/*)) | ( .? /^%à$/ .? .? origine) | (&origines)
	]
 ]])
