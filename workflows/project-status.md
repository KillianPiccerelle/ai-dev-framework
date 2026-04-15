---
name: project-status
description: Generates a timestamped project health and progress report with history.
---

# Workflow: project status

Produces a timestamped status report and maintains history of the last 10 reports.

## Memory update (mandatory)
- [x] Link to latest status report in `memory/progress.md`

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

## Step 5 — Save timestamped report (orchestrator)
1. Run script: `python3 scripts/generate-status-report.py`
   - Creates `docs/status-YYYY-MM-DD.md` with timestamp
   - Includes all metrics: TODO count, large files, ADRs, git status
   - Automatically keeps only the 10 most recent reports
2. Run script: `python3 scripts/status-history.py`
   - Generates ASCII progress charts from historical data
   - Updates `memory/progress.md` with link to latest report

## Step 6 — Update memory link (orchestrator)
1. Read `memory/progress.md`
2. Add or update link to latest status report at the top
3. Format: `Latest status report: [status-YYYY-MM-DD.md](../../docs/status-YYYY-MM-DD.md)`
