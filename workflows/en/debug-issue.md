---
name: debug-issue
description: Analyzes and resolves a bug. Root cause mandatory before any fix.
---

# Workflow: debug issue

## Absolute rule

No fix without identifying the root cause.
A fix without investigation is technical debt — the bug will return.

## Step 1 — Precise description

Ask the user:
- What is the observed behavior?
- What is the expected behavior?
- Under what conditions does the bug reproduce?
- How long has the bug existed? (which commit if possible)

## Step 2 — Reproduction (agent: debug)

Write a minimal test that reliably reproduces the bug.
If the bug cannot be reproduced, ask for more information.
A non-reproducible bug cannot be fixed properly.

## Step 3 — Investigation (agent: debug)

Trace the data flow from input to where behavior deviates.
Formulate 3 hypotheses ranked by probability.
Test each hypothesis in order.

## Step 4 — Fix (agent: backend-dev or frontend-dev)

Implement the fix only once the cause is confirmed.
The fix must be minimal — only fix what is broken.
The reproduction test becomes a permanent regression test.

## Step 5 — Verification (agent: verifier)

Verify the fix resolves the bug without introducing regression.

## Step 6 — Documentation

If the bug reveals a blind spot in conventions or architecture:
update memory/conventions/ or create an ADR.
Update memory/progress.md.
