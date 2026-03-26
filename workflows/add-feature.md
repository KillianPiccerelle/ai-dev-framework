---
name: add-feature
description: Adds a feature following full TDD cycle. Architecture → Tests → Implementation → Review → Doc.
---

# Workflow: add feature

Precondition: read memory/ entirely before starting.
Do not start if memory files don't exist. Suggest /new-project or /analyze-project.

## Step 1 — Impact analysis (agent: architect)
Verify consistency with existing ADRs. Identify impacted components.
Create new ADR if needed. Produce: implementation plan.
Validate with user before step 2.

## Step 2 — Tests first (agent: test-engineer)
Write all tests describing expected behavior. Tests MUST fail (RED).
Cover: nominal case, edge cases, error cases, permissions.

## Step 3 — Implementation (agent: backend-dev or frontend-dev)
Implement minimum code to make tests pass (GREEN).
Respect memory/conventions/ and all ADRs.

## Step 4 — Refactoring (agent: backend-dev or frontend-dev)
Improve code without changing behavior (REFACTOR).
All tests must stay green.

## Step 5 — Review (agent: code-reviewer)
Read-only audit. If REJECTED: fix BLOCKING items, then re-review.

## Step 6 — QA (agent: qa-engineer)
Invoke if feature: exposes user data, accepts external inputs,
touches auth/permissions, handles payments.

## Step 7 — Documentation (agent: doc-writer)
Update docs affected by the feature.

## Step 8 — Final validation (agent: verifier)
Checklist must be fully green before closing.

## Step 9 — Memory update
Update memory/progress.md.
