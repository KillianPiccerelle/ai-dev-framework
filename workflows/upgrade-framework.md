---
name: upgrade-framework
description: Upgrades a project from an older framework version to v3. Non-destructive.
---

# Workflow: upgrade framework

Non-destructive migration from v1/v2 to v3.
Never overwrites custom content. Always backs up before migrating.

## Step 1 — Detect current state (orchestrator)
Check for:
- CLAUDE.md format (v1: basic rules, v2: has agents table, v3: has v3 marker)
- .claude/commands/ contents and count
- memory/ structure (v1: none, v2: has stack.md, v3: has architecture.md)
- agents/ in .claude/ if any custom agents

Report detected version and what needs upgrading.

## Step 2 — Backup current config
cp CLAUDE.md CLAUDE.v2.backup.md (or v1)
Add backup file to .gitignore.
Inform user: backup created, delete when upgrade verified.

## Step 3 — Migrate memory structure (agent: project-analyzer)
v1 → v3: generate all memory/ files from scratch via /analyze-project logic
v2 → v3: memory/ exists but may be missing architecture.md
Generate only missing files. Never overwrite existing ones.

## Step 4 — Update CLAUDE.md
Generate new CLAUDE.md in v3 format.
Preserve all custom project rules from the backup.
Add v3 agent list and workflow list.

## Step 5 — Install missing workflows
Compare .claude/commands/ against full v3 workflow list.
Install missing workflows only.
Never overwrite customized workflows (offer .framework.md version for comparison).

## Step 6 — Install missing agents
Compare ~/.claude/agents/ against v3 agent list.
Install any missing agents by comparing ~/.claude/agents/ against the full agent list.
Never overwrite existing agents.

## Memory update (mandatory)
Update memory/progress.md with: framework version migrated from/to, files upgraded, files preserved, items needing manual review.

## Step 7 — Summary
Report: what was upgraded, what was preserved, what needs manual review.
Recommended next step: /map-project to generate docs/project-map.md.
