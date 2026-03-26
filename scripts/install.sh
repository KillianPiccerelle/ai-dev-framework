#!/usr/bin/env bash
set -e

# ai-dev-framework v3 — Global installation
# Usage: ./scripts/install.sh

FRAMEWORK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
log() { echo -e "${BLUE}[ai-dev-framework v3]${NC} $1"; }
ok()  { echo -e "${GREEN}[ok]${NC} $1"; }

log "Installing ai-dev-framework v3 globally..."

mkdir -p ~/.claude/agents ~/.claude/skills ~/.claude/hooks

# Agents
cp "$FRAMEWORK_DIR/agents/"*.md ~/.claude/agents/
ok "13 agents installed in ~/.claude/agents/"

# Skills
cp -r "$FRAMEWORK_DIR/skills/." ~/.claude/skills/
ok "Skills installed in ~/.claude/skills/"

# Hooks
cp "$FRAMEWORK_DIR/hooks/hooks.json" ~/.claude/hooks/hooks.json
mkdir -p ~/.claude/hooks/scripts
cp "$FRAMEWORK_DIR/hooks/scripts/"*.js ~/.claude/hooks/scripts/ 2>/dev/null || true
chmod +x ~/.claude/hooks/scripts/*.js 2>/dev/null || true
ok "Hooks installed in ~/.claude/hooks/"

# Global settings.json
if [ ! -f ~/.claude/settings.json ]; then
  cat > ~/.claude/settings.json << 'SETTINGS'
{
  "model": "sonnet",
  "env": {
    "MAX_THINKING_TOKENS": "10000",
    "CLAUDE_AUTOCOMPACT_PCT_OVERRIDE": "50",
    "CLAUDE_CODE_SUBAGENT_MODEL": "haiku"
  }
}
SETTINGS
  ok "settings.json created in ~/.claude/"
fi

echo ""
ok "Installation complete."
echo ""
echo "Next steps:"
echo "  New project  : cd my-project && $FRAMEWORK_DIR/scripts/init-project.sh saas"
echo "  Existing     : cd my-project && $FRAMEWORK_DIR/scripts/init-project.sh"
echo "  Then         : claude && /new-project  or  /analyze-project"
