# Claude Code configuration — SaaS project

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
3. memory/architecture.md
4. memory/conventions/
5. memory/decisions/
6. memory/progress.md

## SaaS context — specific rules

Multi-tenancy: every database query must filter by tenant_id.
Never query without WHERE tenant_id = :current_tenant.
Test tenant isolation on every endpoint.

Billing: never store credit card data.
Use payment provider webhooks to sync state.
Payment events are idempotent.

Organizations and members: a user can belong to multiple organizations
with different roles in each.
Always verify organization_id AND user_id AND role before authorizing.

## Fundamental rules

Never implement without rereading memory/ entirely.
Never contradict an ADR without creating a new one.
Always TDD: tests before implementation.
Update memory/progress.md at end of session.
After each discovered error: "Update CLAUDE.md so you don't make that mistake again."
