# ai-dev-framework

> Personal AI-assisted development framework — v3

**Author:** [KillianPiccerelle](https://github.com/KillianPiccerelle)
**Version:** 3.0.0

---

## What's inside

**13 specialized agents** covering the full development cycle:
orchestrator, architect, stack-advisor, project-analyzer, codebase-analyst,
backend-dev, frontend-dev, debug, test-engineer, qa-engineer,
code-reviewer, doc-writer, verifier.

**9 workflows** for every development situation:
new-project, analyze-project, map-project, add-feature,
debug-issue, refactor, gen-tests, project-status, upgrade-framework.

**5 core skills**, **4 project templates** (SaaS, API, Fullstack, AI-app),
**persistent memory system**, **automation hooks**.

---

## Install

```bash
git clone https://github.com/KillianPiccerelle/ai-dev-framework.git ~/ai-dev-framework
cd ~/ai-dev-framework
chmod +x scripts/install.sh
./scripts/install.sh
```

## New project

```bash
cd my-project
~/ai-dev-framework/scripts/init-project.sh saas
claude
/new-project
```

## Existing project

```bash
cd my-existing-project
~/ai-dev-framework/scripts/init-project.sh
claude
/analyze-project
```

## Available commands

```
/new-project        → Scope and architect a new project from scratch
/analyze-project    → Analyze an existing project, generate memory/
/map-project        → Generate a full project map (docs/project-map.md)
/add-feature        → Add a feature with full TDD cycle
/debug-issue        → Root cause analysis and fix
/refactor           → Safe incremental refactoring
/gen-tests          → Coverage audit + targeted test generation
/project-status     → Health and progress report
/upgrade-framework  → Migrate from older framework version to v3
```

---

## Structure

```
ai-dev-framework/
├── agents/           → 13 specialized AI agents (English)
├── workflows/        → 9 orchestrated workflows (English)
├── skills/           → 5 invokable skills
├── memory/           → Project memory templates
├── templates/        → SaaS · API · Fullstack · AI-app
├── hooks/            → Claude Code automation hooks
├── docs/
│   ├── en/           → English documentation
│   └── fr/           → French documentation
└── scripts/
    ├── install.sh    → Global one-time installation
    └── init-project.sh → Per-project initialization
```

---

## Documentation

- [English docs](docs/en/)
- [Documentation française](docs/fr/)
- [Adding an agent](docs/en/adding-agent.md)

## Contributing

Contributions welcome. See [docs/en/adding-agent.md](docs/en/adding-agent.md).

## License

MIT — [KillianPiccerelle](https://github.com/KillianPiccerelle)
