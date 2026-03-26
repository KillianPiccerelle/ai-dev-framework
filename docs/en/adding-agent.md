# Adding an agent to the framework

## Agent file structure

Create agents/my-agent.md with this format:

```markdown
---
name: my-agent
description: >
  Clear description. Explains what the agent does, when to invoke it,
  and what it does NOT do. This description is read by Claude to decide
  if the agent is relevant for a given request.
tools: [Read, Write, Edit, Bash, Grep, Glob]
model: sonnet
readonly: false
---

Agent system instructions...
```

## Frontmatter fields

**name**: unique identifier, kebab-case, matches filename.

**description**: used by Claude to determine relevance.
Answer: when to invoke, what it produces, what it avoids.

**tools**: least privilege principle — grant only what is needed.
Read, Write, Edit, Bash, Grep, Glob.

**model**: opus (complex tasks), sonnet (standard), haiku (quick validations).

**readonly**: true if the agent must never modify files.

## Writing rules

The agent must know what to read in memory/ before acting.
The agent must know what to produce and where.
The agent must have a clear rule about what it does NOT do.

## Publishing after adding

```bash
./scripts/publish.sh
```
