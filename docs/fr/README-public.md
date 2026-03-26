# ai-dev-framework-fr

> Framework personnel de développement assisté par IA

**Auteur:** [KillianPiccerelle](https://github.com/KillianPiccerelle)  
**Version anglaise:** [ai-dev-framework-en](https://github.com/KillianPiccerelle/ai-dev-framework-en)

---

Un framework réutilisable pour développer des applications complètes avec
l'aide d'agents IA spécialisés. Il centralise les agents, les skills,
les workflows, la mémoire projet et des templates prêts à l'emploi.

## Ce que contient ce framework

**11 agents spécialisés** qui couvrent tout le cycle de développement :
orchestrator, architect, stack-advisor, project-analyzer, backend-dev, frontend-dev,
debug, test-engineer, code-reviewer, doc-writer, verifier.

**5 skills fondamentaux** invocables par slash command :
stack-advisor, jwt-auth, rest-crud, schema-design, tdd-workflow.

**6 workflows complets** qui orchestrent les agents dans le bon ordre :
new-project, analyze-project, add-feature, debug-issue, refactor, gen-tests.

**3 templates de projets** avec CLAUDE.md pré-configuré :
SaaS, API backend, Fullstack web.

**Mémoire projet persistante** structurée en 6 types :
contexte, stack, architecture, conventions, ADRs, domaine métier.

**Hooks d'automatisation** pour le formatage, la détection de secrets
et la sauvegarde de contexte.

## Installation

```bash
git clone https://github.com/KillianPiccerelle/ai-dev-framework-fr.git ~/ai-dev-framework
cd ~/ai-dev-framework
chmod +x install.sh

# Installer les agents et skills globalement
./install.sh
```

## Démarrer un nouveau projet

```bash
# Dans le dossier de ton projet
~/ai-dev-framework/install.sh fr saas   # ou api-backend, fullstack-web

# Ouvrir Claude Code
claude

# Lancer le workflow de démarrage
/new-project
```

## Utilisation quotidienne

```
/new-project        → Cadrer et architecturer un nouveau projet
/analyze-project    → Analyser un projet existant, générer memory/
/add-feature        → Ajouter une fonctionnalité (TDD complet)
/debug-issue        → Analyser et résoudre un bug
/refactor           → Refactoriser du code existant
/gen-tests          → Générer des tests pour du code existant
/stack-advisor      → Recommander une stack technique
/jwt-auth           → Implémenter l'authentification JWT
/rest-crud          → Créer un endpoint REST complet
/schema-design      → Concevoir un schéma de base de données
/tdd-workflow       → Appliquer la méthodologie TDD
```

## Structure

```
ai-dev-framework-fr/
├── agents/          → 11 agents IA spécialisés
├── skills/          → 5 skills invocables
├── workflows/       → 6 workflows orchestrés
├── memory/          → Templates de mémoire projet
├── templates/       → Squelettes de projets (SaaS, API, Fullstack)
├── hooks/           → Automations Claude Code
├── docs/            → Documentation du framework
└── install.sh       → Script d'installation
```

## Contribuer

Les contributions sont les bienvenues. Voir [docs/adding-agent.md](docs/adding-agent.md).

## Licence

MIT — [KillianPiccerelle](https://github.com/KillianPiccerelle)
