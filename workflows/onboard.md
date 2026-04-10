---
name: onboard
description: >
  Generates docs/onboarding.md for a new developer joining the project.
  Reads all memory/ files and produces a complete getting-started guide.
---

# Workflow: onboard

Precondition: read all memory/ files before starting.
If memory/ is empty or missing, run /analyze-project first — onboarding
without memory produces an empty guide.

## Step 1 — Memory scan (agent: codebase-analyst)
Read all memory/ files and the project's README if present.
Identify what is documented vs. what must be inferred from the codebase.
Flag gaps that would block a new developer (missing setup steps, undocumented
env vars, unclear conventions).

## Step 2 — Onboarding document generation (agent: doc-writer)
Produce docs/onboarding.md with this structure:

```
# Onboarding — [Project Name]

## What this project does
[1-3 sentences from memory/project-context.md]

## Tech stack
[Table from memory/stack.md — runtime, framework, database, auth, deploy]

## Local setup
1. Prerequisites (runtime version, tools to install)
2. Clone and install dependencies
3. Configure environment (point to .env.example)
4. Database setup (migrations, seed if any)
5. Run the project locally
6. Run the tests

## Architecture overview
[Key components and data flows from memory/architecture.md]

## Conventions
[Naming, error handling, commit format from memory/conventions/]

## How to contribute
1. Pick a task from the backlog (link to issue tracker if known)
2. Workflow to use: /add-feature for new work, /debug-issue for bugs
3. Definition of done: tests green, code reviewed, memory updated

## Available workflows
[Table of slash commands with one-line descriptions]

## Key decisions
[List of ADRs from memory/decisions/ with their status and one-line rationale]
```

Do not invent information. If a section cannot be filled from memory/,
write: "To be documented — see [memory file] for details."

## Step 3 — Verification (agent: verifier)
Check that docs/onboarding.md:
- Contains no placeholders left unfilled that were available in memory/
- Lists all workflows currently in .claude/commands/
- Matches the stack declared in memory/stack.md
- Does not contradict memory/architecture.md

## Step 4 — Memory update (mandatory)

Answer each question explicitly:

**Did the scan reveal gaps in memory/ files?**
→ List them for the user so they can fill them manually or run the
  relevant workflow (/stack-advisor, /map-project, etc.).

**Update `memory/progress.md`:**
- Add a "Last session" entry: date, onboarding doc generated,
  memory gaps identified
