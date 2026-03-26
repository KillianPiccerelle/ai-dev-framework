# ai-dev-framework v3 — Configuration Claude Code

## Langue
Français

## Agents disponibles

Copier les fichiers de `agents/` dans `~/.claude/agents/` pour les activer globalement.
Invocation : "utilise l'agent [nom]" ou naturellement dans Claude Code.

| Agent | Rôle | Modèle |
|-------|------|--------|
| orchestrator | Coordonne et délègue aux autres agents | sonnet |
| architect | Conçoit l'architecture, produit des ADRs | opus |
| stack-advisor | Recommande la stack technique | sonnet |
| project-analyzer | Analyse les projets existants, génère memory/ | opus |
| codebase-analyst | Analyse profonde du repo, supporte les autres agents | sonnet |
| backend-dev | Implémente l'API, la BDD, la logique métier | sonnet |
| frontend-dev | Implémente l'UI, les composants, l'état | sonnet |
| debug | Analyse les bugs, trouve la cause racine | sonnet |
| test-engineer | Écrit les tests, applique TDD | sonnet |
| qa-engineer | Tests avancés, edge cases, détection sécurité | sonnet |
| code-reviewer | Audite le code en lecture seule | sonnet |
| doc-writer | Rédige et met à jour la documentation | sonnet |
| verifier | Valide le travail accompli | haiku |

## Skills disponibles

| Skill | Commande | Usage |
|-------|----------|-------|
| Stack Advisor | `/stack-advisor` | Recommande une stack selon le projet |
| JWT Auth | `/jwt-auth` | Implémente l'authentification JWT |
| REST CRUD | `/rest-crud` | Crée un endpoint REST complet |
| Schema Design | `/schema-design` | Conçoit un schéma de base de données |
| TDD Workflow | `/tdd-workflow` | Applique la méthodologie TDD |

## Workflows disponibles

Copier les fichiers de `workflows/` dans `.claude/commands/` du projet.

| Workflow | Commande | Usage |
|----------|----------|-------|
| Nouveau projet | `/new-project` | Démarre un projet de zéro |
| Analyser un projet | `/analyze-project` | Analyse un projet existant, génère memory/ |
| Cartographier | `/map-project` | Génère la carte complète du projet |
| Ajouter une feature | `/add-feature` | Ajoute une feature avec TDD complet |
| Déboguer | `/debug-issue` | Analyse de cause racine et correction |
| Refactoriser | `/refactor` | Refactoring incrémental sécurisé |
| Générer des tests | `/gen-tests` | Audit de couverture + génération ciblée |
| Statut du projet | `/project-status` | Rapport de santé et de progression |
| Mettre à jour | `/upgrade-framework` | Migrer depuis une ancienne version |

## Règles fondamentales

1. Lire memory/ entièrement avant toute action.
2. Ne jamais contredire un ADR sans en créer un nouveau.
3. Toujours TDD : tests avant implémentation.
4. Valider avec l'agent verifier avant de clore une tâche.
5. Mettre à jour memory/progress.md en fin de session.
6. Après chaque erreur : "Mets à jour CLAUDE.md pour ne pas refaire cette erreur."
