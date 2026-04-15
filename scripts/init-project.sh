#!/usr/bin/env bash
set -e

# ai-dev-framework v3 — Project initialization
# Usage: ./scripts/init-project.sh [template]
#
# template: saas | api-backend | fullstack-web | ai-app | mobile-backend | cli-tool | data-pipeline | monorepo (optional)
#
# If no template is specified, the script will auto-detect the project type:
# - Analyzes package.json, pyproject.toml, composer.json, requirements.txt
# - Looks for framework patterns and dependencies
# - Falls back to minimal CLAUDE.md if detection fails
#
# Auto-detection logic:
# - SaaS: multi-tenant, billing, organizations, Stripe/Paddle
# - API Backend: Express, FastAPI, Django REST, no frontend framework
# - Fullstack Web: React/Vue + backend framework
# - AI App: OpenAI, Anthropic, LangChain, vector databases
#
# Examples:
#   ai-framework init                    # auto-detect
#   ai-framework init saas               # force SaaS template
#   ai-framework init fullstack-web      # force Fullstack Web template

TEMPLATE=${1:-""}
FRAMEWORK_DIR="$(cd "$(dirname "$(dirname "$0")")" && pwd)"
TARGET_DIR="${PWD}"

# Function to detect project type based on file patterns
# Detection priorities:
# 1. AI App patterns (OpenAI, Anthropic, LangChain, vector DBs)
# 2. SaaS patterns (Stripe, multi-tenant, organizations, billing)
# 3. Monorepo patterns (pnpm workspaces, turbo, nx, apps/ + packages/)
# 4. Mobile Backend patterns (FCM, APNs, expo, react-native server)
# 5. Data Pipeline patterns (airflow, kafka, spark, prefect, pandas ETL)
# 6. CLI Tool patterns (commander, yargs, click, typer, cobra)
# 7. Fullstack Web patterns (frontend + backend frameworks)
# 8. API Backend patterns (backend only, no frontend framework)
# 9. Directory structure fallback (frontend/backend, src/app/api, etc.)
detect_project_type() {
  local target_dir="${1:-$TARGET_DIR}"
  local detected=""

  # Check package.json (Node.js projects)
  if [ -f "$target_dir/package.json" ]; then
    local pkg_content=$(cat "$target_dir/package.json" 2>/dev/null || echo "")

    # Check for SaaS patterns
    if echo "$pkg_content" | grep -iq -e "multi-tenant\|tenant" \
        || echo "$pkg_content" | grep -iq -e "stripe\|paddle\|recurly" \
        || echo "$pkg_content" | grep -iq -e "organization\|team\|subscription"; then
      detected="saas"

    # Check for AI app patterns
    elif echo "$pkg_content" | grep -iq -e "openai\|anthropic\|langchain\|llamaindex\|pinecone\|weaviate" \
        || echo "$pkg_content" | grep -iq -e "llama\|mistral\|gemini\|claude" \
        || echo "$pkg_content" | grep -iq -e "vector\|embedding\|rag"; then
      detected="ai-app"

    # Check for monorepo patterns
    elif [ -f "$target_dir/pnpm-workspace.yaml" ] || [ -f "$target_dir/turbo.json" ] || [ -f "$target_dir/nx.json" ] \
        || ([ -d "$target_dir/apps" ] && [ -d "$target_dir/packages" ]); then
      detected="monorepo"

    # Check for mobile backend patterns
    elif echo "$pkg_content" | grep -iq -e "firebase-admin\|fcm\|apns\|expo-server\|push-notification"; then
      detected="mobile-backend"

    # Check for CLI tool patterns
    elif echo "$pkg_content" | grep -iq -e "commander\|yargs\|meow\|oclif\|clipanion" \
        && ! echo "$pkg_content" | grep -iq -e "react\|vue\|next\|angular"; then
      detected="cli-tool"

    # Check for fullstack web patterns
    elif echo "$pkg_content" | grep -iq -e "react\|vue\|next\|nuxt\|svelte\|angular" \
        && echo "$pkg_content" | grep -iq -e "express\|fastify\|koa\|nest\|hapi"; then
      detected="fullstack-web"

    # Check for API backend patterns
    elif echo "$pkg_content" | grep -iq -e "express\|fastify\|koa\|nest\|hapi\|graphql\|rest" \
        && ! echo "$pkg_content" | grep -iq -e "react\|vue\|next\|nuxt\|svelte\|angular"; then
      detected="api-backend"
    fi
  fi

  # Check Python projects (pyproject.toml, requirements.txt)
  if [ -z "$detected" ] && [ -f "$target_dir/pyproject.toml" ]; then
    local py_content=$(cat "$target_dir/pyproject.toml" 2>/dev/null || echo "")

    # Check AI patterns first (priority)
    if echo "$py_content" | grep -iq -e "langchain\|llamaindex\|openai\|anthropic\|pinecone\|weaviate"; then
      detected="ai-app"
    elif echo "$py_content" | grep -iq -e "fastapi\|flask\|django\|starlette" \
        && echo "$py_content" | grep -iq -e "react\|vue\|next\|nuxt" 2>/dev/null; then
      detected="fullstack-web"
    elif echo "$py_content" | grep -iq -e "fastapi\|flask\|django\|starlette"; then
      detected="api-backend"
    fi
  fi

  if [ -z "$detected" ] && [ -f "$target_dir/requirements.txt" ]; then
    local req_content=$(cat "$target_dir/requirements.txt" 2>/dev/null || echo "")

    # Check AI patterns first (priority)
    if echo "$req_content" | grep -iq -e "langchain\|llamaindex\|openai\|anthropic\|pinecone\|weaviate"; then
      detected="ai-app"
    elif echo "$req_content" | grep -iq -e "apache-airflow\|prefect\|dagster\|kafka\|pyspark\|dbt\|luigi"; then
      detected="data-pipeline"
    elif echo "$req_content" | grep -iq -e "click\|typer\|argparse\|fire" \
        && ! echo "$req_content" | grep -iq -e "fastapi\|flask\|django"; then
      detected="cli-tool"
    elif echo "$req_content" | grep -iq -e "fastapi\|flask\|django\|starlette" \
        && echo "$req_content" | grep -iq -e "react\|vue\|django-rest-framework" 2>/dev/null; then
      detected="fullstack-web"
    elif echo "$req_content" | grep -iq -e "fastapi\|flask\|django\|starlette"; then
      detected="api-backend"
    fi
  fi

  # Check PHP projects (composer.json)
  if [ -z "$detected" ] && [ -f "$target_dir/composer.json" ]; then
    local composer_content=$(cat "$target_dir/composer.json" 2>/dev/null || echo "")

    if echo "$composer_content" | grep -iq -e "laravel\|symfony" \
        && echo "$composer_content" | grep -iq -e "inertia\|livewire\|vue\|react"; then
      detected="fullstack-web"
    elif echo "$composer_content" | grep -iq -e "laravel\|symfony\|slim\|laminas"; then
      detected="api-backend"
    fi
  fi

  # Fallback detection based on directory structure
  if [ -z "$detected" ]; then
    if [ -d "$target_dir/frontend" ] && [ -d "$target_dir/backend" ]; then
      detected="fullstack-web"
    elif [ -d "$target_dir/src" ] && [ -f "$target_dir/src/app/api"* ] 2>/dev/null; then
      detected="api-backend"
    elif [ -d "$target_dir/app" ] && ls "$target_dir/app"/*.py 2>/dev/null | grep -q "ai\|llm\|chat"; then
      detected="ai-app"
    fi
  fi

  echo "$detected"
}

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${BLUE}[ai-dev-framework v3]${NC} $1"; }
ok()   { echo -e "${GREEN}[ok]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }

# Auto-detect project type if no template specified
if [ -z "$TEMPLATE" ]; then
  AUTO_DETECTED=$(detect_project_type)
  if [ -n "$AUTO_DETECTED" ]; then
    if [ -f "$FRAMEWORK_DIR/templates/$AUTO_DETECTED/CLAUDE.md" ]; then
      TEMPLATE="$AUTO_DETECTED"
      log "Auto-detected project type: $TEMPLATE"
    else
      warn "Auto-detected '$AUTO_DETECTED' but template not found — using minimal"
    fi
  else
    log "No template specified and could not auto-detect — using minimal"
  fi
fi

TEMPLATE_LABEL="${TEMPLATE:-none}"
log "Init project — template: $TEMPLATE_LABEL | target: $TARGET_DIR"

# ─── Detect existing project ──────────────────────────────────────────────────
HAS_CLAUDE_MD=false
HAS_MEMORY=false
HAS_CLAUDE_DIR=false

[ -f "$TARGET_DIR/CLAUDE.md" ]  && HAS_CLAUDE_MD=true
[ -d "$TARGET_DIR/memory" ]     && HAS_MEMORY=true
[ -d "$TARGET_DIR/.claude" ]    && HAS_CLAUDE_DIR=true

if $HAS_CLAUDE_MD || $HAS_MEMORY || $HAS_CLAUDE_DIR; then
  warn "Existing Claude configuration detected."
  warn "Update mode — no existing files will be overwritten."
  warn "Run /analyze-project or /upgrade-framework in Claude Code for full migration."
  echo ""
fi

# ─── Backup old CLAUDE.md if not v3 format ────────────────────────────────────
if $HAS_CLAUDE_MD; then
  if ! grep -q "ai-dev-framework v3" "$TARGET_DIR/CLAUDE.md" 2>/dev/null; then
    warn "Old CLAUDE.md detected → backing up as CLAUDE.backup.md"
    cp "$TARGET_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.backup.md"
    grep -q "CLAUDE.backup.md" "$TARGET_DIR/.gitignore" 2>/dev/null || \
      echo "CLAUDE.backup.md" >> "$TARGET_DIR/.gitignore"
    ok "CLAUDE.backup.md created — delete after verifying migration"
    HAS_CLAUDE_MD=false
  else
    log "CLAUDE.md already v3 format — keeping as-is"
  fi
fi

# ─── Memory structure ─────────────────────────────────────────────────────────
mkdir -p "$TARGET_DIR/memory/decisions" \
         "$TARGET_DIR/memory/conventions" \
         "$TARGET_DIR/memory/domain" \
         "$TARGET_DIR/.claude/commands" \
         "$TARGET_DIR/docs"

for f in project-context.md stack.md architecture.md progress.md; do
  DEST="$TARGET_DIR/memory/$f"
  SRC="$FRAMEWORK_DIR/memory/$f"
  if [ ! -f "$DEST" ] && [ -f "$SRC" ]; then
    cp "$SRC" "$DEST"
    ok "memory/$f created"
  else
    [ -f "$DEST" ] && log "memory/$f preserved"
  fi
done

for f in naming.md error-handling.md commit-format.md; do
  DEST="$TARGET_DIR/memory/conventions/$f"
  SRC="$FRAMEWORK_DIR/memory/conventions/$f"
  if [ ! -f "$DEST" ] && [ -f "$SRC" ]; then
    cp "$SRC" "$DEST"
    ok "memory/conventions/$f created"
  fi
done

# ─── CLAUDE.md ────────────────────────────────────────────────────────────────
if ! $HAS_CLAUDE_MD; then
  if [ -n "$TEMPLATE" ] && [ -f "$FRAMEWORK_DIR/templates/$TEMPLATE/CLAUDE.md" ]; then
    cp "$FRAMEWORK_DIR/templates/$TEMPLATE/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
    ok "CLAUDE.md ($TEMPLATE template) applied"
  else
    # No template specified or template not found — generate minimal CLAUDE.md
    cat > "$TARGET_DIR/CLAUDE.md" << 'CLAUDEMD'
# Claude Code — Project configuration

## Framework: ai-dev-framework v3

## Memory — read before any action
1. memory/project-context.md
2. memory/stack.md
3. memory/architecture.md
4. memory/conventions/
5. memory/decisions/
6. memory/progress.md

## Fundamental rules
1. Read memory/ entirely before any action.
2. Never contradict an ADR without creating a new one.
3. Always TDD: tests before implementation.
4. Validate with verifier before closing a task.
5. Update memory/progress.md at end of session.
6. After each error: "Update CLAUDE.md so you don't make that mistake again."

## End of session — mandatory
Before closing Claude Code, update memory/progress.md with what was done,
decisions made, blockers, and next steps.
CLAUDEMD
    ok "CLAUDE.md (minimal) created"
  fi
fi

# ─── Workflows → .claude/commands/ ───────────────────────────────────────────
for wf in "$FRAMEWORK_DIR/workflows/"*.md; do
  WF_NAME=$(basename "$wf")
  DEST="$TARGET_DIR/.claude/commands/$WF_NAME"
  if [ ! -f "$DEST" ]; then
    cp "$wf" "$DEST"
    ok "workflow $WF_NAME installed"
  else
    cp "$wf" "$TARGET_DIR/.claude/commands/${WF_NAME%.md}.framework.md"
    log "$WF_NAME preserved — framework version saved as ${WF_NAME%.md}.framework.md"
  fi
done

# ─── Hooks ───────────────────────────────────────────────────────────────────
if [ ! -f "$TARGET_DIR/.claude/hooks.json" ] && [ -f "$FRAMEWORK_DIR/hooks/hooks.json" ]; then
  cp "$FRAMEWORK_DIR/hooks/hooks.json" "$TARGET_DIR/.claude/hooks.json"
  ok "hooks.json installed"
fi

# ─── settings.json ───────────────────────────────────────────────────────────
if [ ! -f "$TARGET_DIR/.claude/settings.json" ]; then
  cat > "$TARGET_DIR/.claude/settings.json" << 'EOF'
{
  "model": "sonnet",
  "env": {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50",
    "CLAUDE_CODE_SUBAGENT_MODEL": "haiku"
  }
}
EOF
  ok "settings.json created"
fi

# ─── .gitignore ──────────────────────────────────────────────────────────────
if [ ! -f "$TARGET_DIR/.gitignore" ]; then
  cat > "$TARGET_DIR/.gitignore" << 'EOF'
# ai-dev-framework v3
CLAUDE.backup.md
memory/project-context.md
memory/stack.md
memory/architecture.md
memory/progress.md
memory/domain/
*.local.md

# Environment
.env
.env.*
.env.local

# Dependencies
node_modules/
__pycache__/
*.pyc
vendor/

# Build
dist/
build/
.next/
out/
EOF
  ok ".gitignore created"
else
  for entry in "CLAUDE.backup.md" "memory/architecture.md"; do
    if ! grep -q "$entry" "$TARGET_DIR/.gitignore"; then
      echo "$entry" >> "$TARGET_DIR/.gitignore"
      ok ".gitignore updated — added $entry"
    fi
  done
fi

# ─── Summary ─────────────────────────────────────────────────────────────────
echo ""
ok "Project initialized — template: ${TEMPLATE:-none}"
echo ""
if $HAS_CLAUDE_MD || $HAS_MEMORY || $HAS_CLAUDE_DIR; then
  echo "Existing project detected. Recommended:"
  echo ""
  echo "  → No memory/ folder yet on this project?"
  echo "      1. Run: claude"
  echo "      2. Run: /analyze-project"
  echo "         Claude reads your codebase and generates memory/ files."
  echo ""
  echo "  → Already have a memory/ folder from a previous framework install?"
  echo "      1. Run: claude"
  echo "      2. Run: /upgrade-framework"
  echo "         Merges your existing memory with the latest structure."
else
  echo "Next steps:"
  echo "  1. Fill in memory/project-context.md"
  echo "  2. Run: claude"
  echo "  3. Run: /new-project"
fi