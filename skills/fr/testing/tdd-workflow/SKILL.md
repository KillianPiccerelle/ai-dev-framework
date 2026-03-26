---
name: tdd-workflow
description: >
  Applique la méthodologie TDD : RED → GREEN → REFACTOR.
  Invoquer avant toute implémentation pour cadrer le travail.
tags: [testing, tdd, quality]
---

Le TDD se déroule en trois phases strictement ordonnées.

PHASE RED — Écrire les tests qui échouent
Avant d'écrire une ligne d'implémentation, écrire tous les tests
qui décrivent le comportement attendu. Vérifier que tous échouent
(si un test passe sans implémentation, il ne teste rien d'utile).

Un bon test est : lisible comme de la documentation, indépendant des
autres tests, rapide à exécuter, et déterministe (même résultat à chaque fois).

PHASE GREEN — Implémenter le minimum
Écrire le minimum de code pour faire passer les tests. Pas d'optimisation,
pas de refactoring, pas de code "pour plus tard". Juste ce qui est
nécessaire pour passer de rouge à vert.

PHASE REFACTOR — Améliorer sans casser
Améliorer le code (lisibilité, performance, structure) en gardant tous
les tests verts. C'est la seule phase où on peut réorganiser le code
sans ajouter de comportement.

Couverture cible : 80% minimum sur les lignes, 100% sur les chemins critiques
(auth, paiement, sécurité).

À la fin de chaque cycle RED-GREEN-REFACTOR, vérifier :
- Tous les tests passent
- Aucune régression sur les tests existants
- La couverture n'a pas baissé
