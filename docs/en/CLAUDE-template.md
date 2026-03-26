# ai-dev-framework — Claude Code configuration

## Language
English

## Available agents

Copy files from `agents/` into `~/.claude/agents/` to activate globally.
Invoke: "use the [name] agent" or naturally in Claude Code.

| Agent | Role | Model |
|-------|------|-------|
| orchestrator | Coordinates and delegates to other agents | sonnet |
| architect | Designs architecture, produces ADRs | opus |
| stack-advisor | Recommends technical stack | sonnet |
| backend-dev | Implements API, DB, business logic | sonnet |
| frontend-dev | Implements UI, components, state | sonnet |
| debug | Analyzes bugs, finds root cause | sonnet |
| test-engineer | Writes tests, applies TDD | sonnet |
| code-reviewer | Audits code in read-only mode | sonnet |
| doc-writer | Writes and updates documentation | sonnet |
| verifier | Validates completed work | haiku |

## Available skills

Copy files from `skills/` into `~/.claude/skills/` to activate globally.

| Skill | Command | Usage |
|-------|---------|-------|
| Stack Advisor | `/stack-advisor` | Recommends a stack for the project |
| JWT Auth | `/jwt-auth` | Implements JWT authentication |
| REST CRUD | `/rest-crud` | Creates a complete REST endpoint |
| Schema Design | `/schema-design` | Designs a database schema |
| TDD Workflow | `/tdd-workflow` | Applies TDD methodology |

## Available workflows

Copy files from `workflows/` into `.claude/commands/` of your project.

| Workflow | Command | Usage |
|----------|---------|-------|
| New project | `/new-project` | Starts a project from scratch |
| Add feature | `/add-feature` | Adds a feature |
| Debug | `/debug-issue` | Analyzes and resolves a bug |

## Fundamental rules

1. Read memory/ entirely before any action.
2. Never contradict an ADR without creating a new one.
3. Always TDD: tests before implementation.
4. Validate with the verifier agent before closing a task.
5. Update memory/progress.md at end of session.
6. After each error: "Update CLAUDE.md so you don't make that mistake again."
