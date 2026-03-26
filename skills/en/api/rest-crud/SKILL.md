---
name: rest-crud
description: >
  Creates a complete REST endpoint (CRUD) for a given resource.
  Includes validation, pagination, error handling, tests.
tags: [api, rest, crud]
---

Read memory/stack.md to identify the HTTP framework and ORM used.
Read memory/conventions/error-handling.md for the error format.

This skill produces for a [NAME] resource:

Routes:
- GET    /[resources]            → paginated list
- GET    /[resources]/:id        → element detail
- POST   /[resources]            → creation
- PUT    /[resources]/:id        → full update
- DELETE /[resources]/:id        → deletion

Pagination: cursor-based (more robust than offset), cursor and limit parameters.
Uniform response format:
- List success: { data: [...], nextCursor: "...", total: N }
- Element success: { data: {...} }
- Error: { error: { code: "...", message: "..." } }

Input validation mandatory on POST and PUT.
Each authenticated route checks permissions before acting.

Tests to produce:
- Nominal CRUD (create, read, update, delete)
- Pagination (first page, next page, last page)
- Validation (missing fields, incorrect types)
- Permissions (accessing another user's resource → 403)
- Non-existent resource → 404
