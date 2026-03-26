# Claude Code — Fullstack Web project

## Framework: ai-dev-framework v3

## Agents
orchestrator · architect · stack-advisor · project-analyzer · codebase-analyst
backend-dev · frontend-dev · debug · test-engineer · qa-engineer
code-reviewer · doc-writer · verifier

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

## Fullstack-specific rules

Shared types: types/interfaces shared between front and back live in shared/.
Never duplicate type definitions.

API calls: centralized in src/api/ or src/services/. Never fetch in components.

Global state: only for truly global data (logged-in user, theme).
Everything else stays local to the component.

## Fundamental rules
1. Read memory/ entirely before any action.
2. Always TDD: tests before implementation.
3. Update memory/progress.md at end of session.
4. After each error: "Update CLAUDE.md so you don't make that mistake again."
