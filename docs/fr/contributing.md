# Contribuer à ai-dev-framework

Merci de ton intérêt. Ce guide explique comment ajouter des agents, workflows, skills et templates.

---

## Structure du repo

```
ai-dev-framework/
├── agents/        — Personas IA (un fichier par agent)
├── workflows/     — Séquences invocables par slash command
├── skills/        — Procédures techniques réutilisables
├── templates/     — Templates de bootstrap projet
├── memory/        — Templates du système mémoire
├── hooks/scripts/ — Hooks sécurité (JS)
└── scripts/       — Utilitaires CLI (bash/python)
```

---

## Règles de langue

- Agents, workflows, skills : **anglais uniquement**
- Documentation française : `docs/fr/` seulement
- Messages de commit : anglais

---

## Ajouter un agent

1. Créer `agents/<nom>.md`
2. Suivre la structure :

```markdown
# Agent: <nom>

## Role
Une phrase décrivant ce que fait cet agent.

## Tools
Liste des outils (principe du moindre privilège).

## What this agent does NOT do
Contraintes explicites — ce qu'il délègue aux autres agents.

## Instructions
Instructions détaillées pour l'agent.
```

3. Mettre à jour `CLAUDE.md` et `FRAMEWORK_CONTEXT.md` (compteur agents)
4. Mettre à jour `README.md` et `docs/fr/README.md`

---

## Ajouter un workflow

1. Créer `workflows/<nom>.md`
2. Sections obligatoires :
   - **Trigger** — nom de la slash command
   - **Steps** — numérotées, avec assignment d'agent
   - **Memory update (mandatory)** — checklist explicite en fin de workflow

3. Mettre à jour `CLAUDE.md`, `README.md`, `FRAMEWORK_CONTEXT.md`

---

## Ajouter un skill

1. Créer `skills/<nom>/SKILL.md`
2. Interface **légère** — la logique métier reste dans l'agent
3. Structure :

```markdown
---
name: <skill-name>
description: Description en une ligne
tags: [tag1, tag2]
---

# Skill: <nom>

## Prerequisites
## Quick start
## Usage
## Integration with agents
```

4. Ajouter dans `scripts/list.sh` (tableau `common_skills`)
5. Mettre à jour `CLAUDE.md`, `README.md`, `FRAMEWORK_CONTEXT.md`

---

## Ajouter un template

1. Créer `templates/<nom>/` avec :
   - `CLAUDE.md` — instructions spécifiques au projet
   - `memory/` — fichiers mémoire pré-remplis
2. Ajouter la logique de détection dans `scripts/init-project.sh`
3. Ajouter à l'autocomplétion dans `scripts/completion.bash` et `scripts/completion.zsh`
4. Documenter dans `README.md`

---

## Format des commits

```
feat: description       # nouvelle fonctionnalité
fix: description        # correction de bug
refactor: description   # refactoring sans changement de comportement
docs: description       # documentation uniquement
chore: description      # maintenance
security: description   # correction sécurité
```

---

## Checklist pull request

- [ ] Core en anglais (agents/workflows/skills)
- [ ] Checklist "Memory update" présente dans tout nouveau workflow
- [ ] Compteurs mis à jour dans `CLAUDE.md` et `FRAMEWORK_CONTEXT.md`
- [ ] `scripts/list.sh` mis à jour si nouveau skill
- [ ] Compteurs README.md corrects
- [ ] Pas de secrets ou credentials commitées

---

## Tester en local

```bash
# Installer le framework
bash scripts/install.sh

# Diagnostics
ai-framework doctor

# Lister tous les composants
ai-framework list
```
