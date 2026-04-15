# CLI Tool — Claude Code Instructions

## Project type
Command-line application distributed as a standalone binary or npm/pip package.

## Stack defaults
- **Node.js**: Commander.js or yargs, chalk, ora, inquirer
- **Python**: Click or Typer, rich, questionary
- **Go**: cobra, urfave/cli
- **Distribution**: npm publish, PyPI, GitHub Releases (binary)

## Agents to invoke
- `backend-dev` — command logic, argument parsing
- `test-engineer` — unit tests per command, integration tests with subprocess
- `doc-writer` — man page, --help text, README usage section
- `devops-engineer` — CI/CD for multi-platform binary builds

## Critical patterns
- **Exit codes**: 0 = success, 1 = usage error, 2 = runtime error — be consistent
- **--help**: every command and subcommand must have a help text
- **stdin/stdout/stderr**: data on stdout, logs/errors on stderr — never mix
- **Config**: support env vars, config file (~/.toolrc), and CLI flags — CLI wins
- **Idempotency**: commands that modify state should be safe to run twice
- **No hidden side effects**: document every file the tool writes/reads

## Memory files to maintain
- `memory/stack.md` — language, CLI framework, distribution target
- `memory/architecture.md` — command tree, config resolution order
- `memory/conventions/` — exit code conventions, flag naming

## End-of-session rule
Before closing: update `memory/progress.md` with implemented commands.
