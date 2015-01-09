quantite = dark.pipeline()
quantite:pattern([[
  [&quantite
    [&valeur /%d+/]
    [&unite /%a+/]
  ]
]]
)
