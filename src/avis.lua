avis = dark.pipeline()

avis:pattern("[&avispotentiel (/[^%-=]/)+ ]")
avis:pattern("[&avis &avispotentiel  (/[%-=]/ &avispotentiel)* ]")