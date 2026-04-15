---
name: repomix
description: >
  Pack an entire repository into a single LLM-optimized file.
  Uses Repomix (Tree-sitter compression, ~70% token reduction) to ingest
  local or remote repos as context for analysis, onboarding, or comparison.
tags: [context, analysis, codebase, repomix, external-repo]
---

# Skill: repomix

Pack a codebase — local or remote — into a single file optimized for LLM consumption. Built on [Repomix](https://github.com/yamadashy/repomix) (22.7k★).

---

## Prerequisites

Repomix must be installed as a Claude Code skill:

```bash
npx add-skill yamadashy/repomix --skill repomix-explorer
```

Or use it directly via npx without installation:

```bash
npx repomix --help
```

---

## Quick start

```bash
# Pack current directory
npx repomix

# Pack a remote GitHub repo
npx repomix --remote https://github.com/owner/repo

# Pack with custom output file
npx repomix --output context.txt

# Pack only specific paths
npx repomix src/ docs/

# Exclude test files and node_modules
npx repomix --ignore "**/*.test.*,node_modules,dist"
```

---

## Common use cases

### 1. Analyze an external library
When you need to understand a dependency deeply before integrating it:

```bash
npx repomix --remote https://github.com/owner/library --output library-context.txt
```
Then read `library-context.txt` as context before implementing the integration.

### 2. Onboard on a new codebase
Before running `/analyze-project` on a large repo, pack it first to get a structured overview:

```bash
npx repomix --output full-context.txt
```

### 3. Compare two implementations
Pack both repos separately, then compare patterns:

```bash
npx repomix --remote https://github.com/owner/repo-a --output repo-a.txt
npx repomix --remote https://github.com/owner/repo-b --output repo-b.txt
```

### 4. Security audit preparation
Pack the codebase and feed it to `security-reviewer` for a full sweep:

```bash
npx repomix --output security-context.txt
# Then invoke security-reviewer with security-context.txt as context
```

---

## Output formats

| Flag | Format | Best for |
|------|--------|----------|
| *(default)* | Plain text | General LLM input |
| `--style xml` | XML tags | Claude (structured parsing) |
| `--style markdown` | Markdown | Documentation |

Recommended for this framework:
```bash
npx repomix --style xml --output context.xml
```

---

## Token optimization options

```bash
# Remove comments (reduces noise)
npx repomix --remove-comments

# Remove empty lines
npx repomix --remove-empty-lines

# Show token count before packing
npx repomix --token-count-only
```

---

## .repomixignore

Create a `.repomixignore` file in the project root to permanently exclude files (same syntax as `.gitignore`):

```
node_modules/
dist/
*.lock
*.log
coverage/
.env*
```

---

## Integration with framework workflows

| Workflow | How Repomix helps |
|----------|------------------|
| `/analyze-project` | Pre-pack large repos before analysis to reduce context switching |
| `/map-project` | Generate a full-context file before Mermaid diagram generation |
| `/security-audit` | Feed packed codebase to `security-reviewer` for complete sweep |
| `/onboard` | Pack repo + feed to `doc-writer` for onboarding guide generation |
| `/code-review-graph` | Use alongside code-review-graph for dual-mode analysis |

---

## Agent instructions

When using `/repomix` as context preparation:

1. Run `npx repomix --style xml --output .repomix-context.xml`
2. Add `.repomix-context.xml` to `.gitignore` (it's a generated file)
3. Reference the packed file in your next agent invocation
4. Delete the file after use to avoid stale context

```bash
# Add to .gitignore
echo ".repomix-context.xml" >> .gitignore
echo "*.repomix-context.*" >> .gitignore
```
