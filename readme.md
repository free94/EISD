# Etiquetteur

## Arborescence

A la racine se trouvent les pipelines (dans leurs fichiers respectifs) DARK et le pipeline principal (`main.lua`).

- `biographies` : corpus de biographies à étiquetter
- `doc` : documentations
- `lexiques` : lexiques
- `src` : code source de DARK

## Ajouter un pipeline au pipeline principal

1. Placer le fichier contenant le pipeline à la racine
2. Inclure le fichier dans `main.lua` avec `require('fichier')` (sans l'extension .lua)
3. Ajouter le pipeline au pipeline principal dans `main.lua` avec `main:add(pipeline)`
4. Ajouter les tags à afficher dans `main.lua` en completant la liste `tags`
