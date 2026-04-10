---
name: add-feature
description: >
  Adds a feature following full TDD cycle. Architecture → Tests → Implementation → Review → Doc.
  Ends with mandatory memory update checklist.
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

## Step 9 — Memory update (mandatory)

Update memory files to reflect what was added. Do not skip this step.

Answer each question explicitly:

**New module, file, or dependency added?**
→ Update `memory/stack.md` — add the new element to the summary table
  and add a decision detail section if a new technology was introduced.

**Architecture changed?**
→ Update `memory/architecture.md` — add the new component to the component
  list, update data flows if a new flow was introduced, update the folder
  structure if new directories were created.

**Feature delivered?**
→ Update `memory/progress.md`:
  - Add the feature to "Delivered features" with [x]
  - Add a "Last session" entry with: date, what was built, decisions made
  - Update "Next steps" to remove this feature and add what comes next
  - Update "In progress" and "Blockers" sections

**New convention established?**
→ If the feature introduced a new pattern (new API response format, new
  component structure, new error handling approach), update the relevant
  file in `memory/conventions/`.

**New architectural decision made?**
→ The ADR created in Step 1 should already be in `memory/decisions/`.
  Verify it is there and its status is "Accepted".

**Business domain knowledge added?**
→ If the feature introduced new domain concepts, entities, or rules,
  update `memory/domain/glossary.md`.

After updating, present a summary:
- Memory files updated: [list]
- Memory files unchanged (with reason): [list]