# Claude Code configuration — API Backend

## Framework
This project uses ai-dev-framework. Language: English.

## Available agents
orchestrator · architect · stack-advisor · backend-dev
debug · test-engineer · code-reviewer · doc-writer · verifier

## Available commands
/new-project · /add-feature · /debug-issue
/stack-advisor · /jwt-auth · /rest-crud · /schema-design · /tdd-workflow

## Project memory — read before any action
1. memory/project-context.md
2. memory/stack.md
3. memory/architecture.md
4. memory/conventions/
5. memory/decisions/
6. memory/progress.md

## API Backend context — specific rules

Versioning: all routes are prefixed with /v1/ (or current version).
Never remove a minor version without a deprecation period.

API contract: every response schema change is a breaking change.
Document breaking changes in a CHANGELOG.

Rate limiting: apply on all public routes.
Return 429 with a Retry-After header.

## Fundamental rules

Never implement without rereading memory/ entirely.
Always TDD: tests before implementation.
Update memory/progress.md at end of session.
After each discovered error: "Update CLAUDE.md so you don't make that mistake again."
