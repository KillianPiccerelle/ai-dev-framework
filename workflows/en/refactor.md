---
name: refactor
description: >
  Refactors existing code without modifying its behavior.
  Analyzes first, proposes a plan, waits for validation, executes.
---

# Workflow: refactor code

## Fundamental rule

Refactoring does not change the observable behavior of code.
If a test breaks during refactoring, that's a regression — not
refactoring. Stop and fix before continuing.

---

## Step 1 — Define scope

Ask the user:
- Which file, folder, or component to refactor?
- What is the objective? (readability, performance, structure, technical debt)
- Are there constraints? (API compatibility, no interface changes)

---

## Step 2 — Verify test state (agent: test-engineer)

Before touching anything, verify that existing tests pass.
If tests are already failing, stop and report to the user.
Refactoring code with failing tests cannot be validated.

Expected result: "X tests pass, 0 failing — refactoring possible."

---

## Step 3 — Target code analysis (agent: code-reviewer)

Analyze the defined scope and identify concrete issues:
- Duplicated code (DRY)
- Functions that are too long (> 30 lines is a signal)
- Unclear or misleading naming
- Strong coupling between modules
- Mixed responsibilities in a single component
- High cyclomatic complexity

Produce a prioritized list of issues with an effort estimate
for each (small / medium / large).

---

## Step 4 — Plan proposal (orchestrator)

Present the user with the list of issues and the refactoring plan.
Ask explicitly: "Which points do you want to address in this session?"

Never refactor everything at once. Work in small validated increments.
A 500-line refactoring without intermediate tests is risky.

Wait for validation before continuing.

---

## Step 5 — Incremental execution (agent: backend-dev or frontend-dev)

For each validated point, in order:
1. Make the minimal change
2. Re-run tests immediately
3. If tests pass → continue to next point
4. If a test breaks → revert this change, analyze why, report

Atomic commits: one commit per resolved issue, with a clear message.
Format: `refactor(scope): description of change`

---

## Step 6 — Final verification (agent: verifier)

Verify that:
- All tests that passed before still pass
- Test coverage has not decreased
- No TODO or FIXME was introduced

---

## Step 7 — Memory update

If the refactoring changes conventions or patterns:
update memory/conventions/ and memory/architecture.md.
Update memory/progress.md.
