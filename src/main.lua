require('etape')
require('quantite')
require('structure')
<<<<<<< HEAD
require('origine')
require('outil')
=======
--require('origine')
require ('outil')
>>>>>>> 944d394b33dcf83e0d94467bbe9bb7f0168045d9

main = dark.pipeline()
main:model("model/postag-fr")
main:add(etape)
main:add(quantite)
main:add(structure)
--main:add(origine)
main:add(outil)

-- tags a afficher
tags = {
	etape    = 'red',
	quantite = 'green',
	valeur   = 'green',
	unite    = 'green',
	temps_preparation = 'yellow',
	temps_cuisson = 'yellow',
	ingredients = 'yellow',
	preparation = 'yellow',
	manipulation = 'yellow',
	extra = 'yellow',
	--origine  = 'magenta',
	outil = 'cyan',
}

seq = main(io.read('*all'):gsub('%p', ' %1 '))
-- seq:dump()
print(seq:tostring(tags))
