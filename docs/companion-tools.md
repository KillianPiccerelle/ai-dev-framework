# Companion Tools

Tools that work alongside ai-dev-framework without being part of it.
Install and use independently — they complement the framework without replacing anything.

---

## cc-lens — Claude Code Analytics Dashboard

**Install & run:**
```bash
npx cc-lens
```

**What it shows:**
- Token consumption and estimated costs per project and session
- Session replay — reconstruct full Claude Code interactions from local JSONL files
- Activity calendar (GitHub-style usage streaks)
- Tool usage rankings, MCP server adoption
- Project-level cost breakdown by model

**Why it's useful with this framework:**
- Identify which agents are the most token-expensive
- Spot inefficient workflows (high token count, low output)
- Track real costs of long workflows like `/add-feature` or `/security-audit`
- All data stays local — reads from `~/.claude/` only

**Source:** https://github.com/Arindam200/cc-lens

---

## ccxray — Claude Code API Transparency Proxy

**Install:**
```bash
npm install -g ccxray
# or
npx ccxray
```

**What it shows:**
- Real-time HTTP proxy between Claude Code and the Anthropic API
- Token count per request, cost per call
- Context window visualization — see how full it is at each step
- Full request/response log for debugging agent behavior

**Why it's useful with this framework:**
- Debug why an agent produces unexpected output
- Identify context window pressure in long workflows
- Verify that memory/ files are being loaded as expected
- Tune agent prompts based on actual token usage

**Source:** https://github.com/hesreallyhim/awesome-claude-code (search "ccxray")

---

## Model routing in ai-dev-framework

Each agent has a `model:` field in its frontmatter. Here are the criteria:

| Model | When to use | Agents |
|-------|-------------|--------|
| `opus` | Deep reasoning, architecture, security — decisions that are hard to reverse | `architect`, `security-reviewer`, `project-analyzer` |
| `sonnet` | Implementation, analysis, review — most development tasks | `backend-dev`, `frontend-dev`, `debug`, `test-engineer`, `code-reviewer`, `qa-engineer`, `codebase-analyst`, `stack-advisor`, `devops-engineer`, `orchestrator` |
| `haiku` | Simple checklist verification, formatting, documentation — fast and cheap | `verifier`, `doc-writer` |

**Rule of thumb:** If the agent makes decisions (architectural, security, analysis), use `opus`. If it implements or reviews, use `sonnet`. If it validates or writes text, use `haiku`.

To override for a specific session:
```bash
claude --model claude-opus-4-6  # force opus for the whole session
```
