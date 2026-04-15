# Monorepo — Claude Code Instructions

## Project type
Monorepo managing multiple packages/apps in a single repository.

## Stack defaults
- **Package manager**: pnpm workspaces (preferred) or npm/yarn workspaces
- **Build system**: Turborepo or Nx for caching and task orchestration
- **Apps**: web (Next.js/Vite), mobile (Expo/RN), backend (Node/Python)
- **Shared packages**: ui, utils, types, config, api-client
- **CI**: matrix builds per package, shared cache

## Agents to invoke
- `architect` — workspace boundaries, dependency graph, shared package design
- `frontend-dev` — app-level UI, shared component library
- `backend-dev` — API services, shared business logic packages
- `devops-engineer` — CI matrix, Docker multi-stage builds, deployment per app
- `test-engineer` — per-package tests, cross-package integration tests

## Critical patterns
- **Workspace boundaries**: packages should not import from apps — only apps import packages
- **Shared types**: define in a dedicated `packages/types` — no duplication across apps
- **Dependency pinning**: use exact versions in package.json to avoid workspace drift
- **Build order**: always define explicit task dependencies in turbo.json / nx.json
- **Change detection**: CI should only build/test affected packages (use `--filter` or affected commands)
- **Versioning**: use changesets for coordinated package releases

## Workspace structure
```
apps/
  web/          — frontend application
  api/          — backend service
packages/
  ui/           — shared component library
  types/        — shared TypeScript types
  utils/        — shared utilities
  config/       — shared ESLint, TS, Tailwind configs
```

## Memory files to maintain
- `memory/stack.md` — monorepo tooling, apps, shared packages
- `memory/architecture.md` — workspace graph, package dependency map
- `memory/conventions/` — import rules, versioning strategy, CI rules

## End-of-session rule
Before closing: update `memory/progress.md` with packages implemented and CI state.
