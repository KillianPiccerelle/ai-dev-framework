---
name: debug-issue
description: >
  Analyzes and resolves a bug. Root cause mandatory before any fix.
  Ends with memory update if the bug revealed something important.
---

# Workflow: debug issue

Absolute rule: no fix without identifying root cause first.

## Step 1 — Precise description
Ask: observed behavior, expected behavior, reproduction conditions, since when.

## Step 2 — Reproduction (agent: debug)
Write minimal test that reliably reproduces the bug.
If not reproducible, ask for more information before continuing.

## Step 2.5 — Dependency analysis (optional: code-review-graph)
For complex bugs, ask: "Analyze dependencies of affected files with code-review-graph?"

If yes:
1. Run `/code-review-graph impact <suspected-files>` to identify all potentially affected modules
2. Use graph to trace transitive dependencies
3. Narrow investigation scope to impacted files only

If code-review-graph not available:
- Proceed with traditional dependency tracing

## Step 3 — Investigation (agent: debug)
Trace data flow. Formulate 3 hypotheses ranked by probability.
Test each hypothesis in order.

## Step 4 — Fix (agent: backend-dev or frontend-dev)
Implement fix only after cause is confirmed. Minimal change only.
Reproduction test becomes a permanent regression test.

## Step 5 — Verification (agent: verifier)
Verify fix resolves bug without regression.

## Step 6 — Memory update (mandatory)

Answer each question explicitly:

**Did the bug reveal a missing convention or architectural blind spot?**
→ If yes, update `memory/conventions/` or create an ADR in `memory/decisions/`.

**Was a module or behavior misunderstood in the memory files?**
→ If yes, correct the relevant section in `memory/architecture.md` or
  `memory/stack.md` to reflect the actual behavior.

**Update `memory/progress.md`:**
- Add a "Last session" entry: date, bug fixed, root cause identified,
  regression test added
- Add the regression test to "Delivered features" if it covers a critical path
- Update "Technical debt" if the bug revealed deeper issues to address later