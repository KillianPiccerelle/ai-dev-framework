---
name: rest-crud
description: >
  Creates a complete REST endpoint (CRUD) for a given resource.
  Includes validation, pagination, error handling, tests.
tags: [api, rest, crud]
---

Read memory/stack.md and memory/conventions/error-handling.md before starting.

Routes for [RESOURCE]:
- GET    /resources         → cursor-based paginated list
- GET    /resources/:id     → element detail
- POST   /resources         → creation
- PUT    /resources/:id     → full update
- DELETE /resources/:id     → deletion

Pagination: cursor-based (more robust than offset).
Response format:
- List: { data: [...], nextCursor: "...", total: N }
- Single: { data: {...} }
- Error: { error: { code: "...", message: "..." } }

Input validation mandatory on POST and PUT.
Every authenticated route checks permissions before acting.

Tests: CRUD nominal, pagination, validation errors, permission errors (403), 404.
