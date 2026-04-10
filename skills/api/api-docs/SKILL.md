---
name: api-docs
description: >
  Generates OpenAPI/Swagger documentation from existing routes.
  Reads memory/stack.md to identify the HTTP framework and adapt the output.
tags: [api, documentation, openapi]
---

Read memory/stack.md and memory/conventions/ before starting.

Invoke the doc-writer agent to generate OpenAPI 3.0 documentation
from the existing routes. Adapt to the framework detected in stack.md:

- **Fastify** → produce openapi.json (Fastify schema format)
- **Express / Koa** → produce openapi.yaml (annotate manually from route inspection)
- **FastAPI** → documentation is auto-generated; produce docs/api-docs.md instead
  (FastAPI serves /docs natively — document the non-obvious endpoints only)
- **NestJS** → produce openapi.yaml (infer from decorators)

For each endpoint document:
- Method + path
- Summary (one line) and description (optional, for complex behavior)
- Path and query parameters: name, type, required, description
- Request body: schema with field types and validation constraints
- Responses: 200 (success schema), 400 (validation error), 401, 403, 404, 500
- Authentication requirement (Bearer token, cookie, public)

Output location:
- JSON/YAML spec → docs/openapi.json or docs/openapi.yaml
- If FastAPI → docs/api-docs.md

After generating, note:
- Endpoints documented
- Endpoints skipped (internal, not public-facing) with reason
- Missing information the developer must fill manually
