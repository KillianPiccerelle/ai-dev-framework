# Claude Code — AI-driven application

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

## AI application-specific rules

Prompts are code: store prompts in versioned files (prompts/), never inline.
Every prompt change is treated as a code change — review and test.

LLM calls: centralized in a single service layer. Never call LLM APIs directly
from controllers or components.

Cost tracking: every LLM call logs model, tokens in, tokens out, and cost.
Implement budget guards for user-facing features.

Streaming: implement proper streaming with error recovery for all user-facing LLM calls.

Fallbacks: every LLM feature must have a degraded fallback if the API is unavailable.

Evals: AI outputs must be evaluated. Store eval datasets in evals/.
Never ship an AI feature without at least basic quality checks.

Context management: implement context window budgets. Never silently truncate
— fail explicitly when context is exceeded.

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
