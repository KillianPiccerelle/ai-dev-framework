# Claude Code — API Backend project

## Framework: ai-dev-framework v3

## Agents
orchestrator · architect · stack-advisor · project-analyzer · codebase-analyst
backend-dev · debug · test-engineer · qa-engineer · code-reviewer · doc-writer · verifier

## Workflows
/new-project · /analyze-project · /map-project · /add-feature
/debug-issue · /refactor · /gen-tests · /project-status · /upgrade-framework

## Memory — read before any action
1. memory/project-context.md
2. memory/stack.md
3. memory/architecture.md
4. memory/conventions/
5. memory/decisions/
6. memory/progress.md

## API Backend-specific rules

Versioning: all routes prefixed with /v1/ (or current version).
Never remove a version without a deprecation period.

API contract: every response schema change is a breaking change.
Document breaking changes in CHANGELOG.

Rate limiting: apply on all public routes. Return 429 with Retry-After header.

## Fundamental rules
1. Read memory/ entirely before any action.
2. Always TDD: tests before implementation.
3. Update memory/progress.md at end of session.
4. After each error: "Update CLAUDE.md so you don't make that mistake again."

## End of session — mandatory

Before closing Claude Code, always update memory/progress.md with:
- What was done during this session
- Decisions made and why
- Current blockers if any
- Recommended next steps

The session-save hook will write an automatic snapshot regardless,
but Claude's summary is what makes the memory useful across sessions.
Ask Claude: "Summarize this session and update memory/progress.md."
