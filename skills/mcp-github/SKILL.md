---
name: mcp-github
description: >
  Interact with GitHub repositories via MCP (Model Context Protocol).
  List issues, pull requests, create issues, sync external context to project memory.
tags: [mcp, github, integration, external, collaboration]
---

# Skill: mcp-github

Integrates GitHub with Claude Code via the official GitHub MCP server. Synchronizes GitHub context (issues, PRs, commits) with project memory for enhanced collaboration and context awareness.

## Prerequisites

### 1. Choose GitHub MCP Server Version

**Option A: Remote Server (Recommended for most users)**
- Hosted by GitHub at `https://api.githubcopilot.com/mcp/`
- No installation required
- Uses OAuth or Personal Access Token
- Automatically updated by GitHub

**Option B: Local Server (Self-hosted)**
- Docker image: `ghcr.io/github/github-mcp-server`
- Or npm package (deprecated but functional): `@modelcontextprotocol/server-github`

### 2. Install Local Server (Optional)
```bash
# Option 1: Docker (recommended for local)
docker pull ghcr.io/github/github-mcp-server

# Option 2: npm (deprecated but functional)
npm install -g @modelcontextprotocol/server-github

# Verify installation
mcp-server-github --version  # Should show "GitHub MCP Server running on stdio"
```

### 3. Configure GitHub Authentication
```bash
# Create a GitHub Personal Access Token with appropriate permissions
# Required scopes: repo (full control of private repositories)
# Create token at: https://github.com/settings/tokens

# Set as environment variable
export GITHUB_TOKEN="your_personal_access_token_here"
```

### 4. Configure Claude Code
Add to your `~/.claude/settings.json`:

**For Remote Server (Recommended):**
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-github"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env.GITHUB_TOKEN}"
      }
    }
  }
}
```

**For Docker Local Server:**
```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run",
        "-i",
        "--rm",
        "-e",
        "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<YOUR_TOKEN>"
      }
    }
  }
}
```

**For npm Local Server:**
```json
{
  "mcpServers": {
    "github": {
      "command": "mcp-server-github",
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env.GITHUB_TOKEN}"
      }
    }
  }
}
```

## Commands

### `/mcp-github issues`
List open issues for the current repository.

**Usage:**
```bash
# List all open issues
/mcp-github issues

# List issues with specific labels
/mcp-github issues --labels "bug,enhancement"

# List issues assigned to you
/mcp-github issues --assignee @me

# Filter by state
/mcp-github issues --state closed
```

**Output:**
- List of issues with title, number, assignee, labels
- Link to GitHub issue
- Priority based on labels (bug > enhancement > question)

### `/mcp-github prs`
List open pull requests for the current repository.

**Usage:**
```bash
# List all open PRs
/mcp-github prs

# List PRs by author
/mcp-github prs --author "username"

# List PRs requiring review
/mcp-github prs --review-requested @me

# Filter by draft status
/mcp-github prs --draft true
```

**Output:**
- List of PRs with title, number, author, review status
- Link to GitHub PR
- Mergeability status

### `/mcp-github create-issue`
Create a new GitHub issue.

**Usage:**
```bash
# Create issue with title and body
/mcp-github create-issue "Bug: Login fails on Safari" "Steps to reproduce:..."

# Create issue with labels
/mcp-github create-issue --labels "bug,high-priority" "Feature: Dark mode"

# Assign to specific user
/mcp-github create-issue --assignee "team-member" "Documentation update"
```

**Output:**
- Created issue URL
- Issue number and title
- Confirmation of assignment and labels

### `/mcp-github sync`
Synchronize GitHub context to project memory.

**Usage:**
```bash
# Full sync of all GitHub context
/mcp-github sync

# Sync only issues
/mcp-github sync --issues

# Sync only PRs
/mcp-github sync --prs

# Sync with specific repository
/mcp-github sync --repo "owner/repo"
```

**Output:**
- Creates/updates `memory/github-context.md`
- Summary of synchronized items
- Link to memory file

### `/mcp-github status`
Show GitHub repository status and metrics.

**Usage:**
```bash
# Show repository overview
/mcp-github status

# Show with detailed metrics
/mcp-github status --detailed

# Compare with previous state
/mcp-github status --compare
```

**Output:**
- Open issues count (by priority)
- Open PRs count (by status)
- Recent activity summary
- Health metrics

## GitHub MCP Server Toolsets

The GitHub MCP server exposes tools grouped into **toolsets** for granular control:

### **Repos Tools**
- `create_or_update_file` - Create/update files in repositories
- `push_files` - Push multiple files in single commit
- `search_repositories` - Search for GitHub repositories
- `create_repository` - Create new repositories
- `get_file_contents` - Get file/directory contents
- `fork_repository` - Fork repositories

### **Issues Tools**
- `create_issue` - Create new issues
- `search_issues` - Search issues/PRs
- `get_issue` - Get issue details
- `update_issue` - Update existing issues
- `add_issue_comment` - Add comments to issues
- `get_issue_comments` - Get issue comments

### **Pull Requests Tools**
- `create_pull_request` - Create new PRs
- `get_pull_request` - Get PR details
- `update_pull_request` - Update existing PRs
- `add_pull_request_comment` - Add comments to PRs
- `get_pull_request_comments` - Get PR comments
- `get_pull_request_reviews` - Get PR reviews

### **Actions Tools**
- `get_workflow_runs` - Get workflow run status
- `trigger_workflow` - Trigger GitHub Actions workflows

### **Code Security Tools**
- `get_code_scanning_alerts` - Get security scan alerts
- `get_dependabot_alerts` - Get dependency vulnerability alerts

## Memory Integration

The skill creates and maintains `memory/github-context.md` with:

### Repository Context
```markdown
## GitHub Repository: owner/repo

**URL:** https://github.com/owner/repo
**Last Sync:** 2026-04-15 16:30:00

### Open Issues (15)
| # | Title | Assignee | Labels | Created | Priority |
|---|-------|----------|--------|---------|----------|
| 42 | Bug: Login fails on Safari | @user1 | bug, high | 2026-04-10 | 🔴 High |
| 43 | Feature: Dark mode | - | enhancement | 2026-04-12 | 🟡 Medium |

### Open Pull Requests (3)
| # | Title | Author | Review Status | Draft | Created |
|---|-------|--------|---------------|-------|---------|
| 101 | Fix login validation | @user2 | ✅ Approved | No | 2026-04-14 |
| 102 | Add dark mode | @user3 | ⏳ Changes requested | Yes | 2026-04-15 |

### Recent Activity
- **Last commit:** `abc123` - Update README (2026-04-15)
- **Last issue update:** #42 - Comment added (2026-04-15)
- **Last PR update:** #101 - Review completed (2026-04-15)
```

### Priority Classification
- **🔴 High:** Issues with `bug`, `critical`, `high-priority` labels
- **🟡 Medium:** Issues with `enhancement`, `feature` labels  
- **🟢 Low:** Issues with `question`, `documentation` labels
- **⚪ Backlog:** No labels or low priority labels

## Integration Points

### In `/add-feature` workflow
Before implementing a feature:
1. Check for existing GitHub issues with similar scope
2. Reference issue number in commit messages
3. Update issue status when feature is complete

### In `/debug-issue` workflow
When debugging:
1. Link to related GitHub issues
2. Add reproduction steps as issue comments
3. Close issue when bug is fixed

### In `/project-status` workflow
Include GitHub metrics:
- Open issues by priority
- PRs awaiting review
- Recent activity timeline
- Contribution statistics

### In `/security-audit` workflow
Check for:
- Open security issues
- Dependabot alerts
- Security advisories

## Configuration Examples

### Basic Configuration
```json
{
  "mcpServers": {
    "github": {
      "command": "github-mcp-server",
      "args": ["--token", "${env.GITHUB_TOKEN}"],
      "env": {
        "GITHUB_TOKEN": "${env.GITHUB_TOKEN}"
      }
    }
  }
}
```

### Advanced Configuration (Multiple Repos)
```json
{
  "mcpServers": {
    "github-main": {
      "command": "github-mcp-server",
      "args": ["--token", "${env.GITHUB_TOKEN}", "--repo", "owner/main-repo"],
      "env": {
        "GITHUB_TOKEN": "${env.GITHUB_TOKEN}"
      }
    },
    "github-docs": {
      "command": "github-mcp-server", 
      "args": ["--token", "${env.GITHUB_TOKEN}", "--repo", "owner/docs"],
      "env": {
        "GITHUB_TOKEN": "${env.GITHUB_TOKEN}"
      }
    }
  }
}
```

## Security Considerations

### Token Management
- Store GitHub token in environment variables, not in code
- Use tokens with minimal required permissions (repo scope for full access)
- Rotate tokens regularly (every 90 days recommended)
- Never commit tokens to version control

### Permission Scopes
- **repo (full):** Read/write access to code, issues, PRs
- **repo (public only):** Read access to public repositories
- **read:org:** Read organization membership (for team assignments)
- **read:user:** Read user profile information

### Secret Detection
The framework's `secret-detector.js` hook will detect and warn about:
- GitHub tokens in code (`ghp_`, `github_pat_`)
- Token exposure in commit messages
- Token in configuration files

## Troubleshooting

### Common Issues

**"MCP server not found"**
```bash
# Verify installation
which github-mcp-server

# Reinstall if missing
npm install -g @modelcontextprotocol/server-github
```

**"Authentication failed"**
```bash
# Check token is set
echo $GITHUB_TOKEN

# Verify token permissions
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

**"Repository not found"**
```bash
# Check repository exists and is accessible
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/owner/repo
```

### Debug Mode
Enable debug logging:
```bash
export DEBUG=mcp:*
/mcp-github issues
```

## Expected Benefits

### Context Awareness
- GitHub issues automatically linked to project memory
- PR status visible during development
- Team collaboration context preserved

### Workflow Integration
- Automatic issue creation from `/add-feature`
- Bug tracking in `/debug-issue`
- Project metrics in `/project-status`

### Token Reduction
By syncing GitHub context to memory:
- **~5× reduction** in tokens for GitHub-related queries
- Persistent context between sessions
- Faster issue/PR lookups

## Installation Verification

```bash
# Test GitHub MCP server connection
github-mcp-server --token $GITHUB_TOKEN --test

# Test skill integration
/mcp-github status
```

## Important Notes

### Package Status
- **`@modelcontextprotocol/server-github` npm package is DEPRECATED** but still functional
- Development moved to `github/github-mcp-server` repository on GitHub
- Recommended to use remote server (`https://api.githubcopilot.com/mcp/`) or Docker image
- npm package may stop working in future versions of Claude Code

### General Notes
- First sync may take longer as it fetches all repository data
- Memory file is updated incrementally on subsequent syncs
- Add `memory/github-context.md` to `.gitignore` if it contains sensitive information
- Rate limiting: GitHub API allows 5000 requests/hour for authenticated users
- Consider using toolsets to limit permissions (e.g., read-only for certain operations)

---

*Dernière mise à jour: 2026-04-15 - Phase 4: Intégration MCP GitHub*