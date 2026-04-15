#!/usr/bin/env bash
set -e

# ai-dev-framework v3 — Version management
# Usage: ./scripts/version.sh
# Or via the global command: ai-framework version

FRAMEWORK_DIR="$(cd "$(dirname "$(dirname "$0")")" && pwd)"
VERSION_FILE="$FRAMEWORK_DIR/VERSION"
REPO_URL="https://github.com/KillianPiccerelle/ai-dev-framework"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log()  { echo -e "${BLUE}[ai-dev-framework]${NC} $1"; }
ok()   { echo -e "${GREEN}[ok]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }
error() { echo -e "${RED}[error]${NC} $1"; }

# Get current installed version
get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE" 2>/dev/null | head -1 | tr -d '[:space:]'
    else
        # Fallback to git tag or default
        if command -v git >/dev/null 2>&1 && [ -d "$FRAMEWORK_DIR/.git" ]; then
            git -C "$FRAMEWORK_DIR" describe --tags --abbrev=0 2>/dev/null || echo "v3.0.0"
        else
            echo "v3.0.0"
        fi
    fi
}

# Get latest version from GitHub releases
get_latest_version() {
    local latest=""

    # Try to fetch from GitHub API
    if command -v curl >/dev/null 2>&1; then
        latest=$(curl -s -H "Accept: application/vnd.github.v3+json" \
            "https://api.github.com/repos/KillianPiccerelle/ai-dev-framework/releases/latest" \
            2>/dev/null | grep '"tag_name"' | cut -d'"' -f4 | tr -d '[:space:]')

        if [ -n "$latest" ] && [ "$latest" != "null" ]; then
            echo "$latest"
            return 0
        fi
    fi

    # Fallback: try git ls-remote
    if command -v git >/dev/null 2>&1; then
        latest=$(git ls-remote --tags "$REPO_URL" 2>/dev/null | grep -o 'refs/tags/v[0-9]*\.[0-9]*\.[0-9]*' | sort -V | tail -1 | sed 's|refs/tags/||' | tr -d '[:space:]')
        if [ -n "$latest" ]; then
            echo "$latest"
            return 0
        fi
    fi

    # Ultimate fallback
    return 1
}

# Compare two version strings (semver)
# Returns: 0 if versions are equal, 1 if first > second, 2 if first < second
compare_versions() {
    local v1=$1
    local v2=$2

    # Remove 'v' prefix if present
    v1=${v1#v}
    v2=${v2#v}

    # Split into arrays
    IFS='.' read -r -a v1_parts <<< "$v1"
    IFS='.' read -r -a v2_parts <<< "$v2"

    # Compare major, minor, patch
    for i in 0 1 2; do
        local num1=${v1_parts[$i]:-0}
        local num2=${v2_parts[$i]:-0}

        if (( num1 > num2 )); then
            return 1  # v1 > v2
        elif (( num1 < num2 )); then
            return 2  # v1 < v2
        fi
    done

    return 0  # equal
}

# Show version information
show_version() {
    local current=$(get_current_version)
    local latest=""

    log "Version information"
    echo "Installed version: $current"
    echo "Repository: $REPO_URL"
    echo ""

    # Check for updates if online
    if ping -c 1 -W 2 github.com >/dev/null 2>&1; then
        log "Checking for updates..."
        latest=$(get_latest_version || echo "unknown")

        if [ "$latest" = "unknown" ]; then
            warn "Could not fetch latest version from GitHub"
            echo "Make sure you have internet connection and curl/git installed."
        else
            echo "Latest version: $latest"

            compare_versions "$current" "$latest"
            case $? in
                0) ok "You have the latest version!" ;;
                1) warn "You have a newer version than the latest release ($current > $latest)" ;;
                2)
                    echo ""
                    warn "Update available: $current → $latest"
                    echo "To update, run: ai-framework update"
                    echo "Or manually: cd $FRAMEWORK_DIR && git pull"
                    ;;
            esac
        fi
    else
        warn "No internet connection — cannot check for updates"
        echo "Latest version check requires internet access."
    fi
}

# Update version file (for release process)
update_version() {
    local new_version=$1

    if [ -z "$new_version" ]; then
        error "Usage: $0 set <version>"
        echo "Example: $0 set v3.1.0"
        exit 1
    fi

    # Validate version format (vX.Y.Z)
    if [[ ! "$new_version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        error "Invalid version format: $new_version"
        echo "Version must follow semver format: vX.Y.Z"
        exit 1
    fi

    echo "$new_version" > "$VERSION_FILE"
    ok "Version updated to $new_version in $VERSION_FILE"

    # Update package.json if it exists
    if [ -f "$FRAMEWORK_DIR/package.json" ]; then
        sed -i.bak "s/\"version\": \".*\"/\"version\": \"${new_version#v}\"/" "$FRAMEWORK_DIR/package.json"
        rm -f "$FRAMEWORK_DIR/package.json.bak"
        ok "Updated version in package.json"
    fi
}

# Main command handler
main() {
    local command=${1:-"show"}

    case "$command" in
        show|"")
            show_version
            ;;
        set)
            update_version "$2"
            ;;
        check)
            # Silent check for updates (for CI/CD)
            if ping -c 1 -W 2 github.com >/dev/null 2>&1; then
                local current=$(get_current_version)
                local latest=$(get_latest_version)

                if [ "$latest" != "unknown" ]; then
                    compare_versions "$current" "$latest"
                    if [ $? -eq 2 ]; then
                        echo "UPDATE_AVAILABLE:$latest"
                        exit 1
                    else
                        echo "UP_TO_DATE:$current"
                    fi
                else
                    echo "CHECK_FAILED"
                    exit 2
                fi
            else
                echo "NO_CONNECTION"
                exit 3
            fi
            ;;
        help|--help|-h)
            echo "Usage: $0 [command]"
            echo ""
            echo "Commands:"
            echo "  show           Show current version and check for updates (default)"
            echo "  set <version>  Update version file (for release process)"
            echo "  check          Silent check for updates (returns exit codes)"
            echo "  help           Show this help message"
            echo ""
            echo "Examples:"
            echo "  ai-framework version           # Show version info"
            echo "  ai-framework version check     # Silent check for CI/CD"
            echo "  ./scripts/version.sh set v3.1.0 # Update version (release process)"
            ;;
        *)
            error "Unknown command: $command"
            echo "Use: $0 help"
            exit 1
            ;;
    esac
}

main "$@"