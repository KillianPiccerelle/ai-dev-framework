#!/usr/bin/env bash
# set -e  # Disabled - doctor should always complete

# ai-dev-framework v3 — Health check and diagnostics
# Usage: ./scripts/doctor.sh
# Or via the global command: ai-framework doctor

FRAMEWORK_DIR="$(cd "$(dirname "$(dirname "$0")")" && pwd)"
AGENTS_SRC="$FRAMEWORK_DIR/agents"
SKILLS_SRC="$FRAMEWORK_DIR/skills"
HOOKS_SRC="$FRAMEWORK_DIR/hooks"

AGENTS_DEST="$HOME/.claude/agents"
SKILLS_DEST="$HOME/.claude/skills"
HOOKS_DEST="$HOME/.claude/hooks"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log()    { echo -e "${BLUE}[ai-dev-framework]${NC} $1"; }
ok()     { echo -e "${GREEN}[ok]${NC} $1"; }
warn()   { echo -e "${YELLOW}[warn]${NC} $1"; }
error()  { echo -e "${RED}[error]${NC} $1"; }
check()  { echo -e "  ${BLUE}→${NC} $1"; }

# Counters
PASS=0
WARN=0
FAIL=0

increment_pass() { ((PASS++)) || true; }
increment_warn() { ((WARN++)) || true; }
increment_fail() { ((FAIL++)) || true; }

print_summary() {
    echo ""
    echo "=== Summary ==="
    echo "Pass: $PASS  Warn: $WARN  Fail: $FAIL"

    if [ $FAIL -gt 0 ]; then
        error "Installation has issues that need attention"
        # Don't return error code - doctor should complete even with issues
    elif [ $WARN -gt 0 ]; then
        warn "Installation has warnings"
    else
        ok "Installation is healthy"
    fi
}

check_ai_framework_command() {
    check "Checking ai-framework command..."

    if ! command -v ai-framework >/dev/null 2>&1; then
        error "ai-framework command not found in PATH"
        echo "  Make sure ~/.local/bin is in your PATH"
        echo "  Or run: export PATH=\"\$HOME/.local/bin:\$PATH\""
        increment_fail
        return 0
    fi

    # Test basic functionality
    if ! ai-framework version >/dev/null 2>&1; then
        error "ai-framework command fails to execute"
        increment_fail
        return 0
    fi

    ok "ai-framework command works"
    increment_pass
}

check_path() {
    check "Checking PATH configuration..."

    if echo "$PATH" | grep -q "$HOME/.local/bin"; then
        ok "~/.local/bin is in PATH"
        increment_pass
    else
        warn "~/.local/bin is NOT in PATH"
        echo "  Add to your shell config:"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        increment_warn
    fi
}

check_agents() {
    check "Checking agents installation..."

    if [ ! -d "$AGENTS_DEST" ]; then
        error "Agents directory not found: $AGENTS_DEST"
        echo "  Run: ai-framework install"
        increment_fail
        return 0
    fi

    local src_count=$(find "$AGENTS_SRC" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')

    # Count only framework agents (exclude system agents like claude-code-guide, statusline-setup)
    local framework_agents=(
        "orchestrator" "architect" "stack-advisor" "project-analyzer" "codebase-analyst"
        "backend-dev" "frontend-dev" "debug" "test-engineer" "qa-engineer"
        "code-reviewer" "doc-writer" "verifier" "security-reviewer" "devops-engineer"
    )

    local dest_framework_count=0
    for agent in "${framework_agents[@]}"; do
        if [ -f "$AGENTS_DEST/$agent.md" ]; then
            ((dest_framework_count++))
        fi
    done

    if [ "$dest_framework_count" -eq "$src_count" ]; then
        ok "All $src_count framework agents installed"
        increment_pass
    elif [ "$dest_framework_count" -eq 0 ]; then
        error "No framework agents installed"
        echo "  Run: ai-framework install"
        increment_fail
    elif [ "$dest_framework_count" -lt "$src_count" ]; then
        warn "Only $dest_framework_count/$src_count framework agents installed"
        echo "  Run: ai-framework update"
        increment_warn
    else
        # This shouldn't happen since we're counting only framework agents
        warn "Agent count mismatch ($dest_framework_count/$src_count)"
        echo "  Run: ai-framework update"
        increment_warn
    fi

    # Check for system agents
    local total_dest_count=$(find "$AGENTS_DEST" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    if [ "$total_dest_count" -gt "$dest_framework_count" ]; then
        local system_count=$((total_dest_count - dest_framework_count))
        echo "  Note: $system_count system agents also present (claude-code-guide, statusline-setup, etc.)"
    fi
}

check_skills() {
    check "Checking skills installation..."

    if [ ! -d "$SKILLS_DEST" ]; then
        error "Skills directory not found: $SKILLS_DEST"
        echo "  Run: ai-framework install"
        increment_fail
        return 0
    fi

    # Count skills by directory structure
    local src_count=0
    local dest_count=0

    if [ -d "$SKILLS_SRC" ]; then
        src_count=$(find "$SKILLS_SRC" -maxdepth 2 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    fi

    if [ -d "$SKILLS_DEST" ]; then
        dest_count=$(find "$SKILLS_DEST" -maxdepth 2 -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    fi

    if [ "$src_count" -eq 0 ]; then
        warn "No skills found in source directory"
        increment_warn
    elif [ "$dest_count" -ge "$src_count" ]; then
        ok "Skills installed ($dest_count found)"
        increment_pass
    else
        warn "Skills may be incomplete ($dest_count/$src_count)"
        echo "  Run: ai-framework update"
        increment_warn
    fi
}

check_hooks() {
    check "Checking hooks installation..."

    if [ ! -f "$HOOKS_DEST/hooks.json" ]; then
        warn "hooks.json not found in $HOOKS_DEST"
        echo "  Run: ai-framework install"
        increment_warn
        return 0
    fi

    # Check if hooks directory exists in source
    if [ ! -f "$HOOKS_SRC/hooks.json" ]; then
        warn "No hooks.json in source directory"
        increment_warn
        return 0
    fi

    # Compare hook count (rough check)
    local src_hooks=0
    local dest_hooks=0

    if [ -f "$HOOKS_SRC/hooks.json" ]; then
        src_hooks=$(grep '"script"' "$HOOKS_SRC/hooks.json" 2>/dev/null | wc -l | tr -d ' ' || echo "0")
    fi

    if [ -f "$HOOKS_DEST/hooks.json" ]; then
        dest_hooks=$(grep '"script"' "$HOOKS_DEST/hooks.json" 2>/dev/null | wc -l | tr -d ' ' || echo "0")
    fi

    if [ "$src_hooks" -eq "$dest_hooks" ]; then
        ok "Hooks configuration installed ($src_hooks hooks)"
        increment_pass
    else
        warn "Hooks may be outdated ($dest_hooks/$src_hooks hooks)"
        echo "  Run: ai-framework update"
        increment_warn
    fi

    # Check hook scripts
    if [ -d "$HOOKS_SRC/scripts" ]; then
        local src_scripts=$(find "$HOOKS_SRC/scripts" -name "*.js" 2>/dev/null | wc -l | tr -d ' ')
        local dest_scripts=$(find "$HOOKS_DEST/scripts" -name "*.js" 2>/dev/null | wc -l | tr -d ' ')

        if [ "$src_scripts" -eq "$dest_scripts" ] && [ "$src_scripts" -gt 0 ]; then
            ok "Hook scripts installed ($src_scripts scripts)"
            increment_pass
        elif [ "$dest_scripts" -eq 0 ] && [ "$src_scripts" -gt 0 ]; then
            warn "No hook scripts installed (expected $src_scripts)"
            echo "  Run: ai-framework install"
            increment_warn
        fi
    fi
}

check_script_permissions() {
    check "Checking script permissions..."

    local scripts=(
        "$FRAMEWORK_DIR/scripts/install.sh"
        "$FRAMEWORK_DIR/scripts/update.sh"
        "$FRAMEWORK_DIR/scripts/init-project.sh"
        "$FRAMEWORK_DIR/scripts/version.sh"
        "$FRAMEWORK_DIR/scripts/doctor.sh"
    )

    local python_scripts=(
        "$FRAMEWORK_DIR/scripts/generate-status-report.py"
        "$FRAMEWORK_DIR/scripts/status-history.py"
    )

    local all_ok=true

    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            if [ -x "$script" ]; then
                : # OK
            else
                error "Script not executable: $(basename "$script")"
                echo "  Run: chmod +x $script"
                all_ok=false
            fi
        fi
    done

    for script in "${python_scripts[@]}"; do
        if [ -f "$script" ]; then
            if [ -x "$script" ]; then
                : # OK
            else
                warn "Python script not executable: $(basename "$script")"
                echo "  Run: chmod +x $script"
                all_ok=false
            fi
        fi
    done

    if $all_ok; then
        ok "All scripts are executable"
        increment_pass
    else
        increment_fail
    fi
}

check_python() {
    check "Checking Python installation..."

    if command -v python3 >/dev/null 2>&1; then
        local version=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
        local major=$(python3 -c "import sys; print(sys.version_info.major)")
        local minor=$(python3 -c "import sys; print(sys.version_info.minor)")

        if [ "$major" -ge 3 ] && [ "$minor" -ge 8 ]; then
            ok "Python $version detected (≥3.8 required)"
            increment_pass
        else
            error "Python $version detected (need ≥3.8)"
            echo "  Please upgrade Python to version 3.8 or higher"
            increment_fail
        fi
    else
        error "Python 3 not found"
        echo "  Required for: generate-status-report.py, status-history.py"
        echo "  Install Python 3.8+ from https://python.org"
        increment_fail
    fi
}

check_git_status() {
    check "Checking framework git status..."

    if [ ! -d "$FRAMEWORK_DIR/.git" ]; then
        warn "Framework directory is not a git repository"
        increment_warn
        return 0  # Not fatal
    fi

    cd "$FRAMEWORK_DIR"

    # Check if up to date with remote (non-fatal if fails)
    if git fetch origin main --quiet 2>/dev/null; then
        local local_commit=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
        local remote_commit=$(git rev-parse --short origin/main 2>/dev/null || echo "unknown")

        if [ "$local_commit" = "$remote_commit" ]; then
            ok "Framework is up to date ($local_commit)"
            increment_pass
        else
            warn "Framework is outdated ($local_commit → $remote_commit)"
            echo "  Run: ai-framework update"
            increment_warn
        fi
    else
        warn "Could not check remote repository (no network or no access)"
        increment_warn
    fi

    # Check for uncommitted changes
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        warn "Framework has uncommitted changes"
        echo "  Consider: git add . && git commit -m '...'"
        increment_warn
    fi

    cd - >/dev/null 2>&1
}

check_version_file() {
    check "Checking version file..."

    if [ -f "$FRAMEWORK_DIR/VERSION" ]; then
        local version=$(cat "$FRAMEWORK_DIR/VERSION" 2>/dev/null | head -1 | tr -d '[:space:]')
        if [ -n "$version" ]; then
            ok "Version file: $version"
            increment_pass
        else
            warn "Version file is empty"
            increment_warn
        fi
    else
        warn "VERSION file not found"
        increment_warn
    fi
}

check_framework_files() {
    check "Checking framework file structure..."

    local issues=0

    # Check all agents have required frontmatter fields
    for agent_file in "$FRAMEWORK_DIR/agents/"*.md; do
        [ -f "$agent_file" ] || continue
        local agent_name=$(basename "$agent_file")

        if ! grep -q "^name:" "$agent_file"; then
            warn "Agent $agent_name missing 'name:' field"
            issues=$((issues + 1))
        fi
        if ! grep -q "^description:" "$agent_file"; then
            warn "Agent $agent_name missing 'description:' field"
            issues=$((issues + 1))
        fi
        if ! grep -q "^tools:" "$agent_file"; then
            warn "Agent $agent_name missing 'tools:' field"
            issues=$((issues + 1))
        fi
    done

    # Check all workflows have Memory update section
    for wf_file in "$FRAMEWORK_DIR/workflows/"*.md; do
        [ -f "$wf_file" ] || continue
        local wf_name=$(basename "$wf_file")

        if ! grep -qi "memory update" "$wf_file"; then
            warn "Workflow $wf_name missing 'Memory update' section"
            issues=$((issues + 1))
        fi
    done

    # Check all skills have SKILL.md
    for skill_dir in "$FRAMEWORK_DIR/skills/"*/; do
        [ -d "$skill_dir" ] || continue
        local skill_name=$(basename "$skill_dir")

        if [ ! -f "$skill_dir/SKILL.md" ]; then
            warn "Skill $skill_name missing SKILL.md"
            issues=$((issues + 1))
        elif ! grep -q "^name:" "$skill_dir/SKILL.md"; then
            warn "Skill $skill_name/SKILL.md missing 'name:' field"
            issues=$((issues + 1))
        fi
    done

    if [ $issues -eq 0 ]; then
        ok "All framework files valid (agents, workflows, skills)"
        increment_pass
    elif [ $issues -le 3 ]; then
        warn "$issues minor file issues found (see above)"
        increment_warn
    else
        error "$issues file issues found — run 'ai-framework list' to inspect"
        increment_fail
    fi
}

main() {
    echo ""
    log "ai-dev-framework v3 — Health Check"
    echo "======================================"
    echo ""

    # Run all checks
    check_ai_framework_command
    check_path
    check_agents
    check_skills
    check_hooks
    check_script_permissions
    check_python
    check_git_status
    check_version_file
    check_framework_files

    # Summary
    print_summary

    # Recommendations
    if [ $FAIL -gt 0 ] || [ $WARN -gt 0 ]; then
        echo ""
        echo "=== Recommendations ==="
        if [ $FAIL -gt 0 ]; then
            echo "1. Fix all [error] issues above"
        fi
        if grep -q "agents installed" <<<"$FAIL$WARN"; then
            echo "2. Run: ai-framework install"
        fi
        if grep -q "outdated\|incomplete" <<<"$FAIL$WARN"; then
            echo "3. Run: ai-framework update"
        fi
        if grep -q "PATH" <<<"$FAIL$WARN"; then
            echo "4. Add to ~/.bashrc or ~/.zshrc:"
            echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
        fi
    fi

    echo ""
}

main "$@"