---
name: add-feature
description: Ajoute une fonctionnalité au projet en suivant TDD. Architecture → Tests → Implémentation → Review → Doc.
---

# Workflow : ajouter une fonctionnalité

## Précondition obligatoire

Lire entièrement memory/ avant de commencer :
memory/project-context.md, memory/stack.md, memory/conventions/, memory/decisions/

Ne pas démarrer si ces fichiers n'existent pas. Proposer /new-project à la place.

## Étape 1 — Analyse d'impact (agent : architect)

Avant d'écrire quoi que ce soit, l'agent architect :
- Vérifie la cohérence de la feature avec les ADRs existants
- Identifie les composants existants impactés par cette feature
- Identifie les dépendances entre la nouvelle feature et l'existant
- Si une nouvelle décision architecturale est nécessaire, crée un ADR avant de continuer

Produire : plan d'implémentation en quelques points clairs

Valider avec l'utilisateur avant de passer à l'étape 2.

## Étape 2 — Tests d'abord (agent : test-engineer)

L'agent test-engineer écrit tous les tests qui décrivent le comportement attendu.
Les tests DOIVENT échouer à cette étape (RED).

Couvrir : cas nominal, cas limites, cas d'erreur, permissions.

## Étape 3 — Implémentation (agent : backend-dev ou frontend-dev)

L'agent approprié implémente le minimum de code pour faire passer les tests (GREEN).
Il respecte memory/conventions/ et ne contredit aucun ADR.

## Étape 4 — Refactoring (agent : backend-dev ou frontend-dev)

Améliorer le code sans modifier le comportement (REFACTOR).
Tous les tests doivent rester verts.
Supprimer le code dupliqué, améliorer les noms, simplifier la logique.

## Étape 5 — Review (agent : code-reviewer)

Audit en lecture seule. L'agent identifie les problèmes sans les corriger.
Si verdict REFUSÉ : corriger les points BLOQUANTS puis relancer la review.

## Étape 6 — Sécurité (agent : security-reviewer, si applicable)

À invoquer si la feature : expose des données utilisateur, accepte des inputs
externes, touche à l'authentification ou aux permissions, manipule des paiements.

## Étape 7 — Documentation (agent : doc-writer)

Mettre à jour la documentation affectée par la feature.

## Étape 8 — Validation finale (agent : verifier)

L'agent verifier valide que tout est en ordre.
Si la checklist est incomplète, corriger avant de considérer la feature terminée.

## Étape 9 — Mise à jour mémoire

Mettre à jour memory/progress.md avec la feature livrée.
