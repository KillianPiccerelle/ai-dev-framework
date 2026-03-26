---
name: new-project
description: Starts a new project from scratch. Scoping, stack, architecture, structure.
---

# Workflow: new project

Produces no code. Prepares everything for development to begin properly.

## Step 1 — Scoping (orchestrator)
Ask the user these six questions. Wait for all answers before continuing.
1. What problem does this application solve? (1-3 sentences)
2. Who are the users and what is their exact job-to-be-done?
3. What are the critical non-functional constraints? (performance, security, compliance)
4. What is the target date for v1?
5. What is the technical risk tolerance? (experimentation vs proven choices)
6. What resources are available? (team size, infra budget, skills)

Produce: memory/project-context.md

## Step 2 — Stack choice (skill: /stack-advisor)
Invoke stack-advisor with scoping answers.
Produce: memory/stack.md
Validate with user before continuing.

## Step 3 — Architecture (agent: architect)
Design architecture from validated stack. ASCII data flows.
Identify risks and main components.
Produce: memory/decisions/ADR-001-architecture.md
Validate with user before continuing.

## Step 4 — Conventions (agent: architect)
Define project-specific conventions.
Produce: memory/conventions/naming.md, error-handling.md, commit-format.md

## Step 5 — Project structure
Create directory structure and base files per project type.
Create .env.example with all required environment variables.
Initialize git with first commit.

## Step 6 — Summary
Present: what was created, generated memory files, command to start: /add-feature

The generated CLAUDE.md MUST always include this end-of-session section:

---
## End of session — mandatory

Before closing Claude Code, always update memory/progress.md with:
- What was done during this session
- Decisions made and why
- Current blockers if any
- Recommended next steps

The session-save hook writes an automatic snapshot regardless,
but Claude's summary is what makes memory useful across sessions.
Ask Claude: "Summarize this session and update memory/progress.md."
---