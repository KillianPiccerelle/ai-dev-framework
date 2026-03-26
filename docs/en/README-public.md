# ai-dev-framework

> Personal AI-assisted development framework — v3

**Author:** [KillianPiccerelle](https://github.com/KillianPiccerelle)
**Docs:** [English](docs/en/) · [Français](docs/fr/)

---

## What's inside

**13 specialized agents** covering the full development cycle:
orchestrator, architect, stack-advisor, project-analyzer, codebase-analyst,
backend-dev, frontend-dev, debug, test-engineer, qa-engineer,
code-reviewer, doc-writer, verifier.

**9 workflows** for every situation:
new-project, analyze-project, map-project, add-feature,
debug-issue, refactor, gen-tests, project-status, upgrade-framework.

**5 core skills**, **4 project templates** (SaaS, API, Fullstack, AI-app),
**persistent memory system**, **automation hooks**.

## Install

```bash
git clone https://github.com/KillianPiccerelle/ai-dev-framework.git ~/ai-dev-framework
cd ~/ai-dev-framework && chmod +x scripts/install.sh && ./scripts/install.sh
```

## New project

```bash
cd my-project
~/ai-dev-framework/scripts/init-project.sh saas
claude && /new-project
```

## Existing project

```bash
cd my-existing-project
~/ai-dev-framework/scripts/init-project.sh
claude && /analyze-project
```

## Migrate from v2

```bash
cd my-project && claude && /upgrade-framework
```

## Commands

```
/new-project        → Scope and architect from scratch
/analyze-project    → Analyze existing project, generate memory/
/map-project        → Generate full project map (docs/project-map.md)
/add-feature        → Add feature with full TDD
/debug-issue        → Root cause analysis and fix
/refactor           → Safe incremental refactoring
/gen-tests          → Coverage audit + targeted test generation
/project-status     → Health and progress report
/upgrade-framework  → Migrate from older framework version
```

## License
MIT — [KillianPiccerelle](https://github.com/KillianPiccerelle)
