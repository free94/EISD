avis = dark.pipeline()

avis:pattern("[&avispotentiel (/[^%-=]/)+ ]")
avis:pattern("[&avis &avispotentiel  (/[%-=]/ &avispotentiel)* ]")

tags = {
	avis = 'red'
}

-- affichage
seq = avis(io.read("*all"):gsub('%p', ' %1 '))
print(seq:tostring(tags))
--seq:dump()