#!/usr/bin/env bash
set -e

# ─── Configuration ────────────────────────────────────────────────────────────
GITHUB_USER="KillianPiccerelle"
SOURCE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPO_FR="ai-dev-framework-fr"
REPO_EN="ai-dev-framework-en"
TMP_DIR="/tmp/ai-dev-framework-publish"

# ─── Couleurs ─────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${BLUE}[publish]${NC} $1"; }
ok()   { echo -e "${GREEN}[ok]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }

# ─── Fonctions ────────────────────────────────────────────────────────────────

build_lang() {
  local LANG=$1
  local REPO=$2
  local DEST="$TMP_DIR/$REPO"

  log "Construction de la version $LANG dans $DEST..."
  rm -rf "$DEST"
  mkdir -p "$DEST"

  # Copier les fichiers spécifiques à la langue
  for dir in agents skills workflows memory prompts docs; do
    if [ -d "$SOURCE_DIR/$dir/$LANG" ]; then
      cp -r "$SOURCE_DIR/$dir/$LANG/." "$DEST/$dir/"
    fi
  done

  # Copier les fichiers neutres (hooks, templates, scripts d'install)
  cp -r "$SOURCE_DIR/hooks"     "$DEST/hooks"
  cp -r "$SOURCE_DIR/templates" "$DEST/templates"
  cp    "$SOURCE_DIR/scripts/init-project.sh" "$DEST/install.sh"
  chmod +x "$DEST/install.sh"

  # Copier le README et CLAUDE.md spécifiques à la langue
  if [ -f "$SOURCE_DIR/docs/$LANG/README-public.md" ]; then
    cp "$SOURCE_DIR/docs/$LANG/README-public.md" "$DEST/README.md"
  fi
  if [ -f "$SOURCE_DIR/docs/$LANG/CLAUDE-template.md" ]; then
    cp "$SOURCE_DIR/docs/$LANG/CLAUDE-template.md" "$DEST/CLAUDE.md"
  fi

  # .gitignore
  cat > "$DEST/.gitignore" << 'EOF'
memory/project-context.md
memory/stack.md
memory/progress.md
memory/decisions/
memory/domain/
*.local.md
.env
.env.*
EOF

  ok "Version $LANG construite."
}

push_lang() {
  local LANG=$1
  local REPO=$2
  local DEST="$TMP_DIR/$REPO"

  log "Push vers github.com/$GITHUB_USER/$REPO..."

  cd "$DEST"

  if [ ! -d ".git" ]; then
    git init
    git remote add origin "https://github.com/$GITHUB_USER/$REPO.git"
  fi

  git add -A
  git commit -m "chore: publish from source — $(date '+%Y-%m-%d %H:%M')" || warn "Rien à commiter pour $REPO"
  git branch -M main
  git push -u origin main --force

  ok "Repo $REPO mis à jour."
}

# ─── Main ─────────────────────────────────────────────────────────────────────

TARGET=${1:-"both"}
mkdir -p "$TMP_DIR"

case "$TARGET" in
  fr)
    build_lang "fr" "$REPO_FR"
    push_lang  "fr" "$REPO_FR"
    ;;
  en)
    build_lang "en" "$REPO_EN"
    push_lang  "en" "$REPO_EN"
    ;;
  both|"")
    build_lang "fr" "$REPO_FR"
    build_lang "en" "$REPO_EN"
    push_lang  "fr" "$REPO_FR"
    push_lang  "en" "$REPO_EN"
    ;;
  *)
    echo "Usage: ./scripts/publish.sh [fr|en|both]"
    exit 1
    ;;
esac

ok "Publication terminée."
echo ""
echo "  FR : https://github.com/$GITHUB_USER/$REPO_FR"
echo "  EN : https://github.com/$GITHUB_USER/$REPO_EN"
