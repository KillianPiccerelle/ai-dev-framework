#!/usr/bin/env bash
set -e

# ai-dev-framework v3 — Project initialization
# Usage: ./scripts/init-project.sh [template]
# template: saas | api-backend | fullstack-web | ai-app (optional)

TEMPLATE=${1:-""}
FRAMEWORK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="${PWD}"

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${BLUE}[ai-dev-framework v3]${NC} $1"; }
ok()   { echo -e "${GREEN}[ok]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }

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