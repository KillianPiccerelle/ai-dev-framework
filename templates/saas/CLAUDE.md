# Claude Code — SaaS project

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

## SaaS-specific rules

Multi-tenancy: every database query must filter by tenant_id.
Never query without WHERE tenant_id = :current_tenant.
Test tenant isolation on every endpoint.

Billing: never store credit card data. Use payment provider webhooks.
Payment events are idempotent.

Organizations: a user can belong to multiple organizations with different roles.
Always verify organization_id AND user_id AND role before authorizing.

## Fundamental rules
1. Read memory/ entirely before any action.
2. Never contradict an ADR without creating a new one.
3. Always TDD: tests before implementation.
4. Validate with verifier before closing a task.
5. Update memory/progress.md at end of session.
6. After each error: "Update CLAUDE.md so you don't make that mistake again."
