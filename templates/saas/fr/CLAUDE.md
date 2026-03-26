# Configuration Claude Code — Projet SaaS

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

## Contexte SaaS — règles spécifiques

Multi-tenancy : toute requête base de données doit filtrer par tenant_id.
Jamais de requête sans WHERE tenant_id = :current_tenant.
Tester l'isolation entre tenants sur chaque endpoint.

Billing : ne jamais stocker de données de carte bancaire.
Utiliser les webhooks du provider de paiement pour synchroniser l'état.
Les événements de paiement sont idempotents.

Organisations et membres : un utilisateur peut appartenir à plusieurs
organisations avec des rôles différents dans chacune.
Vérifier toujours organization_id ET user_id ET role avant d'autoriser.

## Règles fondamentales

Ne jamais implémenter sans avoir relu memory/ en entier.
Ne jamais contredire un ADR sans en créer un nouveau.
Toujours TDD : tests avant implémentation.
Mettre à jour memory/progress.md en fin de session.
Après chaque erreur découverte : "Mets à jour CLAUDE.md pour ne pas refaire cette erreur."
