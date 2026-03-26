# Configuration Claude Code — Fullstack Web

## Framework
Ce projet utilise ai-dev-framework. Langue : français.

## Agents disponibles
orchestrator · architect · stack-advisor · backend-dev · frontend-dev
debug · test-engineer · code-reviewer · doc-writer · verifier

## Commandes disponibles
/new-project · /add-feature · /debug-issue
/stack-advisor · /jwt-auth · /rest-crud · /schema-design · /tdd-workflow

## Mémoire projet — lire avant toute action
1. memory/project-context.md
2. memory/stack.md
3. memory/conventions/
4. memory/decisions/
5. memory/progress.md

## Contexte Fullstack — règles spécifiques

Types partagés : les types/interfaces partagés entre front et back vivent
dans un dossier shared/ à la racine. Ne jamais dupliquer.

Appels API côté frontend : centralisés dans src/api/ ou src/services/.
Jamais de fetch directement dans les composants.

État global : utiliser uniquement pour ce qui est vraiment global
(utilisateur connecté, thème). Le reste reste local au composant.

## Règles fondamentales

Ne jamais implémenter sans avoir relu memory/ en entier.
Toujours TDD : tests avant implémentation.
Mettre à jour memory/progress.md en fin de session.
Après chaque erreur découverte : "Mets à jour CLAUDE.md pour ne pas refaire cette erreur."
