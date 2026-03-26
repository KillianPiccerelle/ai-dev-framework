# ai-dev-framework-en

> Personal AI-assisted development framework

**Author:** [KillianPiccerelle](https://github.com/KillianPiccerelle)  
**French version:** [ai-dev-framework-fr](https://github.com/KillianPiccerelle/ai-dev-framework-fr)

---

A reusable framework for building complete applications with specialized
AI agents. Centralizes agents, skills, workflows, project memory,
and ready-to-use templates.

## What's inside

**10 specialized agents** covering the full development cycle:
orchestrator, architect, stack-advisor, backend-dev, frontend-dev,
debug, test-engineer, code-reviewer, doc-writer, verifier.

**5 core skills** invokable via slash command:
stack-advisor, jwt-auth, rest-crud, schema-design, tdd-workflow.

**3 complete workflows** that orchestrate agents in the right order:
new-project, add-feature, debug-issue.

**3 project templates** with pre-configured CLAUDE.md:
SaaS, API backend, Fullstack web.

**Persistent project memory** structured in 5 types:
context, stack, conventions, ADRs, business domain.

**Automation hooks** for formatting, secret detection,
and context saving.

## Installation

```bash
git clone https://github.com/KillianPiccerelle/ai-dev-framework-en.git ~/ai-dev-framework
cd ~/ai-dev-framework
chmod +x install.sh

# Install agents and skills globally
./install.sh
```

## Start a new project

```bash
# In your project folder
~/ai-dev-framework/install.sh en saas   # or api-backend, fullstack-web

# Open Claude Code
claude

# Launch the startup workflow
/new-project
```

## Daily usage

```
/new-project      → Scope and architect a new project
/add-feature      → Add a feature (full TDD)
/debug-issue      → Analyze and resolve a bug
/stack-advisor    → Recommend a technical stack
/jwt-auth         → Implement JWT authentication
/rest-crud        → Create a complete REST endpoint
/schema-design    → Design a database schema
/tdd-workflow     → Apply TDD methodology
```

## Structure

```
ai-dev-framework-en/
├── agents/          → 10 specialized AI agents
├── skills/          → 5 invokable skills
├── workflows/       → 3 orchestrated workflows
├── memory/          → Project memory templates
├── templates/       → Project skeletons (SaaS, API, Fullstack)
├── hooks/           → Claude Code automations
├── docs/            → Framework documentation
└── install.sh       → Installation script
```

## Contributing

Contributions are welcome. See [docs/adding-agent.md](docs/adding-agent.md).

## License

MIT — [KillianPiccerelle](https://github.com/KillianPiccerelle)
