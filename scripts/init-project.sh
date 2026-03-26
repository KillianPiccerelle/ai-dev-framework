#!/usr/bin/env bash
set -e

# ai-dev-framework — init-project.sh
# Usage: ./init-project.sh [lang] [template]
# lang     : fr | en  (default: fr)
# template : saas | api-backend | fullstack-web  (default: saas)

LANG=${1:-"fr"}
TEMPLATE=${2:-"saas"}
FRAMEWORK_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="${PWD}"

GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; NC='\033[0m'
log()  { echo -e "${BLUE}[ai-dev-framework]${NC} $1"; }
ok()   { echo -e "${GREEN}[ok]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }

log "Init — lang: $LANG | template: $TEMPLATE | target: $TARGET_DIR"

# ─── Détection d'un projet existant ──────────────────────────────────────────
HAS_CLAUDE_MD=false
HAS_CLAUDE_DIR=false
HAS_MEMORY=false

[ -f "$TARGET_DIR/CLAUDE.md" ]  && HAS_CLAUDE_MD=true
[ -d "$TARGET_DIR/.claude" ]    && HAS_CLAUDE_DIR=true
[ -d "$TARGET_DIR/memory" ]     && HAS_MEMORY=true

if $HAS_CLAUDE_MD || $HAS_CLAUDE_DIR || $HAS_MEMORY; then
  if [ "$LANG" = "fr" ]; then
    warn "Configuration Claude détectée dans ce projet."
    warn "Mode mise à jour — aucun fichier existant ne sera écrasé."
    warn "Lance /analyze-project dans Claude Code pour une migration complète."
  else
    warn "Claude configuration detected in this project."
    warn "Update mode — no existing files will be overwritten."
    warn "Run /analyze-project in Claude Code for a full migration."
  fi
  echo ""
fi

# ─── Backup du CLAUDE.md si format ancien ─────────────────────────────────────
if $HAS_CLAUDE_MD; then
  # Détecter si c'est le format du framework (contient la section "Agents disponibles")
  if ! grep -q "Agents disponibles\|Available agents" "$TARGET_DIR/CLAUDE.md" 2>/dev/null; then
    warn "CLAUDE.md existant (format ancien) → sauvegardé en CLAUDE.backup.md"
    cp "$TARGET_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.backup.md"
    # Ajouter au .gitignore
    if [ -f "$TARGET_DIR/.gitignore" ] && ! grep -q "CLAUDE.backup.md" "$TARGET_DIR/.gitignore"; then
      echo "CLAUDE.backup.md" >> "$TARGET_DIR/.gitignore"
    fi
    ok "CLAUDE.backup.md créé"
    # On peut maintenant écrire le nouveau CLAUDE.md
    HAS_CLAUDE_MD=false
  else
    log "CLAUDE.md déjà au format du framework — conservé tel quel."
  fi
fi

# ─── Structure mémoire ────────────────────────────────────────────────────────
mkdir -p "$TARGET_DIR/memory/decisions" \
         "$TARGET_DIR/memory/conventions" \
         "$TARGET_DIR/memory/domain" \
         "$TARGET_DIR/.claude/commands"

# Copier les templates mémoire (uniquement les fichiers absents)
MEMORY_TEMPLATES=(
  "project-context.md"
  "stack.md"
  "architecture.md"
  "progress.md"
)
for f in "${MEMORY_TEMPLATES[@]}"; do
  DEST="$TARGET_DIR/memory/$f"
  SRC="$FRAMEWORK_DIR/memory/$LANG/$f"
  if [ ! -f "$DEST" ] && [ -f "$SRC" ]; then
    cp "$SRC" "$DEST"
    ok "memory/$f créé depuis le template"
  elif [ -f "$DEST" ]; then
    log "memory/$f conservé (existait déjà)"
  fi
done

# Conventions (uniquement les fichiers absents)
CONV_FILES=("naming.md" "error-handling.md" "commit-format.md")
for f in "${CONV_FILES[@]}"; do
  DEST="$TARGET_DIR/memory/conventions/$f"
  SRC="$FRAMEWORK_DIR/memory/$LANG/conventions/$f"
  if [ ! -f "$DEST" ] && [ -f "$SRC" ]; then
    cp "$SRC" "$DEST"
    ok "memory/conventions/$f créé depuis le template"
  elif [ -f "$DEST" ]; then
    log "memory/conventions/$f conservé (existait déjà)"
  fi
done

# ─── CLAUDE.md ────────────────────────────────────────────────────────────────
if ! $HAS_CLAUDE_MD; then
  TEMPLATE_CLAUDE="$FRAMEWORK_DIR/templates/$TEMPLATE/$LANG/CLAUDE.md"
  if [ -f "$TEMPLATE_CLAUDE" ]; then
    cp "$TEMPLATE_CLAUDE" "$TARGET_DIR/CLAUDE.md"
    ok "CLAUDE.md ($TEMPLATE/$LANG) appliqué"
  fi
fi

# ─── Workflows → .claude/commands/ ───────────────────────────────────────────
WORKFLOWS_DIR="$FRAMEWORK_DIR/workflows/$LANG"
if [ -d "$WORKFLOWS_DIR" ]; then
  for wf in "$WORKFLOWS_DIR"/*.md; do
    WF_NAME=$(basename "$wf")
    DEST="$TARGET_DIR/.claude/commands/$WF_NAME"
    if [ ! -f "$DEST" ]; then
      cp "$wf" "$DEST"
      ok "workflow $WF_NAME installé"
    else
      # Proposer la version du framework sans écraser
      cp "$wf" "$TARGET_DIR/.claude/commands/${WF_NAME%.md}.framework.md"
      log "workflow $WF_NAME existant conservé — version framework dans ${WF_NAME%.md}.framework.md"
    fi
  done
fi

# ─── Hooks ───────────────────────────────────────────────────────────────────
if [ ! -f "$TARGET_DIR/.claude/hooks.json" ] && \
   [ -f "$FRAMEWORK_DIR/hooks/hooks.json" ]; then
  cp "$FRAMEWORK_DIR/hooks/hooks.json" "$TARGET_DIR/.claude/hooks.json"
  ok "hooks.json installé"
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
  ok "settings.json créé"
fi

# ─── .gitignore ──────────────────────────────────────────────────────────────
if [ ! -f "$TARGET_DIR/.gitignore" ]; then
  cat > "$TARGET_DIR/.gitignore" << 'EOF'
# ai-dev-framework — mémoire locale (ne pas commiter les données sensibles)
memory/project-context.md
memory/stack.md
memory/architecture.md
memory/progress.md
memory/domain/
*.local.md
CLAUDE.backup.md

# Environnement
.env
.env.*
.env.local

# Dépendances
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
  ok ".gitignore créé"
else
  # Ajouter les entrées manquantes
  for entry in "CLAUDE.backup.md" "memory/architecture.md"; do
    if ! grep -q "$entry" "$TARGET_DIR/.gitignore"; then
      echo "$entry" >> "$TARGET_DIR/.gitignore"
      ok ".gitignore mis à jour — ajout de $entry"
    fi
  done
fi

# ─── Résumé ───────────────────────────────────────────────────────────────────
echo ""
ok "Initialisation terminée."
echo ""
if [ "$LANG" = "fr" ]; then
  echo "  Langue   : $LANG"
  echo "  Template : $TEMPLATE"
  echo ""
  echo "Prochaines étapes :"
  if $HAS_CLAUDE_MD || $HAS_CLAUDE_DIR || $HAS_MEMORY; then
    echo "  1. Lance : claude"
    echo "  2. Lance : /analyze-project  (migration complète)"
  else
    echo "  1. Complète memory/project-context.md avec ton contexte"
    echo "  2. Lance : claude"
    echo "  3. Lance : /new-project"
  fi
else
  echo "  Language : $LANG"
  echo "  Template : $TEMPLATE"
  echo ""
  echo "Next steps:"
  if $HAS_CLAUDE_MD || $HAS_CLAUDE_DIR || $HAS_MEMORY; then
    echo "  1. Run: claude"
    echo "  2. Run: /analyze-project  (full migration)"
  else
    echo "  1. Fill in memory/project-context.md"
    echo "  2. Run: claude"
    echo "  3. Run: /new-project"
  fi
fi
