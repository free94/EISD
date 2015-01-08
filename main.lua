-- pipelines

-- require('file')
require('date')

main = dark.pipeline()
-- main:add(pipeline)
main:add(date)

-- tags a afficher
tags = {
  -- tag = 'color',
  jour  = 'yellow',
  mois  = 'yellow',
  annee = 'yellow',
  date  = 'red',
}

-- affichage
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
end
