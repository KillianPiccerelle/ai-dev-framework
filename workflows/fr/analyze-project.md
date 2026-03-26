---
name: analyze-project
description: >
  Analyse un projet existant et génère automatiquement les fichiers memory/.
  Gère la migration d'un CLAUDE.md existant. Non-destructif.
---

# Workflow : analyser un projet existant

Ce workflow est non-destructif. Il ne modifie jamais le code source,
ne supprime aucun fichier existant, et ne force jamais d'écrasement.

## Précondition

Se placer à la racine du projet à analyser avant de lancer ce workflow.

---

## Étape 1 — Détection du contexte existant (orchestrator)

Vérifier la présence de ces indicateurs :

**Projet avec configuration Claude existante :**
- CLAUDE.md présent → workflow de migration (voir étape 2A)
- .claude/ présent → intégrer les commandes et settings existants
- memory/ présent → lire les fichiers existants, ne pas les écraser

**Projet sans configuration Claude :**
- Aller directement à l'étape 2B

---

## Étape 2A — Migration d'un CLAUDE.md existant

Si un CLAUDE.md existe et n'est pas au format du framework :

1. Renommer l'ancien fichier : `mv CLAUDE.md CLAUDE.backup.md`
2. Ajouter CLAUDE.backup.md au .gitignore
3. Extraire le contenu de l'ancien CLAUDE.md :
   - Règles personnalisées → seront intégrées dans memory/conventions/
   - Contexte projet → sera intégré dans memory/project-context.md
   - Instructions agents → seront intégrées dans le nouveau CLAUDE.md
4. Informer l'utilisateur : "CLAUDE.md migré. L'ancien fichier est conservé
   dans CLAUDE.backup.md. Supprime-le quand tu auras vérifié la migration."

Si CLAUDE.md est déjà au format du framework, passer à l'étape 3 directement.

---

## Étape 2B — Initialisation pour un projet sans configuration

Créer la structure minimale :
```
mkdir -p memory/decisions memory/conventions memory/domain
mkdir -p .claude/commands
```

---

## Étape 3 — Analyse approfondie (agent : project-analyzer)

Lancer l'agent project-analyzer sur l'ensemble du projet.

L'agent produit les fichiers memory/ manquants :
- memory/project-context.md
- memory/stack.md
- memory/architecture.md
- memory/progress.md
- memory/conventions/naming.md
- memory/conventions/error-handling.md
- memory/conventions/commit-format.md
- memory/domain/glossary.md (si applicable)

**Règle** : l'agent ne génère que les fichiers absents.
Si memory/stack.md existe déjà, il est lu mais pas modifié.

---

## Étape 4 — Génération du nouveau CLAUDE.md

Générer un CLAUDE.md adapté au projet analysé.

Ce fichier doit :
- Référencer les fichiers memory/ à lire avant toute action
- Lister les agents et skills disponibles
- Intégrer les règles extraites de l'ancien CLAUDE.md (si migration)
- Préciser le type de projet détecté (saas, api-backend, fullstack-web, autre)

---

## Étape 5 — Installation des workflows

Copier les workflows du framework dans .claude/commands/ :
- /new-project, /add-feature, /debug-issue, /refactor, /gen-tests

**Règle** : ne pas écraser les workflows personnalisés déjà présents.
Si un fichier .claude/commands/add-feature.md existe déjà avec du contenu
personnalisé, le conserver. Proposer la version du framework sous le nom
add-feature.framework.md pour comparaison.

---

## Étape 6 — Récapitulatif et validation (orchestrator)

Présenter à l'utilisateur :

**Fichiers générés :**
- Liste de tous les fichiers memory/ créés

**Fichiers conservés (existaient déjà) :**
- Liste des fichiers non modifiés

**Migration effectuée :**
- CLAUDE.md → CLAUDE.backup.md + migration vers memory/
- (ou : aucune migration nécessaire)

**Prochaines étapes recommandées :**
1. Vérifier memory/project-context.md et compléter les placeholders
2. Vérifier memory/stack.md et corriger si nécessaire
3. Supprimer CLAUDE.backup.md une fois la migration vérifiée
4. Utiliser /add-feature pour commencer à travailler sur le projet
