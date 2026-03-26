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

## Step 5 — Update memory/architecture.md
If memory/architecture.md exists, offer to update it with insights from the map.
Never overwrite without user confirmation.

## Step 6 — Summary
Present the generated file path and key findings to the user.
