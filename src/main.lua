-- require('file')
require('etape')

main = dark.pipeline()
main:model("model/postag-fr")
--main:add(pipeline)
main:add(etape)

-- tags a afficher
tags = {
-- tag = 'color'
	etape = 'red'
}

-- affichage
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
  --seq:dump()
end
