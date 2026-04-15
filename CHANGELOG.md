# Changelog

All notable changes to ai-dev-framework are documented here.

Format: [Semantic Versioning](https://semver.org) — `feat` bumps minor, `fix` bumps patch.

---

## [v3.1.0] — 2026-04-15

### Added
- **Phase 4 — MCP integration**: 4 new skills for external context
  - `/mcp-github` — issues, PRs, commits via official github-mcp-server
  - `/mcp-jira` — tickets, sprints via community MCP servers
  - `/mcp-notion` — external documentation via Notion MCP server
  - `/mcp-sync` — orchestrator: sync GitHub + Jira + Notion → memory/ with conflict resolution
- **Phase 3 — Developer experience**:
  - `ai-framework doctor` — full installation health diagnostic
  - `ai-framework list` — list all agents, workflows, skills
  - Bash/zsh autocompletion for `ai-framework` commands
- **New workflows**: `/perf-audit`, `/dependency-update`, `/accessibility-audit`
- Helper scripts: `perf-helper.py`, `a11y-helper.py`, `dependency-helper.py`
- **Phase 5 — Documentation & templates**:
  - `CHANGELOG.md` — versioned history
  - `docs/contributing.md` (EN) + `docs/fr/contributing.md` (FR)
  - Version, license, and Claude Code badges in README
  - 4 new project templates: `mobile-backend`, `cli-tool`, `data-pipeline`, `monorepo`
  - Auto-detection in `init-project.sh` for new template types
  - Autocompletion updated for all 8 templates

### Changed
- Skills count: 10 → 14
- Workflows count: 12 → 15
- Templates count: 4 → 8
- Version bumped to v3.1.0

---

## [v3.0.0] — 2026-03-01

### Added
- **Phase 2 — Version management**:
  - `ai-framework version` — show, check (GitHub), set
  - `/project-status` — timestamped reports with ASCII progress graph, 10-report history
- **Phase 1 — Core infrastructure**:
  - 15 specialized agents: orchestrator, architect, stack-advisor, project-analyzer, codebase-analyst, backend-dev, frontend-dev, debug, test-engineer, qa-engineer, code-reviewer, doc-writer, verifier, security-reviewer, devops-engineer
  - 12 workflows: /new-project, /analyze-project, /map-project, /add-feature, /debug-issue, /refactor, /gen-tests, /project-status, /upgrade-framework, /security-audit, /setup-ci, /onboard
  - 10 skills: stack-advisor, jwt-auth, rest-crud, schema-design, tdd-workflow, docker-setup, env-setup, api-docs, oh-my-mermaid, code-review-graph
  - 4 templates: saas, api-backend, fullstack-web, ai-app
  - 4 security hooks: secret-detector, safety-guard, format-check, session-save
  - Global CLI: `ai-framework init|update|install|version|doctor|list`
  - `init-project.sh` with auto-detection (Node.js, Python, PHP)
  - Bash/zsh autocompletion

### Security
- `format-check.js` — fixed command injection (execFileSync)
- `secret-detector.js` — 13 patterns (Anthropic, OpenAI, Stripe, Bearer, PEM, DB URLs, GitHub tokens)
- `safety-guard.js` — blocks rm -fr, git push -f, TRUNCATE, chmod 777, DELETE without WHERE

---

## [v2.0.0] — 2026-01-15

### Added
- project-analyzer agent
- /analyze-project, /refactor, /gen-tests workflows
- ai-app template

---

## [v1.0.0] — 2025-12-01

### Added
- Initial framework: 13 agents, 9 workflows, single public repo
