quantite = dark.pipeline()

quantite:pattern("[&NUM /^[0-9]+$/ ]")
quantite:pattern([[
  [&quantite
    [&valeur &NUM+ &PCT? &NUM* ]
    [&unite /%a+/ ]
  ]
]]
)
