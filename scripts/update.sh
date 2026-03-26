#!/usr/bin/env bash
set -e

# ai-dev-framework — update.sh
# Updates the framework to the latest version.
# Pulls latest changes from GitHub, refreshes global agents and skills.
# Never touches your project files.

FRAMEWORK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
AGENTS_DIR="$HOME/.claude/agents"
SKILLS_DIR="$HOME/.claude/skills"
HOOKS_DIR="$HOME/.claude/hooks"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${BLUE}[update]${NC} $1"; }
ok()   { echo -e "${GREEN}[ok]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }

echo ""
log "ai-dev-framework — checking for updates..."
echo ""

# ─── Step 1: Get current version info ─────────────────────────────────────────

cd "$FRAMEWORK_DIR"

CURRENT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
CURRENT_DATE=$(git log -1 --format="%ci" 2>/dev/null | cut -d' ' -f1 || echo "unknown")

log "Current version : $CURRENT_COMMIT ($CURRENT_DATE)"

# ─── Step 2: Pull latest changes ──────────────────────────────────────────────

log "Pulling latest changes from GitHub..."

git fetch origin main --quiet

REMOTE_COMMIT=$(git rev-parse --short origin/main 2>/dev/null || echo "unknown")

if [ "$CURRENT_COMMIT" = "$REMOTE_COMMIT" ]; then
  ok "Already up to date ($CURRENT_COMMIT)."
  echo ""
  exit 0
fi

# Show what changed
echo ""
log "Changes since your version:"
git log --oneline HEAD..origin/main 2>/dev/null || true
echo ""

git pull origin main --quiet
NEW_COMMIT=$(git rev-parse --short HEAD)
ok "Updated to $NEW_COMMIT."

# ─── Step 3: Detect what changed ──────────────────────────────────────────────

CHANGED_AGENTS=$(git diff HEAD@{1} HEAD --name-only 2>/dev/null | grep '^agents/' || true)
CHANGED_SKILLS=$(git diff HEAD@{1} HEAD --name-only 2>/dev/null | grep '^skills/' || true)
CHANGED_HOOKS=$(git diff HEAD@{1} HEAD --name-only 2>/dev/null | grep '^hooks/' || true)

# ─── Step 4: Refresh global agents ────────────────────────────────────────────

echo ""
log "Refreshing global agents in ~/.claude/agents/..."

# Remove old framework agents (keep any custom agents the user added manually)
# We only remove agents that exist in the framework source
for agent_file in "$FRAMEWORK_DIR/agents/"*.md; do
  agent_name=$(basename "$agent_file")
  [ -f "$AGENTS_DIR/$agent_name" ] && rm -f "$AGENTS_DIR/$agent_name"
done

# Copy fresh agents
cp "$FRAMEWORK_DIR/agents/"*.md "$AGENTS_DIR/"
AGENT_COUNT=$(ls "$FRAMEWORK_DIR/agents/"*.md | wc -l | tr -d ' ')
ok "$AGENT_COUNT agents refreshed."

if [ -n "$CHANGED_AGENTS" ]; then
  warn "Updated agents:"
  echo "$CHANGED_AGENTS" | sed 's/agents\//  → /' | sed 's/\.md//'
fi

# ─── Step 5: Refresh global skills ────────────────────────────────────────────

log "Refreshing global skills in ~/.claude/skills/..."

cp -r "$FRAMEWORK_DIR/skills/." "$SKILLS_DIR/"
ok "Skills refreshed."

# ─── Step 6: Refresh hooks ────────────────────────────────────────────────────

if [ -f "$FRAMEWORK_DIR/hooks/hooks.json" ]; then
  log "Refreshing hooks..."
  cp "$FRAMEWORK_DIR/hooks/hooks.json" "$HOOKS_DIR/hooks.json"
  if [ -d "$FRAMEWORK_DIR/hooks/scripts" ]; then
    mkdir -p "$HOOKS_DIR/scripts"
    cp "$FRAMEWORK_DIR/hooks/scripts/"*.js "$HOOKS_DIR/scripts/" 2>/dev/null || true
    chmod +x "$HOOKS_DIR/scripts/"*.js 2>/dev/null || true
  fi
  ok "Hooks refreshed."
fi

# ─── Step 7: Remind about project workflows ───────────────────────────────────

echo ""
warn "Note: workflows in your projects' .claude/commands/ are NOT updated automatically."
warn "To update a specific project, run from its root:"
echo ""
echo "  cd your-project"
echo "  ~/ai-dev-framework/scripts/init-project.sh"
echo "  # Then in Claude Code: /upgrade-framework"
echo ""

# ─── Summary ──────────────────────────────────────────────────────────────────

ok "Framework updated: $CURRENT_COMMIT → $NEW_COMMIT"
echo ""
echo "  Agents : ~/.claude/agents/ ($AGENT_COUNT agents)"
echo "  Skills : ~/.claude/skills/"
echo "  Hooks  : ~/.claude/hooks/"
echo ""
