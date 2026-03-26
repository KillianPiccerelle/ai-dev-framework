---
name: add-feature
description: Adds a feature to the project following TDD. Architecture → Tests → Implementation → Review → Doc.
---

# Workflow: add feature

## Mandatory precondition

Read memory/ entirely before starting:
memory/project-context.md, memory/stack.md, memory/conventions/, memory/decisions/

Do not start if these files don't exist. Suggest /new-project instead.

## Step 1 — Impact analysis (agent: architect)

Before writing anything, the architect agent:
- Verifies the feature's consistency with existing ADRs
- Identifies existing components impacted by this feature
- Identifies dependencies between the new feature and existing code
- If a new architectural decision is needed, creates an ADR before continuing

Produce: implementation plan in a few clear points

Validate with the user before moving to step 2.

## Step 2 — Tests first (agent: test-engineer)

The test-engineer agent writes all tests describing the expected behavior.
Tests MUST fail at this stage (RED).

Cover: nominal case, edge cases, error cases, permissions.

## Step 3 — Implementation (agent: backend-dev or frontend-dev)

The appropriate agent implements the minimum code to make tests pass (GREEN).
It respects memory/conventions/ and contradicts no ADR.

## Step 4 — Refactoring (agent: backend-dev or frontend-dev)

Improve code without modifying behavior (REFACTOR).
All tests must stay green.
Remove duplicated code, improve names, simplify logic.

## Step 5 — Review (agent: code-reviewer)

Read-only audit. The agent identifies issues without fixing them.
If verdict REJECTED: fix BLOCKING points then restart the review.

## Step 6 — Security (agent: security-reviewer, if applicable)

Invoke if the feature: exposes user data, accepts external inputs,
touches authentication or permissions, handles payments.

## Step 7 — Documentation (agent: doc-writer)

Update documentation affected by the feature.

## Step 8 — Final validation (agent: verifier)

The verifier agent validates everything is in order.
If the checklist is incomplete, fix before considering the feature done.

## Step 9 — Memory update

Update memory/progress.md with the delivered feature.
