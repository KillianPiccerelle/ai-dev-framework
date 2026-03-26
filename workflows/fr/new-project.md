---
name: new-project
description: Démarre un nouveau projet de zéro. Cadrage, stack, architecture, structure.
---

# Workflow : nouveau projet

Ce workflow ne produit pas de code. Il prépare tout ce qui est nécessaire
pour que le développement puisse commencer dans de bonnes conditions.

## Étape 1 — Cadrage (agent : orchestrator)

Poser ces six questions à l'utilisateur. Attendre toutes les réponses avant de continuer.

1. Quel problème cette application résout-elle ? (1 à 3 phrases)
2. Qui sont les utilisateurs et quel est leur job-to-be-done exact ?
3. Quelles sont les contraintes non-fonctionnelles critiques ? (performance, sécurité, conformité)
4. Quelle est la date cible pour la v1 ?
5. Quelle est la tolérance au risque technique ? (expérimentation vs choix éprouvés)
6. Quelles ressources sont disponibles ? (taille d'équipe, budget infra, compétences)

Produire : memory/project-context.md

## Étape 2 — Choix de stack (skill : /stack-advisor)

Invoquer le skill stack-advisor avec les réponses du cadrage.
Produire : memory/stack.md

Présenter le résultat à l'utilisateur et attendre sa validation avant de continuer.

## Étape 3 — Architecture (agent : architect)

Concevoir l'architecture selon la stack validée.
Identifier les composants principaux et leurs responsabilités.
Dessiner les flux de données en ASCII.
Identifier les risques techniques.

Produire : memory/decisions/ADR-001-architecture.md

Présenter et attendre validation avant de continuer.

## Étape 4 — Conventions (agent : architect)

Définir les conventions spécifiques à ce projet :
nommage des fichiers et variables, format de gestion des erreurs,
format des commits, structure des répertoires.

Produire :
- memory/conventions/naming.md
- memory/conventions/error-handling.md
- memory/conventions/commit-format.md

## Étape 5 — Structure de projet

Créer la structure de répertoires et les fichiers de base selon
le type de projet détecté lors du cadrage.
Créer un .env.example avec toutes les variables d'environnement nécessaires.
Initialiser le dépôt git avec un premier commit.

## Étape 6 — Récapitulatif

Présenter à l'utilisateur : ce qui a été créé, les fichiers mémoire
générés, et la commande pour démarrer la première feature : /add-feature
