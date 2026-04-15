# Contributing to ai-dev-framework

Thank you for your interest in contributing. This document covers how to add agents, workflows, skills, and templates.

---

## Repository structure

```
ai-dev-framework/
├── agents/        — AI personas (one file per agent)
├── workflows/     — Slash command sequences
├── skills/        — Reusable technical procedures
├── templates/     — Project bootstrap templates
├── memory/        — Memory system templates
├── hooks/scripts/ — Security hooks (JS)
└── scripts/       — CLI utilities (bash/python)
```

---

## Language rules

- All agents, workflows, and skills: **English only**
- French documentation: `docs/fr/` only
- Commit messages: English

---

## Adding an agent

1. Create `agents/<name>.md`
2. Follow the structure:

```markdown
# Agent: <name>

## Role
One sentence describing what this agent does.

## Tools
List of tools this agent uses (principle of least privilege).

## What this agent does NOT do
Explicit constraints — what to delegate to other agents.

## Instructions
Detailed instructions for the agent.
```

3. Update `CLAUDE.md` and `README.md` agent count
4. Update `README.md` and `docs/fr/README.md`

---

## Adding a workflow

1. Create `workflows/<name>.md`
2. Required sections:
   - **Trigger** — slash command name
   - **Steps** — numbered, with agent assignments
   - **Memory update (mandatory)** — explicit checklist at the end

3. Register the slash command in `.claude/settings.json` if needed
4. Update `CLAUDE.md`, `README.md`, `docs/fr/README.md`

---

## Adding a skill

1. Create `skills/<name>/SKILL.md`
2. Keep the skill interface **lightweight** — business logic stays in the agent
3. Structure:

```markdown
---
name: <skill-name>
description: One-line description
tags: [tag1, tag2]
---

# Skill: <name>

## Prerequisites
## Quick start
## Usage
## Integration with agents
```

4. Add to `scripts/list.sh` in the `common_skills` array
5. Update `CLAUDE.md` skills count, `README.md`, `docs/fr/README.md`

---

## Adding a template

1. Create `templates/<name>/` with:
   - `CLAUDE.md` — project-specific instructions
   - `memory/` — pre-filled memory files
2. Add detection logic in `scripts/init-project.sh`
3. Add to autocompletion in `scripts/completion.bash` and `scripts/completion.zsh`
4. Document in `README.md`

---

## Commit format

```
feat: description       # new feature
fix: description        # bug fix
refactor: description   # code change without behavior change
docs: description       # documentation only
chore: description      # maintenance
security: description   # security fix
```

---

## Pull request checklist

- [ ] English core (agents/workflows/skills)
- [ ] Memory update checklist in any new workflow
- [ ] Agent updated in `CLAUDE.md` and `README.md`
- [ ] `scripts/list.sh` updated if new skill added
- [ ] README.md counts accurate
- [ ] No secrets or credentials committed

---

## Testing locally

```bash
# Install the framework
bash scripts/install.sh

# Run diagnostics
ai-framework doctor

# List all components
ai-framework list
```
