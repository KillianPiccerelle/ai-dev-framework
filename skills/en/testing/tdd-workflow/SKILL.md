---
name: tdd-workflow
description: >
  Applies TDD methodology: RED → GREEN → REFACTOR.
  Invoke before any implementation to frame the work.
tags: [testing, tdd, quality]
---

TDD follows three strictly ordered phases.

RED PHASE — Write failing tests
Before writing a single line of implementation, write all tests
describing the expected behavior. Verify they all fail (if a test passes
without implementation, it tests nothing useful).

A good test is: readable as documentation, independent of other tests,
fast to execute, and deterministic (same result every time).

GREEN PHASE — Implement the minimum
Write the minimum code to make tests pass. No optimization, no refactoring,
no code "for later". Just what's necessary to go from red to green.

REFACTOR PHASE — Improve without breaking
Improve the code (readability, performance, structure) while keeping all
tests green. This is the only phase where code can be reorganized
without adding behavior.

Coverage target: 80% minimum on lines, 100% on critical paths
(auth, payment, security).

At the end of each RED-GREEN-REFACTOR cycle, verify:
- All tests pass
- No regression on existing tests
- Coverage has not decreased
