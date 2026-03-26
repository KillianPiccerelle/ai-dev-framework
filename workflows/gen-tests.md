---
name: gen-tests
description: Coverage audit first, then targeted test generation for uncovered areas.
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
- Reveals a bug → report to user, do not modify source code

## Step 6 — Final report (agent: verifier)
Tests added, coverage before/after, still uncovered areas, potential bugs found.
Update memory/progress.md.
