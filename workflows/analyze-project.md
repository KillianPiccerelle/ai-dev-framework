---
name: analyze-project
description: Analyzes an existing project. Generates memory/. Migrates old CLAUDE.md. Non-destructive.
---

# Workflow: analyze existing project

Non-destructive. Never modifies source code, never deletes files, never forces overwrites.

## Step 1 — Detect existing context (orchestrator)
Check for: CLAUDE.md, .claude/, memory/
- CLAUDE.md present and not in framework format → Step 2A (migration)
- Already in framework format → Step 3 directly
- No config at all → Step 2B

## Step 2A — Migrate existing CLAUDE.md
1. Rename: mv CLAUDE.md CLAUDE.backup.md
2. Add CLAUDE.backup.md to .gitignore
3. Extract: custom rules → memory/conventions/, context → memory/project-context.md
4. Inform user: backup preserved, delete when migration verified

## Step 2B — Initialize minimal structure
mkdir -p memory/decisions memory/conventions memory/domain .claude/commands

## Step 3 — Deep analysis (agent: project-analyzer)
Generate missing memory/ files only. Never overwrite existing ones.
Files: project-context.md, stack.md, architecture.md, progress.md,
conventions/naming.md, conventions/error-handling.md, conventions/commit-format.md,
domain/glossary.md (if applicable)

## Step 4 — Generate new CLAUDE.md
Adapted to the analyzed project. References memory/ files. Includes migrated rules.

The generated CLAUDE.md MUST always include this end-of-session section:

---
## End of session — mandatory

Before closing Claude Code, always update memory/progress.md with:
- What was done during this session
- Decisions made and why
- Current blockers if any
- Recommended next steps

The session-save hook writes an automatic snapshot regardless,
but Claude's summary is what makes memory useful across sessions.
Ask Claude: "Summarize this session and update memory/progress.md."
---

## Step 5 — Install workflows
Copy workflows to .claude/commands/. Do not overwrite custom workflows.
Offer framework version as workflow-name.framework.md for comparison.

## Step 6 — Summary (orchestrator)
Generated files / Preserved files / Migration performed / Next steps