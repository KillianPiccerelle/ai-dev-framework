---
name: new-project
description: Starts a new project from scratch. Scoping, stack, architecture, structure.
---

# Workflow: new project

This workflow produces no code. It prepares everything necessary for
development to begin under good conditions.

## Step 1 — Scoping (agent: orchestrator)

Ask the user these six questions. Wait for all answers before continuing.

1. What problem does this application solve? (1 to 3 sentences)
2. Who are the users and what is their exact job-to-be-done?
3. What are the critical non-functional constraints? (performance, security, compliance)
4. What is the target date for v1?
5. What is the technical risk tolerance? (experimentation vs proven choices)
6. What resources are available? (team size, infra budget, skills)

Produce: memory/project-context.md

## Step 2 — Stack choice (skill: /stack-advisor)

Invoke the stack-advisor skill with the scoping answers.
Produce: memory/stack.md

Present the result to the user and wait for validation before continuing.

## Step 3 — Architecture (agent: architect)

Design the architecture according to the validated stack.
Identify main components and their responsibilities.
Draw data flows in ASCII.
Identify technical risks.

Produce: memory/decisions/ADR-001-architecture.md

Present and wait for validation before continuing.

## Step 4 — Conventions (agent: architect)

Define conventions specific to this project:
file and variable naming, error handling format,
commit format, directory structure.

Produce:
- memory/conventions/naming.md
- memory/conventions/error-handling.md
- memory/conventions/commit-format.md

## Step 5 — Project structure

Create the directory structure and base files according to
the project type detected during scoping.
Create a .env.example with all necessary environment variables.
Initialize the git repository with a first commit.

## Step 6 — Summary

Present to the user: what was created, the generated memory files,
and the command to start the first feature: /add-feature
