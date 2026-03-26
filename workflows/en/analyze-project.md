---
name: analyze-project
description: >
  Analyzes an existing project and automatically generates memory/ files.
  Handles migration of an existing CLAUDE.md. Non-destructive.
---

# Workflow: analyze existing project

This workflow is non-destructive. It never modifies source code,
never deletes existing files, and never forces overwrites.

## Precondition

Navigate to the root of the project to analyze before launching this workflow.

---

## Step 1 — Detect existing context (orchestrator)

Check for these indicators:

**Project with existing Claude configuration:**
- CLAUDE.md present → migration workflow (see step 2A)
- .claude/ present → integrate existing commands and settings
- memory/ present → read existing files, do not overwrite them

**Project without Claude configuration:**
- Go directly to step 2B

---

## Step 2A — Migrate an existing CLAUDE.md

If a CLAUDE.md exists and is not in the framework format:

1. Rename the old file: `mv CLAUDE.md CLAUDE.backup.md`
2. Add CLAUDE.backup.md to .gitignore
3. Extract content from the old CLAUDE.md:
   - Custom rules → will be integrated into memory/conventions/
   - Project context → will be integrated into memory/project-context.md
   - Agent instructions → will be integrated into the new CLAUDE.md
4. Inform the user: "CLAUDE.md migrated. The old file is preserved
   as CLAUDE.backup.md. Delete it once you've verified the migration."

If CLAUDE.md is already in the framework format, go directly to step 3.

---

## Step 2B — Initialize for a project without configuration

Create minimal structure:
```
mkdir -p memory/decisions memory/conventions memory/domain
mkdir -p .claude/commands
```

---

## Step 3 — Deep analysis (agent: project-analyzer)

Launch the project-analyzer agent on the entire project.

The agent produces missing memory/ files:
- memory/project-context.md
- memory/stack.md
- memory/architecture.md
- memory/progress.md
- memory/conventions/naming.md
- memory/conventions/error-handling.md
- memory/conventions/commit-format.md
- memory/domain/glossary.md (if applicable)

**Rule**: the agent only generates absent files.
If memory/stack.md already exists, it is read but not modified.

---

## Step 4 — Generate the new CLAUDE.md

Generate a CLAUDE.md adapted to the analyzed project.

This file must:
- Reference memory/ files to read before any action
- List available agents and skills
- Integrate rules extracted from the old CLAUDE.md (if migration)
- Specify the detected project type (saas, api-backend, fullstack-web, other)

---

## Step 5 — Install workflows

Copy framework workflows into .claude/commands/:
- /new-project, /add-feature, /debug-issue, /refactor, /gen-tests

**Rule**: do not overwrite existing custom workflows.
If .claude/commands/add-feature.md already exists with custom content,
keep it. Offer the framework version as add-feature.framework.md for comparison.

---

## Step 6 — Summary and validation (orchestrator)

Present to the user:

**Generated files:**
- List of all memory/ files created

**Preserved files (already existed):**
- List of unmodified files

**Migration performed:**
- CLAUDE.md → CLAUDE.backup.md + migration to memory/
- (or: no migration needed)

**Recommended next steps:**
1. Review memory/project-context.md and complete placeholders
2. Review memory/stack.md and correct if needed
3. Delete CLAUDE.backup.md once migration is verified
4. Use /add-feature to start working on the project
