quantite = dark.pipeline()
quantite:pattern([[
  [&quantite
    [&valeur &NUM+ &PCT? &NUM* ]
    [&unite /%a+/]
  ]
]]
)
