---
name: gen-tests
description: >
  Coverage audit first, then targeted test generation for uncovered areas.
  Ends with memory update reflecting new coverage state.
---

# Workflow: generate tests

## Step 1 — Define scope
Ask: which file/module, existing tests, which level (unit/integration/e2e).

## Step 2 — Coverage audit (agent: test-engineer)
Run coverage tool if configured (jest --coverage, pytest-cov, go test -cover).
If not configured: manually map tested vs untested code.
Produce audit report: functions without tests, uncovered error paths, edge cases.

## Step 3 — Prioritization (orchestrator)
High priority: auth, payments, permissions, side effects, complex business logic.
Normal: standard CRUD, input validation, data transforms.
Low: simple utilities, generated code.
Wait for user validation.

## Step 4 — Test generation (agent: test-engineer)
Generate tests respecting CURRENT behavior (not ideal behavior).
One behavior per test. Descriptive names. Use existing test framework only.

## Step 5 — Verify generated tests pass
All generated tests must pass. If a test fails:
- Badly written → fix the test
- Reveals a bug → report to user, do not modify source code, create issue instead

## Step 6 — Memory update (mandatory)

**Update `memory/progress.md`:**
- Add a "Last session" entry: date, tests added, coverage before → after
- Update "Technical debt" — mark test coverage items as resolved if coverage
  target was reached, or update the remaining gap
- Add any bugs discovered during test generation to "Known issues"

**Update `memory/stack.md` if needed:**
- If a test framework was added (Jest, pytest, etc.) that wasn't in the stack,
  add it to the Tests row in the summary table with its version