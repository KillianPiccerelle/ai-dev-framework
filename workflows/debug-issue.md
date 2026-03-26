---
name: debug-issue
description: Analyzes and resolves a bug. Root cause mandatory before any fix.
---

# Workflow: debug issue

Absolute rule: no fix without identifying root cause first.

## Step 1 — Precise description
Ask: observed behavior, expected behavior, reproduction conditions, since when.

## Step 2 — Reproduction (agent: debug)
Write minimal test that reliably reproduces the bug.
If not reproducible, ask for more info before continuing.

## Step 3 — Investigation (agent: debug)
Trace data flow. Formulate 3 hypotheses. Test each in order.

## Step 4 — Fix (agent: backend-dev or frontend-dev)
Implement fix only after cause is confirmed. Minimal change only.
Reproduction test becomes permanent regression test.

## Step 5 — Verification (agent: verifier)
Verify fix resolves bug without regression.

## Step 6 — Documentation
Update memory/conventions/ or create ADR if bug reveals architectural blind spot.
Update memory/progress.md.
