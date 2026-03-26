# Format des commits

Utiliser le format Conventional Commits :

type(scope): description courte

Types autorisés :
- feat     : nouvelle fonctionnalité
- fix      : correction de bug
- docs     : documentation uniquement
- refactor : refactoring sans changement de comportement
- test     : ajout ou modification de tests
- chore    : maintenance, dépendances, config

Exemples :
feat(auth): ajouter le endpoint de refresh token
fix(api): corriger la pagination sur les notes vides
docs(readme): mettre à jour les instructions d'installation
test(auth): ajouter les tests de révocation de token

Règles :
- Description en minuscules, sans point final
- Maximum 72 caractères
- Corps du commit en français si nécessaire
