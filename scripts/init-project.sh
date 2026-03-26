#!/usr/bin/env bash
set -e

LANG=${1:-"fr"}
TEMPLATE=${2:-"saas"}
FRAMEWORK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="${PWD}"

GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
log() { echo -e "${BLUE}[ai-dev-framework]${NC} $1"; }
ok()  { echo -e "${GREEN}[ok]${NC} $1"; }

log "Init project — lang: $LANG, template: $TEMPLATE"

mkdir -p "$TARGET_DIR/memory/decisions" "$TARGET_DIR/memory/conventions" \
         "$TARGET_DIR/memory/domain" "$TARGET_DIR/.claude/commands"

# Mémoire
for f in project-context.md stack.md progress.md; do
  [ -f "$FRAMEWORK_DIR/memory/$LANG/$f" ] && cp "$FRAMEWORK_DIR/memory/$LANG/$f" "$TARGET_DIR/memory/$f"
done
[ -d "$FRAMEWORK_DIR/memory/$LANG/conventions" ] && \
  cp -r "$FRAMEWORK_DIR/memory/$LANG/conventions/." "$TARGET_DIR/memory/conventions/"
ok "Memory templates copied"

# CLAUDE.md
if [ -f "$FRAMEWORK_DIR/templates/$TEMPLATE/$LANG/CLAUDE.md" ]; then
  cp "$FRAMEWORK_DIR/templates/$TEMPLATE/$LANG/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
  ok "CLAUDE.md ($TEMPLATE/$LANG) applied"
fi

# Workflows → commands
[ -d "$FRAMEWORK_DIR/workflows/$LANG" ] && \
  cp "$FRAMEWORK_DIR/workflows/$LANG/"*.md "$TARGET_DIR/.claude/commands/" 2>/dev/null || true
ok "Workflows copied to .claude/commands/"

# Hooks
[ -f "$FRAMEWORK_DIR/hooks/hooks.json" ] && \
  cp "$FRAMEWORK_DIR/hooks/hooks.json" "$TARGET_DIR/.claude/hooks.json" && ok "Hooks copied"

# settings.json
[ ! -f "$TARGET_DIR/.claude/settings.json" ] && cat > "$TARGET_DIR/.claude/settings.json" << 'EOF'
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

# .gitignore
[ ! -f "$TARGET_DIR/.gitignore" ] && cat > "$TARGET_DIR/.gitignore" << 'EOF'
memory/project-context.md
memory/stack.md
memory/progress.md
memory/domain/
*.local.md
.env
.env.*
node_modules/
__pycache__/
dist/
build/
.next/
EOF
ok ".gitignore created"

echo ""
ok "Project initialized in $TARGET_DIR"
[ "$LANG" = "fr" ] && echo "Lance : claude  puis  /new-project" || echo "Run: claude  then  /new-project"
