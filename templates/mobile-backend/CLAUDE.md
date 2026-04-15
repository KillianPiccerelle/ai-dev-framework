# Mobile Backend — Claude Code Instructions

## Project type
REST/GraphQL API backend for mobile applications (iOS/Android).

## Stack defaults
- **Runtime**: Node.js (Express/Fastify) or Python (FastAPI)
- **Auth**: JWT + refresh tokens, OAuth2 (Google, Apple)
- **Push notifications**: FCM (Firebase) + APNs
- **Database**: PostgreSQL + Redis (sessions/cache)
- **File storage**: S3-compatible (uploads, avatars)
- **Offline sync**: conflict resolution via timestamp or vector clocks

## Agents to invoke
- `/analyze-project` — map existing codebase before any changes
- `backend-dev` — API endpoints, business logic
- `security-reviewer` — auth flows, token handling, mobile-specific attack surfaces
- `test-engineer` — auth flows, push delivery, sync conflict tests

## Critical patterns
- **Auth**: always issue short-lived access tokens (15min) + long-lived refresh tokens
- **Push**: idempotent delivery — handle duplicate sends gracefully
- **Offline sync**: never lose client data — use last-write-wins or manual conflict resolution
- **Rate limiting**: per user, per device — not just per IP
- **File uploads**: validate MIME type server-side, not just extension

## Memory files to maintain
- `memory/stack.md` — runtime, auth provider, push service
- `memory/architecture.md` — API structure, sync strategy
- `memory/decisions/` — auth flow choices, sync conflict resolution approach

## End-of-session rule
Before closing: update `memory/progress.md` with current sprint state.
