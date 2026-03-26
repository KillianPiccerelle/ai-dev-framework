---
name: refactor
description: Refactors existing code without modifying behavior. Analyze → Plan → Validate → Execute.
---

# Workflow: refactor

Fundamental rule: refactoring does not change observable behavior.
If a test breaks, that is a regression, not refactoring. Stop and fix.

## Step 1 — Define scope
Ask: which file/folder/component, what objective, what constraints.

## Step 2 — Verify test state (agent: test-engineer)
All tests must pass before starting. If any fail, stop and report.

## Step 3 — Analysis (agent: code-reviewer)
Identify: duplicated code, overly long functions, unclear naming,
strong coupling, mixed responsibilities, high cyclomatic complexity.
Produce prioritized list with effort estimates.

## Step 4 — Plan (orchestrator)
Present issues and plan. Ask which points to address this session.
Never refactor everything at once. Wait for validation.

## Step 5 — Incremental execution (agent: backend-dev or frontend-dev)
For each validated point: change → run tests → continue or revert.
Atomic commits: refactor(scope): description

## Step 6 — Final verification (agent: verifier)
All previously passing tests still pass. Coverage not decreased.

## Step 7 — Memory update
Update memory/conventions/ and memory/architecture.md if patterns changed.
Update memory/progress.md.
