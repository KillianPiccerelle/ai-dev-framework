---
name: debug-issue
description: Analyse et résout un bug. Cause racine obligatoire avant tout fix.
---

# Workflow : déboguer un problème

## Règle absolue

Aucun fix sans avoir identifié la cause racine.
Un fix sans investigation est une dette technique — le bug reviendra.

## Étape 1 — Description précise

Demander à l'utilisateur :
- Quel est le comportement observé ?
- Quel est le comportement attendu ?
- Dans quelles conditions le bug se reproduit-il ?
- Depuis quand le bug existe-t-il ? (quel commit si possible)

## Étape 2 — Reproduction (agent : debug)

Écrire un test minimal qui reproduit le bug de façon fiable.
Si le bug ne peut pas être reproduit, demander plus d'informations.
Un bug non reproductible ne peut pas être fixé proprement.

## Étape 3 — Investigation (agent : debug)

Tracer le flux de données depuis l'input jusqu'à l'endroit où le
comportement dévie. Formuler 3 hypothèses classées par probabilité.
Tester chaque hypothèse dans l'ordre.

## Étape 4 — Fix (agent : backend-dev ou frontend-dev)

Implémenter le fix uniquement une fois la cause confirmée.
Le fix doit être minimal — ne corriger que ce qui est cassé.
Le test de reproduction devient un test de régression permanent.

## Étape 5 — Vérification (agent : verifier)

Vérifier que le fix résout le bug sans introduire de régression.

## Étape 6 — Documentation

Si le bug révèle un angle mort dans les conventions ou l'architecture :
mettre à jour memory/conventions/ ou créer un ADR.
Mettre à jour memory/progress.md.
