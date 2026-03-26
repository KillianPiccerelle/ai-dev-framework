---
name: gen-tests
description: >
  Génère des tests pour du code existant. Audit de couverture d'abord,
  puis génération ciblée sur les zones non couvertes.
---

# Workflow : générer des tests

Ce workflow couvre deux cas : code sans aucun test, et code avec tests
partiels. Dans les deux cas, l'audit de l'existant précède toujours
la génération.

---

## Étape 1 — Définir le périmètre

Demander à l'utilisateur :
- Quel fichier, dossier, ou module tester ?
- Y a-t-il déjà des tests pour certaines parties ?
- Quel niveau de tests cibler ? (unitaires, intégration, e2e, ou les trois)

---

## Étape 2 — Audit de la couverture existante (agent : test-engineer)

Analyser l'existant :

Si un outil de couverture est configuré (jest --coverage, pytest-cov,
go test -cover) : lancer la commande et lire le rapport.

Si aucun outil n'est configuré : analyser manuellement les fichiers
de test existants et les fichiers source pour identifier les zones
sans tests.

Produire un rapport d'audit :
- Fonctions/méthodes sans test
- Chemins d'erreur non couverts
- Cas limites non testés
- Couverture approximative si mesurable

---

## Étape 3 — Priorisation (orchestrator)

Présenter le rapport à l'utilisateur et prioriser ensemble :

Priorité haute — à couvrir en premier :
- Chemins critiques (auth, paiement, permissions)
- Fonctions avec des effets de bord importants
- Logique métier complexe

Priorité normale :
- CRUD standard
- Validation des inputs
- Transformations de données

Priorité basse :
- Fonctions utilitaires simples
- Code généré automatiquement

Attendre validation de la priorisation avant de continuer.

---

## Étape 4 — Génération des tests (agent : test-engineer)

Pour chaque zone identifiée comme prioritaire, générer les tests
en respectant le comportement actuel du code (pas ce qu'il devrait
faire, ce qu'il fait réellement).

Règles de génération :
- Lire le code source et comprendre le comportement avant d'écrire
- Chaque test couvre UN comportement
- Nommer le test de façon descriptive :
  `should return 404 when user does not exist`
- Couvrir : cas nominal, cas limites, cas d'erreur

Utiliser le framework de test déjà présent dans le projet.
Ne pas introduire un nouveau framework de test.

---

## Étape 5 — Vérification que les tests générés passent

Lancer les tests générés. Ils doivent tous passer.
Si un test échoue, deux cas possibles :
1. Le test est mal écrit (corriger le test)
2. Le test révèle un bug existant (signaler à l'utilisateur — ne pas
   modifier le code pour faire passer le test, créer une issue à la place)

---

## Étape 6 — Rapport final (agent : verifier)

Produire un rapport de synthèse :
- Nombre de tests ajoutés
- Couverture avant / après (si mesurable)
- Zones encore non couvertes avec justification
- Bugs potentiels découverts pendant la génération

Mettre à jour memory/progress.md.
