---
name: refactor
description: >
  Refactors existing code without modifying behavior. Analyze → Plan → Validate → Execute.
  Ends with mandatory memory update checklist.
---

# Workflow: refactor

Fundamental rule: refactoring does not change observable behavior.
If a test breaks, that is a regression, not refactoring. Stop and fix.

## Step 1 — Define scope
Ask: which file/folder/component, what objective, what constraints.

## Step 2 — Verify test state (agent: test-engineer)
All tests must pass before starting. If any fail, stop and report.
Expected result: "X tests pass, 0 failing — refactoring possible."

## Step 3 — Analysis (agent: code-reviewer)
Identify: duplicated code, overly long functions, unclear naming,
strong coupling, mixed responsibilities, high cyclomatic complexity.
Produce prioritized list with effort estimates (small / medium / large).

## Step 4 — Plan (orchestrator)
Present issues and plan. Ask which points to address this session.
Never refactor everything at once. Wait for validation before continuing.

> Context reset point: if the refactor spans >3 files or the analysis session
> was long, start a fresh Claude Code session here. Summarize the plan in
> a file `docs/refactor-plan.md` before closing, then load it at the start
> of the new session alongside memory/ files.

## Step 5 — Incremental execution (agent: backend-dev or frontend-dev)
For each validated point: change → run tests → continue or revert.
Atomic commits: refactor(scope): description

## Step 6 — Final verification (agent: verifier)
All previously passing tests still pass. Coverage not decreased.
No TODO or FIXME introduced.

## Step 7 — Memory update (mandatory)

Update memory files to reflect what changed. Do not skip this step.

Answer each question explicitly:

**Files added or removed?**
→ If yes, update `memory/stack.md` — remove references to deleted modules,
  add references to new ones. Update the stack summary table if relevant.

**Architecture changed?**
→ If yes, update `memory/architecture.md` — adjust the component list,
  data flows, or folder structure section to match the current state.

**Features deleted or significantly changed?**
→ Update `memory/progress.md`:
  - Move deleted features out of "Delivered features"
  - Add a "Last session" entry with: date, what was refactored, what was removed
  - Update "Technical debt" if items were resolved or new ones identified

**Conventions changed?**
→ If the refactoring established a new pattern (new error format, new naming rule,
  new module structure), update the relevant file in `memory/conventions/`.

**New architectural decision made?**
→ Create an ADR in `memory/decisions/ADR-XXX-title.md`.

After updating, present a summary:
- Memory files updated: [list]
- Memory files unchanged (with reason): [list]