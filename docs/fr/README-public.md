# ai-dev-framework-fr

> Framework personnel de développement assisté par IA

**Auteur:** [KillianPiccerelle](https://github.com/KillianPiccerelle)  
**Version anglaise:** [ai-dev-framework-en](https://github.com/KillianPiccerelle/ai-dev-framework-en)

---

Un framework réutilisable pour développer des applications complètes avec
l'aide d'agents IA spécialisés. Il centralise les agents, les skills,
les workflows, la mémoire projet et des templates prêts à l'emploi.

## Ce que contient ce framework

**10 agents spécialisés** qui couvrent tout le cycle de développement :
orchestrator, architect, stack-advisor, backend-dev, frontend-dev,
debug, test-engineer, code-reviewer, doc-writer, verifier.

**5 skills fondamentaux** invocables par slash command :
stack-advisor, jwt-auth, rest-crud, schema-design, tdd-workflow.

**3 workflows complets** qui orchestrent les agents dans le bon ordre :
new-project, add-feature, debug-issue.

**3 templates de projets** avec CLAUDE.md pré-configuré :
SaaS, API backend, Fullstack web.

**Mémoire projet persistante** structurée en 5 types :
contexte, stack, conventions, ADRs, domaine métier.

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
/new-project      → Cadrer et architecurer un nouveau projet
/add-feature      → Ajouter une fonctionnalité (TDD complet)
/debug-issue      → Analyser et résoudre un bug
/stack-advisor    → Recommander une stack technique
/jwt-auth         → Implémenter l'authentification JWT
/rest-crud        → Créer un endpoint REST complet
/schema-design    → Concevoir un schéma de base de données
/tdd-workflow     → Appliquer la méthodologie TDD
```

## Structure

```
ai-dev-framework-fr/
├── agents/          → 10 agents IA spécialisés
├── skills/          → 5 skills invocables
├── workflows/       → 3 workflows orchestrés
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
