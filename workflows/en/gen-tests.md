---
name: gen-tests
description: >
  Generates tests for existing code. Coverage audit first,
  then targeted generation on uncovered areas.
---

# Workflow: generate tests

This workflow covers two cases: code with no tests at all, and code with
partial tests. In both cases, auditing the existing state always
precedes generation.

---

## Step 1 — Define scope

Ask the user:
- Which file, folder, or module to test?
- Are there already tests for some parts?
- Which test level to target? (unit, integration, e2e, or all three)

---

## Step 2 — Coverage audit (agent: test-engineer)

Analyze the existing state:

If a coverage tool is configured (jest --coverage, pytest-cov,
go test -cover): run the command and read the report.

If no tool is configured: manually analyze existing test files
and source files to identify untested areas.

Produce an audit report:
- Functions/methods without tests
- Uncovered error paths
- Untested edge cases
- Approximate coverage if measurable

---

## Step 3 — Prioritization (orchestrator)

Present the report to the user and prioritize together:

High priority — cover first:
- Critical paths (auth, payment, permissions)
- Functions with significant side effects
- Complex business logic

Normal priority:
- Standard CRUD
- Input validation
- Data transformations

Low priority:
- Simple utility functions
- Auto-generated code

Wait for prioritization validation before continuing.

---

## Step 4 — Test generation (agent: test-engineer)

For each identified high-priority area, generate tests
respecting the current behavior of the code (not what it should
do, but what it actually does).

Generation rules:
- Read source code and understand behavior before writing
- Each test covers ONE behavior
- Name the test descriptively:
  `should return 404 when user does not exist`
- Cover: nominal case, edge cases, error cases

Use the test framework already present in the project.
Do not introduce a new test framework.

---

## Step 5 — Verify generated tests pass

Run the generated tests. They must all pass.
If a test fails, two possible cases:
1. The test is badly written (fix the test)
2. The test reveals an existing bug (report to user — do not
   modify code to make the test pass, create an issue instead)

---

## Step 6 — Final report (agent: verifier)

Produce a summary report:
- Number of tests added
- Coverage before / after (if measurable)
- Still uncovered areas with justification
- Potential bugs discovered during generation

Update memory/progress.md.
