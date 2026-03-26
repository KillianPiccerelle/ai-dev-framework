# Migration guide: v2 → v3

## What changed in v3

### Structure simplification
- **Before (v2)**: agents/fr/, agents/en/, workflows/fr/, workflows/en/
- **After (v3)**: agents/, workflows/ (English only, single source of truth)
- **Docs**: still bilingual in docs/fr/ and docs/en/

### New agents
- `codebase-analyst` — deep repository analysis, supports other agents
- `qa-engineer` — advanced testing, edge cases, security detection

### New workflows
- `/map-project` — generates docs/project-map.md
- `/project-status` — health and progress report
- `/upgrade-framework` — non-destructive upgrade from v1/v2

### New template
- `ai-app` — AI-driven applications with LLM-specific rules

## Automatic upgrade

The easiest way to upgrade any project:

```bash
cd my-project
~/ai-dev-framework/scripts/init-project.sh
claude
/upgrade-framework
```

The /upgrade-framework workflow handles everything non-destructively.

## Manual upgrade steps

### 1. Update framework installation
```bash
cd ~/ai-dev-framework
git pull origin main
```

### 2. Reinstall agents globally
```bash
cp ~/ai-dev-framework/agents/*.md ~/.claude/agents/
```

### 3. Add new workflows to your project
```bash
cp ~/ai-dev-framework/workflows/map-project.md .claude/commands/
cp ~/ai-dev-framework/workflows/project-status.md .claude/commands/
cp ~/ai-dev-framework/workflows/upgrade-framework.md .claude/commands/
```

### 4. Add architecture.md to memory if missing
```bash
cp ~/ai-dev-framework/memory/architecture.md memory/
```

### 5. Update CLAUDE.md
Add the new agents and workflows to your project's CLAUDE.md.
Add memory/architecture.md to the reading list.

## What is preserved
- All custom project rules in CLAUDE.md
- All memory/ files (project-context, stack, decisions, conventions)
- All custom workflows
- All custom agents
- All source code (untouched)
