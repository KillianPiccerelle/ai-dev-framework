#!/usr/bin/env bash

# ai-dev-framework — Shell completion setup helper
# Usage: ./scripts/completion-setup.sh [shell]

FRAMEWORK_DIR="$(cd "$(dirname "$(dirname "$0")")" && pwd)"
COMPLETION_DIR="$HOME/.config/ai-framework/completions"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${BLUE}[completion]${NC} $1"; }
ok()   { echo -e "${GREEN}[ok]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }

detect_shell() {
    local shell="$1"
    if [ -z "$shell" ]; then
        shell=$(basename "$SHELL" 2>/dev/null || echo "unknown")
    fi
    echo "$shell"
}

setup_bash_completion() {
    log "Setting up bash completion..."

    # Create completion directory
    mkdir -p "$COMPLETION_DIR"

    # Copy completion script
    cp "$FRAMEWORK_DIR/scripts/completion.bash" "$COMPLETION_DIR/"

    # Source for current session
    if [ -f "$COMPLETION_DIR/completion.bash" ]; then
        source "$COMPLETION_DIR/completion.bash" 2>/dev/null && \
            ok "Bash completion loaded for current session"
    else
        warn "Completion script not found"
        return 1
    fi

    # Add to bashrc for future sessions
    local bashrc="$HOME/.bashrc"
    if [ -f "$bashrc" ]; then
        if ! grep -q "ai-framework completion" "$bashrc" 2>/dev/null; then
            echo '' >> "$bashrc"
            echo '# ai-dev-framework bash completion' >> "$bashrc"
            echo 'if [ -f ~/.config/ai-framework/completions/completion.bash ]; then' >> "$bashrc"
            echo '    source ~/.config/ai-framework/completions/completion.bash' >> "$bashrc"
            echo 'fi' >> "$bashrc"
            ok "Bash completion added to $bashrc"
        else
            ok "Bash completion already configured in $bashrc"
        fi
    else
        warn "No .bashrc found at $bashrc"
    fi

    echo ""
    echo "Bash completion installed."
    echo "To test, open a new terminal or run:"
    echo "  source ~/.bashrc"
    echo ""
    echo "Then try: ai-framework <TAB>"
}

setup_zsh_completion() {
    log "Setting up zsh completion..."

    # Create completion directories
    mkdir -p "$COMPLETION_DIR"
    mkdir -p ~/.zsh/completions

    # Copy completion script
    cp "$FRAMEWORK_DIR/scripts/completion.zsh" "$COMPLETION_DIR/"
    cp "$COMPLETION_DIR/completion.zsh" ~/.zsh/completions/_ai-framework

    # Add to .zshrc for future sessions
    local zshrc="$HOME/.zshrc"
    if [ -f "$zshrc" ]; then
        # Check if fpath already contains our completions
        local fpath_configured=false
        local compinit_configured=false

        if grep -q "~/.zsh/completions" "$zshrc" 2>/dev/null; then
            fpath_configured=true
        fi

        if grep -q "compinit" "$zshrc" 2>/dev/null; then
            compinit_configured=true
        fi

        if ! $fpath_configured; then
            echo '' >> "$zshrc"
            echo '# ai-dev-framework zsh completion' >> "$zshrc"
            echo 'fpath=(~/.zsh/completions $fpath)' >> "$zshrc"
            ok "fpath configured in $zshrc"
        fi

        if ! $compinit_configured; then
            echo 'autoload -Uz compinit && compinit' >> "$zshrc"
            ok "compinit configured in $zshrc"
        fi

        if $fpath_configured && $compinit_configured; then
            ok "Zsh completion already configured in $zshrc"
        fi
    else
        warn "No .zshrc found at $zshrc"
        echo "Create ~/.zshrc and add:"
        echo "  fpath=(~/.zsh/completions \$fpath)"
        echo "  autoload -Uz compinit && compinit"
    fi

    # Load for current session
    fpath=(~/.zsh/completions $fpath)
    autoload -Uz compinit
    if compinit 2>/dev/null; then
        ok "Zsh completion loaded for current session"
    else
        warn "Could not run compinit. You may need to restart your shell."
    fi

    echo ""
    echo "Zsh completion installed."
    echo "To test, open a new terminal or run:"
    echo "  exec zsh"
    echo ""
    echo "Then try: ai-framework <TAB>"
}

show_manual_instructions() {
    local shell="$1"

    echo ""
    echo "=== Manual Setup Instructions ==="
    echo ""

    case "$shell" in
        bash)
            echo "For bash:"
            echo "1. Source the completion script:"
            echo "   source $COMPLETION_DIR/completion.bash"
            echo ""
            echo "2. Add to ~/.bashrc for persistence:"
            echo "   echo 'source $COMPLETION_DIR/completion.bash' >> ~/.bashrc"
            ;;
        zsh)
            echo "For zsh:"
            echo "1. Copy completion script:"
            echo "   mkdir -p ~/.zsh/completions"
            echo "   cp $COMPLETION_DIR/completion.zsh ~/.zsh/completions/_ai-framework"
            echo ""
            echo "2. Add to ~/.zshrc:"
            echo "   echo 'fpath=(~/.zsh/completions \$fpath)' >> ~/.zshrc"
            echo "   echo 'autoload -Uz compinit && compinit' >> ~/.zshrc"
            echo ""
            echo "3. Reload zsh:"
            echo "   exec zsh"
            ;;
        *)
            echo "For bash:"
            echo "  source $COMPLETION_DIR/completion.bash"
            echo ""
            echo "For zsh:"
            echo "  cp $COMPLETION_DIR/completion.zsh ~/.zsh/completions/_ai-framework"
            echo "  Add to ~/.zshrc:"
            echo "    fpath=(~/.zsh/completions \$fpath)"
            echo "    autoload -Uz compinit && compinit"
            ;;
    esac
}

check_completion() {
    log "Checking completion status..."

    local shell=$(detect_shell "$1")

    echo "Detected shell: $shell"
    echo "Completion directory: $COMPLETION_DIR"

    if [ -d "$COMPLETION_DIR" ]; then
        ok "Completion scripts directory exists"
        ls -la "$COMPLETION_DIR/"
    else
        warn "Completion directory not found"
    fi

    echo ""
    echo "To test completion:"
    echo "1. Type: ai-framework "
    echo "2. Press TAB"
    echo "3. You should see: init update install version doctor list"
}

main() {
    local action="${1:-auto}"
    local shell="${2:-}"

    echo ""
    log "ai-dev-framework — Shell Completion Setup"
    echo "=========================================="
    echo ""

    case "$action" in
        auto|setup)
            shell=$(detect_shell "$shell")
            case "$shell" in
                bash)
                    setup_bash_completion
                    ;;
                zsh)
                    setup_zsh_completion
                    ;;
                *)
                    warn "Unsupported shell: $shell"
                    echo "Supported shells: bash, zsh"
                    show_manual_instructions "$shell"
                    ;;
            esac
            ;;
        check|status)
            check_completion "$shell"
            ;;
        help|--help|-h)
            echo "Usage: $0 [command] [shell]"
            echo ""
            echo "Commands:"
            echo "  auto|setup    Setup completion automatically (default)"
            echo "  check|status  Check completion status"
            echo "  help          Show this help"
            echo ""
            echo "Shells:"
            echo "  bash          Setup for bash"
            echo "  zsh           Setup for zsh"
            echo "  (auto)        Auto-detect from \$SHELL"
            echo ""
            echo "Examples:"
            echo "  $0 setup       # Auto-detect and setup"
            echo "  $0 setup bash  # Setup for bash"
            echo "  $0 check       # Check current setup"
            ;;
        *)
            warn "Unknown action: $action"
            echo "Use: $0 help"
            exit 1
            ;;
    esac
}

main "$@"