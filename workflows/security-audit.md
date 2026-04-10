---
name: security-audit
description: >
  Full security audit. Codebase analysis → security review → QA cross-check.
  Produces docs/security-report.md with findings classified by severity.
---

# Workflow: security audit

Precondition: read memory/ entirely before starting.
Do not start if memory files don't exist. Suggest /analyze-project first.

## Step 1 — Codebase mapping (agent: codebase-analyst)
Map all attack surfaces: entry points (HTTP routes, CLI args, env vars),
authentication and authorization boundaries, external integrations,
data persistence layer, user-controlled inputs.
Produce a surface map to guide the security review.

## Step 2 — Security audit (agent: security-reviewer)
Audit all surfaces identified in step 1.
Scope: injections, auth bypass, IDOR, exposed secrets, attack surfaces.
Do not audit code quality or test coverage — security only.
Produce docs/security-report.md with findings ordered by severity.

## Step 3 — QA cross-check (agent: qa-engineer)
Review security findings from step 2.
Identify edge cases or exploit scenarios the security-reviewer may have missed.
Do not duplicate findings — add only what is new.
Append a "QA supplement" section to docs/security-report.md.

## Step 4 — Summary and verdict
Present the final report to the user:
- Finding counts by severity (critical / high / medium / low)
- Overall verdict: BLOCKED / NEEDS WORK / ACCEPTABLE
- Prioritized action list: what to fix before shipping vs. what goes to backlog

## Step 5 — Memory update (mandatory)

Answer each question explicitly:

**Were critical or high findings identified?**
→ Add an ADR in `memory/decisions/` documenting the security constraint
  and the required remediation approach.

**Did the audit reveal missing security conventions?**
→ Update `memory/conventions/` with the rule (e.g., "all user inputs
  must be validated at the controller boundary before reaching services").

**Update `memory/progress.md`:**
- Add a "Last session" entry: date, audit performed, finding counts,
  verdict, critical items to fix
- Add critical findings to "Blockers" if they prevent shipping
