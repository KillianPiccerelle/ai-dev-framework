---
name: dependency-update
description: Securely update project dependencies with safety checks and testing.
---

# Workflow: dependency update

Safely updates project dependencies with automated testing and safety checks. Prefers patch/minor updates, avoids breaking changes.

## Step 1 — Detect package manager (orchestrator)
Read `memory/stack.md` to identify the package manager, or detect from files:
- `package.json` → npm/yarn/pnpm
- `pyproject.toml` or `requirements.txt` → pip/poetry
- `composer.json` → composer
- `go.mod` → go mod
- `Cargo.toml` → cargo
- `Gemfile` → bundler

If multiple found, ask user which to update.

## Step 2 — Analyze current dependencies (agent: codebase-analyst)
1. Read lock file if present (`package-lock.json`, `poetry.lock`, etc.)
2. Extract current versions of all dependencies
3. Identify direct vs transitive dependencies
4. Check for known vulnerabilities (if tools available)

## Step 3 — Check for updates (agent: backend-dev)
Run appropriate command to check for updates:
- npm: `npm outdated --json`
- yarn: `yarn outdated --json`
- pip: `pip list --outdated --format=json`
- poetry: `poetry show --outdated --no-ansi`
- composer: `composer outdated --format=json`
- go: `go list -m -u all`
- cargo: `cargo outdated --format=json`

Capture output for analysis.

## Step 4 — Propose safe updates (orchestrator)
1. Categorize updates:
   - **Patch** (`1.2.3` → `1.2.4`): safe, apply automatically
   - **Minor** (`1.2.3` → `1.3.0`): usually safe, propose
   - **Major** (`1.2.3` → `2.0.0`): breaking, require manual review

2. Present to user:
   - List of updates available
   - Categorization (patch/minor/major)
   - Known breaking changes if information available
   - Recommended action for each

3. Get user approval for updates to apply.

## Step 5 — Apply updates (agent: backend-dev)
1. Create backup of lock file if exists
2. Apply approved updates:
   - npm: `npm update <package>`
   - yarn: `yarn upgrade <package>`
   - pip: update in requirements.txt and run `pip install -U <package>`
   - poetry: `poetry update <package>`

3. Update lock file if applicable.

## Step 6 — Run tests (agent: test-engineer)
1. Run test suite to ensure updates don't break existing functionality
2. If tests fail:
   - Revert the specific update
   - Log as incompatible
   - Move to manual review list

## Step 7 — Security check (agent: security-reviewer)
1. Run security audit if tool available:
   - npm: `npm audit`
   - yarn: `yarn audit`
   - pip: `safety check` (if installed)
   - cargo: `cargo audit`

2. Report any new vulnerabilities introduced.

## Step 8 — Generate update report (orchestrator)
Create `docs/dependency-update-YYYY-MM-DD.md` with:
- Date and package manager used
- List of updates applied (with before/after versions)
- List of updates skipped/rejected (with reasons)
- Test results summary
- Security audit findings
- Recommendations for manual review needed

## Step 9 — Update memory (orchestrator)
Add entry to `memory/progress.md`:
- Date of dependency update
- Summary of changes
- Link to full report

## Memory update (mandatory)
- [x] Add dependency update entry to `memory/progress.md`
- [x] Link to `docs/dependency-update-YYYY-MM-DD.md`

## Safety rules
1. Never update major versions without explicit user approval
2. Always run tests after each update (or batch of patch updates)
3. Keep backups of lock files before updating
4. If tests fail, revert immediately
5. Prefer incremental updates over mass updates

## Fallback for missing tools
If package manager detection fails or no update tool available:
1. Inform user manual update required
2. Provide instructions for their specific stack
3. Still generate report template for manual use