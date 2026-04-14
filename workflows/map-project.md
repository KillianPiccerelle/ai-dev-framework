---
name: map-project
description: Generates a complete project map. Detects modules, services, dependencies, entry points, patterns. Produces docs/project-map.md.
---

# Workflow: map project

Produces docs/project-map.md — a complete architectural overview of the codebase.
Read-only. Never modifies source code.

## Step 1 — Codebase analysis (agent: codebase-analyst)
Explore the full repository structure:
- Map all modules and their responsibilities
- Detect services and their boundaries
- Identify entry points (main files, index, app bootstraps, CLI entrypoints)
- Detect inter-module dependencies
- Identify external service integrations (DB, cache, queue, third-party APIs)

## Step 2 — Architecture pattern detection (agent: architect)
From the codebase analysis, identify:
- Overall architectural pattern (monolith, microservices, serverless, hybrid)
- Layer structure if applicable (controllers, services, repositories, domain)
- Data flow patterns (event-driven, request-response, pub-sub)
- Shared utilities and cross-cutting concerns

## Step 3 — Dependency mapping (agent: codebase-analyst)
Produce:
- Internal dependency graph (which module depends on which)
- External dependency inventory with versions
- Critical paths (paths that everything depends on)
- Circular dependencies if any (flag as issues)

## Step 4 — Generate docs/project-map.md
Create docs/ if it does not exist.
Generate docs/project-map.md with:
- Executive summary (project purpose, size, tech stack)
- Architecture diagram (ASCII)
- Module inventory table (name, responsibility, location, dependencies)
- Entry points list
- External services map
- Identified issues (circular deps, missing error handling, etc.)

## Step 4.5 — Optional visual diagrams (oh-my-mermaid)
After generating the ASCII diagram, ask: "Generate interactive architecture diagrams with oh-my-mermaid?"

If yes:
1. Run `/oh-my-mermaid scan` to analyze the codebase and generate .omm/ diagrams
2. Ask: "Push diagrams to oh-my-mermaid cloud for sharing?"
   - If yes: Run `/oh-my-mermaid push` (handles login workflow)
3. Ask: "Open local viewer to explore diagrams?"
   - If yes: Run `/oh-my-mermaid view`

If oh-my-mermaid not available or user declines:
- Continue with ASCII documentation only
- Inform user: "oh-my-mermaid plugin not installed. ASCII documentation available in docs/project-map.md"

## Step 4.6 — Optional structural dependency graph (code-review-graph)
After oh-my-mermaid option, ask: "Generate structural dependency graph with code-review-graph for token-efficient reviews?"

If yes:
1. Check if code-review-graph is installed (`pip list | grep code-review-graph`)
2. If not installed:
   - Offer to install: "code-review-graph not installed. Install with `pip install code-review-graph`?"
   - If user accepts, install and proceed
3. Run `/code-review-graph build` to analyze codebase structure
4. Show token reduction estimate for future reviews
5. Ask: "Generate interactive visualization of dependencies?"
   - If yes: Run `/code-review-graph visualize`

If code-review-graph not available or user declines:
- Continue without dependency graph
- Inform user: "code-review-graph plugin not installed. Reviews will analyze all files."

## Step 5 — Update memory/architecture.md
If memory/architecture.md exists, offer to update it with insights from the map.
Never overwrite without user confirmation.

## Step 6 — Summary
Present the generated file path and key findings to the user.
