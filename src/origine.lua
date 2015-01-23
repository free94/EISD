origine = dark.pipeline()
origine:model("model/postag-fr")

origine:pattern([[
	[&origine
	(/^[Dd]$/ .? origine (&ADJ | /^%u/*)) | ( .? /^%à$/ .? .? origine)
	]
 ]])