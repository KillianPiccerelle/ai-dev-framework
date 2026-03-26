---
name: refactor
description: >
  Refactorise du code existant sans modifier son comportement.
  Analyse d'abord, propose un plan, attend validation, exécute.
---

# Workflow : refactoriser du code

## Règle fondamentale

Un refactoring ne change pas le comportement observable du code.
Si un test casse pendant le refactoring, c'est une régression — pas
du refactoring. Arrêter et corriger avant de continuer.

---

## Étape 1 — Définir le périmètre

Demander à l'utilisateur :
- Quel fichier, dossier, ou composant refactoriser ?
- Quel est l'objectif ? (lisibilité, performance, structure, dette technique)
- Y a-t-il des contraintes ? (compatibilité API, pas de changement d'interface)

---

## Étape 2 — Vérifier l'état des tests (agent : test-engineer)

Avant de toucher quoi que ce soit, vérifier que les tests existants passent.
Si des tests échouent déjà, stopper et signaler à l'utilisateur.
Un refactoring sur du code avec des tests en échec est impossible à valider.

Résultat attendu : "X tests passent, 0 en échec — refactoring possible."

---

## Étape 3 — Analyse du code cible (agent : code-reviewer)

Analyser le périmètre défini et identifier les problèmes concrets :
- Code dupliqué (DRY)
- Fonctions trop longues (> 30 lignes est un signal)
- Nommage peu clair ou trompeur
- Couplage fort entre modules
- Responsabilités mélangées dans un même composant
- Complexité cyclomatique élevée

Produire une liste priorisée des problèmes avec une estimation d'effort
pour chacun (petit / moyen / important).

---

## Étape 4 — Proposition du plan (orchestrator)

Présenter à l'utilisateur la liste des problèmes et le plan de refactoring.
Demander explicitement : "Quels points veux-tu traiter dans cette session ?"

Ne jamais refactoriser tout d'un coup. Travailler par petits incréments
validés. Un refactoring de 500 lignes sans tests intermédiaires est risqué.

Attendre validation avant de continuer.

---

## Étape 5 — Exécution incrémentale (agent : backend-dev ou frontend-dev)

Pour chaque point validé, dans l'ordre :
1. Faire le changement minimal
2. Relancer les tests immédiatement
3. Si les tests passent → continuer au point suivant
4. Si un test casse → annuler ce changement, analyser pourquoi, signaler

Commits atomiques : un commit par problème résolu, avec un message clair.
Format : `refactor(scope): description du changement`

---

## Étape 6 — Vérification finale (agent : verifier)

Vérifier que :
- Tous les tests qui passaient avant passent encore
- La couverture de tests n'a pas diminué
- Aucun TODO ou FIXME n'a été introduit

---

## Étape 7 — Mise à jour mémoire

Si le refactoring change des conventions ou des patterns :
mettre à jour memory/conventions/ et memory/architecture.md.
Mettre à jour memory/progress.md.
