-- require('file')

main = dark.pipeline()
main:model("model/postag-fr")
--main:add(pipeline)

-- tags a afficher
tags = {
-- tag = 'color'
}

-- affichage
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
  -- seq:dump()
end
