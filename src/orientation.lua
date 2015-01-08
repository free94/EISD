local orientation = dark.pipeline()
orientation:pattern([[
	[&orientation
		( /^lutte/ | /capitaliste/ | /^[Sc]ocialiste/ | /^[Cc]ommuniste/ | /libéral/ | /^ouvrière/ | /^mix/ | /^gauch/ | /^centre$/ | /^droite$/ | /^anarchiste/ | /^révolution/ )
	]
]])

local tags = {
	orientation = "green",
}

for line in io.lines() do
	line = line:gsub("(%p)", " %1 ")
	print(orientation(line):tostring(tags))
end