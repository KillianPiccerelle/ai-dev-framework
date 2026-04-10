---
name: setup-ci
description: >
  Generates CI/CD configuration adapted to the detected stack.
  Reads memory/stack.md to produce GitHub Actions pipeline, Dockerfile,
  and optional deployment config (Railway, Fly.io, Vercel).
---

# Workflow: setup CI

Precondition: memory/stack.md must exist and be filled.
If missing, run /stack-advisor first.

## Step 1 — Stack reading (agent: codebase-analyst)
Read memory/stack.md to confirm: runtime, framework, test runner, linter,
build tool, and deployment target.
If stack.md is incomplete, ask the user to fill the missing fields before continuing.

## Step 2 — CI/CD generation (agent: devops-engineer)
Based on step 1 findings, generate:

**Always produced:**
- `.github/workflows/ci.yml` — lint → test → build, with dependency cache,
  triggered on push and pull_request to main

**Produced if stack.md indicates a containerized deployment:**
- `Dockerfile` — multi-stage, non-root user, pinned base image, health check
- `.dockerignore`

**Produced only if stack.md specifies the deployment target:**
- `railway.toml` → if Railway
- `fly.toml` → if Fly.io
- `vercel.json` → if Vercel

**Always produced:**
- `.env.example` — scanned from source, grouped by concern, every variable
  present with no real values, each one commented

## Step 3 — Review (agent: code-reviewer)
Read-only check of generated config files.
Flag: hardcoded secrets, missing cache, wrong trigger, insecure image setup.
If REJECTED: devops-engineer fixes BLOCKING items and resubmits.

## Step 4 — User handoff
Present to the user:
- List of files generated with their purpose
- Manual steps required (GitHub repo secrets to add, environment variables
  to set on the platform, first deploy command to run)
- What the CI pipeline will do on each push

## Step 5 — Memory update (mandatory)

Answer each question explicitly:

**New files added to the repo?**
→ Update `memory/architecture.md` — note the CI/CD setup in the
  infrastructure section.

**Deployment target confirmed?**
→ Update `memory/stack.md` — ensure the Deployment row reflects
  the platform the config was generated for.

**Update `memory/progress.md`:**
- Add a "Last session" entry: date, files generated, platform targeted,
  manual steps remaining
