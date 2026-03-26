# Claude Code configuration — Fullstack Web

## Framework
This project uses ai-dev-framework. Language: English.

## Available agents
orchestrator · architect · stack-advisor · backend-dev · frontend-dev
debug · test-engineer · code-reviewer · doc-writer · verifier

## Available commands
/new-project · /add-feature · /debug-issue
/stack-advisor · /jwt-auth · /rest-crud · /schema-design · /tdd-workflow

## Project memory — read before any action
1. memory/project-context.md
2. memory/stack.md
3. memory/conventions/
4. memory/decisions/
5. memory/progress.md

## Fullstack context — specific rules

Shared types: types/interfaces shared between front and back live
in a shared/ folder at the root. Never duplicate.

API calls client-side: centralized in src/api/ or src/services/.
Never fetch directly inside components.

Global state: use only for what is truly global
(logged-in user, theme). Everything else stays local to the component.

## Fundamental rules

Never implement without rereading memory/ entirely.
Always TDD: tests before implementation.
Update memory/progress.md at end of session.
After each discovered error: "Update CLAUDE.md so you don't make that mistake again."
