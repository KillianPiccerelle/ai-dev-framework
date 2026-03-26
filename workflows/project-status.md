---
name: project-status
description: Generates a current project health and progress report. Read-only.
---

# Workflow: project status

Read-only. Produces a status report without modifying any files.

## Step 1 — Read memory (orchestrator)
Read all memory/ files: project-context.md, stack.md, progress.md,
decisions/ (count ADRs), conventions/ (count rules).

## Step 2 — Codebase health (agent: codebase-analyst)
Quick scan for:
- TODO/FIXME count
- Large files (>300 lines)
- Test files presence
- Recent changes (git log --oneline -10 if git is available)

## Step 3 — Test coverage (agent: verifier)
Run coverage tool if configured. Report current coverage percentage.

## Step 4 — Generate status report
Present to user:

**Project**: [name from project-context.md]
**Stack**: [summary from stack.md]
**Architecture ADRs**: [count and list titles]
**Progress**: [summary from progress.md]
**Health signals**:
  - Test coverage: X%
  - TODO/FIXME count: N
  - Large files: list if any
**Recommended next action**: [based on progress.md and health signals]
