# Configuration Claude Code — API Backend

## Framework
Ce projet utilise ai-dev-framework. Langue : français.

## Agents disponibles
orchestrator · architect · stack-advisor · backend-dev
debug · test-engineer · code-reviewer · doc-writer · verifier

## Commandes disponibles
/new-project · /add-feature · /debug-issue
/stack-advisor · /jwt-auth · /rest-crud · /schema-design · /tdd-workflow

## Mémoire projet — lire avant toute action
1. memory/project-context.md
2. memory/stack.md
3. memory/architecture.md
4. memory/conventions/
5. memory/decisions/
6. memory/progress.md

## Contexte API Backend — règles spécifiques

Versioning : toutes les routes sont préfixées par /v1/ (ou la version courante).
Ne jamais supprimer une version mineure sans période de dépréciation.

Contrat API : chaque changement de schéma de réponse est un breaking change.
Documenter les breaking changes dans un CHANGELOG.

Rate limiting : appliquer sur toutes les routes publiques.
Retourner 429 avec un header Retry-After.

## Règles fondamentales

Ne jamais implémenter sans avoir relu memory/ en entier.
Toujours TDD : tests avant implémentation.
Mettre à jour memory/progress.md en fin de session.
Après chaque erreur découverte : "Mets à jour CLAUDE.md pour ne pas refaire cette erreur."
