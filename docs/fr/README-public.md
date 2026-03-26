# ai-dev-framework

> Framework personnel de développement assisté par IA — v3

**Auteur :** [KillianPiccerelle](https://github.com/KillianPiccerelle)
**Docs :** [English](docs/en/) · [Français](docs/fr/)

---

## Contenu

**13 agents spécialisés** couvrant tout le cycle de développement :
orchestrator, architect, stack-advisor, project-analyzer, codebase-analyst,
backend-dev, frontend-dev, debug, test-engineer, qa-engineer,
code-reviewer, doc-writer, verifier.

**9 workflows** pour toutes les situations :
new-project, analyze-project, map-project, add-feature,
debug-issue, refactor, gen-tests, project-status, upgrade-framework.

**5 skills**, **4 templates** (SaaS, API, Fullstack, AI-app),
**système de mémoire persistant**, **hooks d'automatisation**.

## Installation

```bash
git clone https://github.com/KillianPiccerelle/ai-dev-framework.git ~/ai-dev-framework
cd ~/ai-dev-framework && chmod +x scripts/install.sh && ./scripts/install.sh
```

## Nouveau projet

```bash
cd mon-projet
~/ai-dev-framework/scripts/init-project.sh saas
claude && /new-project
```

## Projet existant

```bash
cd mon-projet-existant
~/ai-dev-framework/scripts/init-project.sh
claude && /analyze-project
```

## Migrer depuis v2

```bash
cd mon-projet && claude && /upgrade-framework
```

## Commandes

```
/new-project        → Cadrer et architecturer depuis zéro
/analyze-project    → Analyser un projet existant, générer memory/
/map-project        → Générer la carte complète du projet
/add-feature        → Ajouter une feature avec TDD complet
/debug-issue        → Analyse de cause racine et correction
/refactor           → Refactoring incrémental sécurisé
/gen-tests          → Audit de couverture + génération de tests
/project-status     → Rapport de santé et de progression
/upgrade-framework  → Migrer depuis une ancienne version du framework
```

## Licence
MIT — [KillianPiccerelle](https://github.com/KillianPiccerelle)
