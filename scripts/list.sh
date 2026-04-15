#!/usr/bin/env bash

# ai-dev-framework v3 — List available resources
# Usage: ./scripts/list.sh
# Or via the global command: ai-framework list

FRAMEWORK_DIR="$(cd "$(dirname "$(dirname "$0")")" && pwd)"
AGENTS_DIR="$HOME/.claude/agents"
WORKFLOWS_DIR="$FRAMEWORK_DIR/workflows"
SKILLS_DIR="$HOME/.claude/skills"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log()    { echo -e "${BLUE}[ai-dev-framework]${NC} $1"; }
info()   { echo -e "  ${BLUE}•${NC} $1"; }
item()   { echo -e "    ${GREEN}→${NC} $1"; }
subitem(){ echo -e "      ${YELLOW}-${NC} $1"; }

print_section() {
    echo ""
    echo "== $1 =="
    echo ""
}

list_agents() {
    print_section "Agents"

    local framework_agents=(
        "orchestrator" "architect" "stack-advisor" "project-analyzer" "codebase-analyst"
        "backend-dev" "frontend-dev" "debug" "test-engineer" "qa-engineer"
        "code-reviewer" "doc-writer" "verifier" "security-reviewer" "devops-engineer"
    )

    local system_agents=(
        "claude-code-guide" "statusline-setup" "general-purpose"
        "doc-generator" "test-writer"
    )

    info "Framework agents (15):"
    for agent in "${framework_agents[@]}"; do
        if [ -f "$AGENTS_DIR/$agent.md" ]; then
            item "$agent"
        else
            item "$agent ${YELLOW}(not installed)${NC}"
        fi
    done

    echo ""
    info "System agents (optional):"
    local system_count=0
    for agent in "${system_agents[@]}"; do
        if [ -f "$AGENTS_DIR/$agent.md" ]; then
            subitem "$agent"
            ((system_count++))
        fi
    done

    if [ $system_count -eq 0 ]; then
        subitem "No additional system agents installed"
    fi

    # Count total
    local total_agents=$(find "$AGENTS_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo ""
    echo "  Total installed: $total_agents agents"
}

list_workflows() {
    print_section "Workflows"

    local workflows=(
        "new-project" "analyze-project" "map-project" "add-feature"
        "debug-issue" "refactor" "gen-tests" "project-status"
        "upgrade-framework" "security-audit" "setup-ci" "onboard"
        "dependency-update" "perf-audit" "accessibility-audit"
    )

    info "Available workflows (15):"

    for workflow in "${workflows[@]}"; do
        local description=""

        case $workflow in
            "new-project") description="Scoping, stack choice, architecture design" ;;
            "analyze-project") description="Analyze existing codebase, generate memory/" ;;
            "map-project") description="Full codebase cartography" ;;
            "add-feature") description="Full TDD cycle with all agents" ;;
            "debug-issue") description="Root cause investigation and fix" ;;
            "refactor") description="Safe incremental refactoring" ;;
            "gen-tests") description="Test coverage audit and generation" ;;
            "project-status") description="Health report with timestamped history" ;;
            "upgrade-framework") description="Non-destructive migration" ;;
            "security-audit") description="Full security audit with report" ;;
            "setup-ci") description="CI/CD pipeline generation" ;;
            "onboard") description="Generate onboarding documentation" ;;
            "dependency-update") description="Securely updates dependencies with testing and safety checks" ;;
            "perf-audit") description="Analyzes application performance metrics and provides optimization recommendations" ;;
            "accessibility-audit") description="WCAG accessibility audit for web applications with compliance checking" ;;
        esac

        if [ -f "$WORKFLOWS_DIR/$workflow.md" ]; then
            item "/$workflow — $description"
        else
            item "/$workflow ${YELLOW}(not in source)${NC}"
        fi
    done

    echo ""
    echo "  Invoke from Claude Code with: /workflow-name"
}

list_skills() {
    print_section "Skills"

    info "Framework skills:"

    # Try to read from skills directory structure
    if [ -d "$SKILLS_DIR" ]; then
        # List top-level skills
        local skills=()

        # Check for common skills
        local common_skills=(
            "stack-advisor" "jwt-auth" "rest-crud" "schema-design" "tdd-workflow"
            "docker-setup" "env-setup" "api-docs" "oh-my-mermaid" "code-review-graph"
            "mcp-github" "mcp-jira" "mcp-notion" "mcp-sync"
            "repomix" "ui-design" "i18n-check"
        )

        for skill in "${common_skills[@]}"; do
            # Check if skill exists (could be a directory or file)
            if [ -d "$SKILLS_DIR/$skill" ] || [ -f "$SKILLS_DIR/$skill.md" ] || \
               [ -f "$SKILLS_DIR/${skill}.md" ] || find "$SKILLS_DIR" -name "*$skill*" -type f 2>/dev/null | grep -q .; then
                item "/$skill"
                skills+=("$skill")
            fi
        done

        # List additional skills found
        local additional_count=0
        echo ""
        info "Additional skills found:"

        # Find all .md files in skills directory
        local skill_files=$(find "$SKILLS_DIR" -name "*.md" -type f 2>/dev/null | head -20)

        if [ -n "$skill_files" ]; then
            while IFS= read -r file; do
                local basename=$(basename "$file" .md)
                # Try to get skill name from directory name if file is SKILL.md
                local skill_name="$basename"
                if [ "$basename" = "SKILL" ]; then
                    # Get parent directory name
                    local parent_dir=$(basename $(dirname "$file"))
                    skill_name="$parent_dir"
                fi
                # Skip if already listed
                if [[ ! " ${skills[@]} " =~ " ${skill_name} " ]]; then
                    subitem "/$skill_name"
                    ((additional_count++))
                fi
            done <<< "$skill_files"
        fi

        if [ $additional_count -eq 0 ]; then
            subitem "No additional skills found"
        fi

        local total_skills=$((${#skills[@]} + additional_count))
        echo ""
        echo "  Total skills: $total_skills"
    else
        echo "  Skills directory not found: $SKILLS_DIR"
        echo "  Run: ai-framework install"
    fi
}

list_plugins() {
    print_section "Plugins & Integrations"

    info "Installed plugins:"

    # Check for oh-my-mermaid
    if [ -d "$HOME/.claude/plugins/oh-my-mermaid" ] || \
       command -v omm-scan >/dev/null 2>&1 || \
       find "$SKILLS_DIR" -name "*mermaid*" -type f 2>/dev/null | grep -q .; then
        item "oh-my-mermaid"
        subitem "Skills: /omm-scan, /omm-view, /omm-push"
        subitem "Architecture diagram generation"
    else
        item "oh-my-mermaid ${YELLOW}(not installed)${NC}"
    fi

    # Check for code-review-graph
    if command -v code-review-graph >/dev/null 2>&1 || \
       find "$SKILLS_DIR" -name "*code-review-graph*" -type f 2>/dev/null | grep -q .; then
        item "code-review-graph"
        subitem "Skills: /code-review-graph"
        subitem "Structural impact analysis"
    else
        item "code-review-graph ${YELLOW}(not installed)${NC}"
    fi

    # Check for research plugin
    if find "$SKILLS_DIR" -name "*research*" -type f 2>/dev/null | grep -q .; then
        item "research"
        subitem "Skills: /research:last30days"
        subitem "Multi-source research across web/social"
    fi

    echo ""
    info "External tools:"
    if command -v python3 >/dev/null 2>&1; then
        local pyversion=$(python3 --version 2>/dev/null | cut -d' ' -f2)
        subitem "Python $pyversion (required for status reports)"
    else
        subitem "Python ${YELLOW}(not found)${NC} - required for some features"
    fi

    if command -v git >/dev/null 2>&1; then
        subitem "Git $(git --version | cut -d' ' -f3)"
    else
        subitem "Git ${YELLOW}(not found)${NC}"
    fi
}

list_commands() {
    print_section "Global Commands"

    info "Available commands:"
    item "ai-framework init [template]"
    subitem "Initialize framework in current project"

    item "ai-framework update"
    subitem "Update framework to latest version"

    item "ai-framework install"
    subitem "Re-run global installation"

    item "ai-framework version"
    subitem "Show version and check for updates"

    item "ai-framework version check"
    subitem "Silent check for CI/CD"

    item "ai-framework doctor"
    subitem "Run health check and diagnostics"

    item "ai-framework list"
    subitem "This command - list all resources"

    echo ""
    echo "  Templates: saas, api-backend, fullstack-web, ai-app,"
    echo "             mobile-backend, cli-tool, data-pipeline, monorepo"
    echo "  Example: ai-framework init saas"
}

print_summary() {
    echo ""
    echo "=== Summary ==="
    echo ""

    # Count agents
    local total_agents=$(find "$AGENTS_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    echo "Agents:      $total_agents total"
    echo "             15 framework agents"
    echo "             $((total_agents - 15)) system/optional agents"

    # Count workflows (15 in source framework)
    echo "Workflows:   15 available (/workflow-name)"

    # Count skills
    local total_skills=0
    if [ -d "$SKILLS_DIR" ]; then
        total_skills=$(find "$SKILLS_DIR" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')
    fi
    echo "Skills:      $total_skills available (/skill-name)"

    # Version
    if [ -f "$FRAMEWORK_DIR/VERSION" ]; then
        local version=$(cat "$FRAMEWORK_DIR/VERSION" 2>/dev/null | head -1 | tr -d '[:space:]')
        echo "Version:     $version"
    fi

    echo ""
    echo "Next steps:"
    echo "  1. Run ${GREEN}ai-framework doctor${NC} to check installation health"
    echo "  2. Run ${GREEN}ai-framework init${NC} in your project directory"
    echo "  3. Open Claude Code and try ${GREEN}/analyze-project${NC}"
    echo ""
}

main() {
    echo ""
    log "ai-dev-framework v3 — Available Resources"
    echo "============================================"
    echo ""

    list_agents
    list_workflows
    list_skills
    list_plugins
    list_commands
    print_summary
}

main "$@"