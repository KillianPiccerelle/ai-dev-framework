---
name: docker-setup
description: >
  Generates Dockerfile and docker-compose.yml adapted to the project stack.
  Invoke the devops-engineer agent. Best practices: multi-stage, non-root, health check.
tags: [devops, docker, infrastructure]
---

Read memory/stack.md before starting to identify runtime, framework, and ports.

Invoke the devops-engineer agent to generate:

**Dockerfile** — non-negotiable rules:
- Multi-stage build: builder stage (install + build) + runtime stage (copy artifacts only)
- Pin base image version (e.g. node:20-alpine, python:3.12-slim — never :latest)
- Non-root user in runtime stage
- COPY only what is needed in runtime stage (never COPY . .)
- EXPOSE the application port
- Health check instruction present
- No secrets in any layer

**docker-compose.yml** — for local development:
- App service with build context
- Database service if stack.md lists one (postgres, mysql, redis, mongodb)
- Named volumes for data persistence
- Environment variables via .env file reference (not hardcoded)
- Depends_on with condition: service_healthy where applicable

**.dockerignore** — always generated alongside Dockerfile:
- node_modules / __pycache__ / .venv
- .env and .env.*
- .git
- test files and coverage reports
- docs/

After generating, list what was produced and what the developer must do manually
(set actual env values, run `docker compose up`, etc.).
