require('quantite')

main = dark.pipeline()
main:model("model/postag-fr")
main:add(quantite)

-- tags a afficher
tags = {
  quantite = 'red',
  valeur = 'red',
  unite = 'red',
}

-- affichage
for line in io.lines() do
  seq = main(line:gsub('%p', ' %1 '))
  print(seq:tostring(tags))
  seq:dump()
end
