# Adding an agent to the framework

## Agent structure

Each agent is a Markdown file in `agents/fr/` and `agents/en/`.

```
agents/
├── fr/
│   └── my-agent.md
└── en/
    └── my-agent.md
```

## File format

```markdown
---
name: my-agent
description: >
  Clear and concise description. Explains what the agent does,
  in what context to invoke it, and what it doesn't do.
  This description is read by Claude to decide if the agent is relevant.
tools: [Read, Write, Edit, Bash, Grep, Glob]
model: sonnet
readonly: false
---

Agent system instructions...
```

## Frontmatter fields

**name**: unique identifier, kebab-case, matches the file name.

**description**: used by Claude to decide if the agent is relevant.
Must answer: when to invoke it, what it produces, what it doesn't do.

**tools**: list of allowed tools. Least privilege principle:
grant only what is necessary.
- `Read`: read files
- `Write`: create files
- `Edit`: modify existing files
- `Bash`: execute commands
- `Grep`: search in files
- `Glob`: list files by pattern

**model**: `opus` for complex tasks (architecture, decisions),
`sonnet` for common tasks, `haiku` for quick validations.

**readonly**: `true` if the agent must never modify files.

## Writing rules

The agent must know what to read in `memory/` before acting.
The agent must know what to produce and where to put it.
The agent must have a clear rule about what it doesn't do.

## Publish after adding

```bash
./scripts/publish.sh
```
