---
name: tdd-workflow
description: >
  Applies TDD methodology: RED → GREEN → REFACTOR.
  Invoke before any implementation to frame the work.
tags: [testing, tdd, quality]
---

TDD follows three strictly ordered phases.

RED: Write all tests describing expected behavior before any implementation.
Verify they all fail (a passing test before implementation tests nothing).
Good tests: readable as docs, independent, fast, deterministic.

GREEN: Write minimum code to make tests pass.
No optimization, no refactoring, no "future" code. Just green.

REFACTOR: Improve code while keeping all tests green.
Readability, performance, structure — no behavior changes.

Coverage targets: 80% lines minimum, 100% critical paths (auth, payments, security).

End of each cycle: all tests pass, no regression, coverage not decreased.
