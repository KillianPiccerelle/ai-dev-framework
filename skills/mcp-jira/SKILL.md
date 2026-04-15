---
name: mcp-jira
description: >
  Interact with Jira projects via MCP (Model Context Protocol).
  List issues, sprints, create tickets, sync Jira context to project memory.
tags: [mcp, jira, integration, external, project-management]
---

# Skill: mcp-jira

Integrates Jira with Claude Code via MCP server. Synchronizes Jira context (issues, sprints, boards) with project memory for enhanced project management and context awareness.

## Prerequisites

### 1. Install Jira MCP Server

**Two community-maintained options available (April 2026):**

**Option A: Jira Data Center** (`@atlassian-dc-mcp/jira`)
```bash
# Install for Jira Data Center
npm install -g @atlassian-dc-mcp/jira

# Verify installation
jira --version
```

**Option B: Jira Cloud** (`mcp-jira-cloud`)
```bash
# Install for Jira Cloud
npm install -g mcp-jira-cloud

# Verify installation  
mcp-jira-cloud --version
```

**Package details:**
- **Data Center:** `@atlassian-dc-mcp/jira@0.16.0` (updated 2026-04-14)
- **Cloud:** `mcp-jira-cloud@4.2.1` (74 tools, MIT license)
- **Note:** Both are community-maintained, not official Atlassian products

### 2. Configure Jira Authentication
```bash
# Jira typically requires:
# - Base URL (e.g., https://your-domain.atlassian.net)
# - Email/username
# - API token (from https://id.atlassian.com/manage-profile/security/api-tokens)

# Set as environment variables
export JIRA_BASE_URL="https://your-domain.atlassian.net"
export JIRA_USER_EMAIL="your-email@example.com"
export JIRA_API_TOKEN="your_api_token_here"
```

### 3. Configure Claude Code
Add to your `~/.claude/settings.json`:

**For Jira Data Center (`@atlassian-dc-mcp/jira`):**
```json
{
  "mcpServers": {
    "jira-dc": {
      "command": "jira",
      "args": [
        "--base-url", "${env.JIRA_BASE_URL}",
        "--username", "${env.JIRA_USERNAME}",
        "--password", "${env.JIRA_PASSWORD}"
      ],
      "env": {
        "JIRA_BASE_URL": "${env.JIRA_BASE_URL}",
        "JIRA_USERNAME": "${env.JIRA_USERNAME}",
        "JIRA_PASSWORD": "${env.JIRA_PASSWORD}"
      }
    }
  }
}
```

**For Jira Cloud (`mcp-jira-cloud`):**
```json
{
  "mcpServers": {
    "jira-cloud": {
      "command": "mcp-jira-cloud",
      "args": [
        "--baseUrl", "${env.JIRA_BASE_URL}",
        "--email", "${env.JIRA_USER_EMAIL}",
        "--apiToken", "${env.JIRA_API_TOKEN}"
      ],
      "env": {
        "JIRA_BASE_URL": "${env.JIRA_BASE_URL}",
        "JIRA_USER_EMAIL": "${env.JIRA_USER_EMAIL}",
        "JIRA_API_TOKEN": "${env.JIRA_API_TOKEN}"
      }
    }
  }
}
```

## Commands

### `/mcp-jira issues`
List Jira issues for the current project.

**Usage:**
```bash
# List open issues in current project
/mcp-jira issues

# List issues with specific status
/mcp-jira issues --status "In Progress"

# List issues assigned to current user
/mcp-jira issues --assignee me

# Filter by JQL (Jira Query Language)
/mcp-jira issues --jql "project = PROJ AND status = Done"
```

**Output:**
- List of issues with key, summary, status, assignee
- Link to Jira issue
- Priority and type indicators

### `/mcp-jira sprints`
List active sprints and their issues.

**Usage:**
```bash
# List current sprint
/mcp-jira sprints

# List all sprints in board
/mcp-jira sprints --board "Development Board"

# List sprint issues
/mcp-jira sprints --sprint "Sprint 42" --issues
```

**Output:**
- Sprint name, dates, status
- Issue count by status (To Do, In Progress, Done)
- Velocity metrics if available

### `/mcp-jira create-issue`
Create a new Jira issue.

**Usage:**
```bash
# Create issue with summary and description
/mcp-jira create-issue "Bug: Application crashes on login" "Steps to reproduce:..."

# Create with specific project and issue type
/mcp-jira create-issue --project PROJ --type "Bug" "Feature: Add export functionality"

# Assign and add labels
/mcp-jira create-issue --assignee "username" --labels "backend,high-priority" "Task: Update API"
```

**Output:**
- Created issue key (e.g., PROJ-123)
- Issue URL
- Confirmation of creation

### `/mcp-jira sync`
Synchronize Jira context to project memory.

**Usage:**
```bash
# Full sync of Jira context
/mcp-jira sync

# Sync only issues
/mcp-jira sync --issues

# Sync only sprints
/mcp-jira sync --sprints

# Sync specific project
/mcp-jira sync --project "PROJ"
```

**Output:**
- Creates/updates `memory/jira-context.md`
- Summary of synchronized items
- Link to memory file

### `/mcp-jira status`
Show Jira project status and metrics.

**Usage:**
```bash
# Show project overview
/mcp-jira status

# Show with burndown chart
/mcp-jira status --burndown

# Show team metrics
/mcp-jira status --team-metrics
```

**Output:**
- Open issue count (by priority/status)
- Sprint progress
- Team velocity
- Recent activity

## Jira MCP Server Toolsets

**`mcp-jira-cloud` provides 74 tools across these categories:**

### **Issues & Tickets (25+ tools)**
- `search_issues` - Search issues with JQL
- `create_issue` - Create new issues
- `get_issue` - Get issue details
- `update_issue` - Update existing issues
- `delete_issue` - Delete issues
- `add_comment` - Add comments
- `get_comments` - Get issue comments
- `transition_issue` - Change issue status/workflow
- `add_attachment` - Attach files to issues
- `get_attachments` - Get issue attachments
- `vote_issue` - Vote on issues
- `watch_issue` - Watch/unwatch issues

### **Sprints & Agile (15+ tools)**
- `get_sprints` - Get all sprints
- `get_active_sprint` - Get current active sprint
- `create_sprint` - Create new sprint
- `update_sprint` - Update sprint details
- `get_sprint_issues` - Get issues in sprint
- `add_issues_to_sprint` - Add issues to sprint
- `remove_issues_from_sprint` - Remove issues from sprint
- `get_board` - Get Agile board details
- `get_board_issues` - Get issues on board
- `move_issue_on_board` - Move issue on board

### **Projects & Components (10+ tools)**
- `get_projects` - List all projects
- `get_project` - Get project details
- `get_project_components` - Get project components
- `create_component` - Create new component
- `get_project_versions` - Get project versions/releases
- `create_version` - Create new version
- `get_project_roles` - Get project roles
- `add_project_role_actor` - Add actor to project role

### **Worklogs & Time Tracking (8+ tools)**
- `add_worklog` - Log work on issues
- `get_worklogs` - Get worklog entries
- `update_worklog` - Update worklog
- `delete_worklog` - Delete worklog
- `get_worklog_properties` - Get worklog properties
- `estimate_issue` - Set time estimate
- `get_time_tracking` - Get time tracking info

### **Users & Groups (6+ tools)**
- `search_users` - Search Jira users
- `get_user` - Get user details
- `get_user_groups` - Get user's groups
- `get_groups` - Get all groups
- `add_user_to_group` - Add user to group
- `remove_user_from_group` - Remove user from group

### **Filters & Dashboards (5+ tools)**
- `get_filters` - Get saved filters
- `create_filter` - Create new filter
- `get_filter` - Get filter details
- `get_dashboards` - Get dashboards
- `get_dashboard` - Get dashboard details

### **Webhooks & Automation (5+ tools)**
- `get_webhooks` - Get webhooks
- `create_webhook` - Create webhook
- `delete_webhook` - Delete webhook
- `trigger_automation_rule` - Trigger automation rule
- `get_automation_rules` - Get automation rules

## Memory Integration

The skill creates and maintains `memory/jira-context.md` with:

### Project Context
```markdown
## Jira Project: PROJ (Project Name)

**URL:** https://your-domain.atlassian.net/browse/PROJ
**Last Sync:** 2026-04-15 17:30:00

### Current Sprint: Sprint 42 (Apr 10 - Apr 24)
**Progress:** 15/35 issues completed (43%)
**Status:** 🔵 In Progress

#### Sprint Issues
| Key | Summary | Status | Assignee | Story Points |
|-----|---------|--------|----------|--------------|
| PROJ-101 | Fix login validation | ✅ Done | @user1 | 3 |
| PROJ-102 | Add dark mode | 🔄 In Progress | @user2 | 5 |
| PROJ-103 | Update documentation | ⏳ To Do | - | 2 |

### Backlog Issues (High Priority)
| Key | Summary | Type | Priority | Created |
|-----|---------|------|----------|---------|
| PROJ-104 | Performance optimization | Story | 🔴 High | 2026-04-12 |
| PROJ-105 | Security audit | Task | 🔴 High | 2026-04-14 |

### Project Metrics
- **Open issues:** 24 total (8 High, 12 Medium, 4 Low)
- **Sprint velocity:** 32 story points (average)
- **Resolution time:** 4.2 days (average)
- **Active sprints:** 1 of 3 boards
```

### Priority Classification
- **🔴 Blocker/Critical:** Immediate attention required
- **🟡 High/Major:** Important for next release
- **🟢 Medium/Minor:** Normal priority
- **⚪ Low/Trivial:** When resources available

## Integration Points

### In `/add-feature` workflow
Before implementing a feature:
1. Check for related Jira tickets/requirements
2. Reference Jira issue key in commit messages
3. Update ticket status when feature is complete
4. Log work time if applicable

### In `/debug-issue` workflow
When debugging:
1. Link to related Jira bug reports
2. Add reproduction steps as ticket comments
3. Transition ticket status when bug is fixed
4. Document resolution in ticket

### In `/project-status` workflow
Include Jira metrics:
- Sprint burndown charts
- Team velocity trends
- Issue aging analysis
- Release progress tracking

### In `/dependency-update` workflow
Check for:
- Jira tickets tracking dependency updates
- Security vulnerabilities logged in Jira
- Compliance requirements documented

## Configuration Examples

### Basic Configuration
```json
{
  "mcpServers": {
    "jira": {
      "command": "jira-mcp-server",
      "args": [
        "--base-url", "${env.JIRA_BASE_URL}",
        "--email", "${env.JIRA_USER_EMAIL}",
        "--token", "${env.JIRA_API_TOKEN}"
      ],
      "env": {
        "JIRA_BASE_URL": "${env.JIRA_BASE_URL}",
        "JIRA_USER_EMAIL": "${env.JIRA_USER_EMAIL}",
        "JIRA_API_TOKEN": "${env.JIRA_API_TOKEN}"
      }
    }
  }
}
```

### Multiple Projects Configuration
```json
{
  "mcpServers": {
    "jira-dev": {
      "command": "jira-mcp-server",
      "args": [
        "--base-url", "${env.JIRA_DEV_URL}",
        "--email", "${env.JIRA_DEV_EMAIL}",
        "--token", "${env.JIRA_DEV_TOKEN}",
        "--project", "DEV"
      ],
      "env": {
        "JIRA_DEV_URL": "${env.JIRA_DEV_URL}",
        "JIRA_DEV_EMAIL": "${env.JIRA_DEV_EMAIL}",
        "JIRA_DEV_TOKEN": "${env.JIRA_DEV_TOKEN}"
      }
    },
    "jira-ops": {
      "command": "jira-mcp-server",
      "args": [
        "--base-url", "${env.JIRA_OPS_URL}",
        "--email", "${env.JIRA_OPS_EMAIL}",
        "--token", "${env.JIRA_OPS_TOKEN}",
        "--project", "OPS"
      ],
      "env": {
        "JIRA_OPS_URL": "${env.JIRA_OPS_URL}",
        "JIRA_OPS_EMAIL": "${env.JIRA_OPS_EMAIL}",
        "JIRA_OPS_TOKEN": "${env.JIRA_OPS_TOKEN}"
      }
    }
  }
}
```

## Security Considerations

### Token Management
- Store Jira tokens in environment variables, not in code
- Use API tokens with minimal required permissions
- Rotate tokens regularly (every 90 days recommended)
- Never commit tokens to version control

### Permission Scopes
- **Read access:** View issues, projects, boards
- **Write access:** Create/update issues, comments
- **Admin access:** Project configuration (use sparingly)

### Secret Detection
The framework's `secret-detector.js` hook will detect and warn about:
- Jira API tokens in code
- Jira credentials in configuration files
- Token exposure in commit messages

## Troubleshooting

### Common Issues

**"MCP server not found"**
```bash
# Verify if Jira MCP server is available
# Check Atlassian marketplace or community repos

# Alternative: Use Jira REST API directly until MCP server exists
```

**"Authentication failed"**
```bash
# Check credentials are set
echo $JIRA_BASE_URL
echo $JIRA_USER_EMAIL

# Test with curl
curl -u "$JIRA_USER_EMAIL:$JIRA_API_TOKEN" "$JIRA_BASE_URL/rest/api/3/myself"
```

**"Project not found"**
```bash
# Verify project key exists
curl -u "$JIRA_USER_EMAIL:$JIRA_API_TOKEN" "$JIRA_BASE_URL/rest/api/3/project/PROJ"
```

### Fallback Implementation

If no Jira MCP server exists yet, this skill can work with:

1. **Direct Jira REST API integration**
2. **Community CLI tools** (like `jira-cli`)
3. **Custom Python/Node.js scripts** wrapping Jira API

## Expected Benefits

### Project Context Awareness
- Jira issues automatically linked to project memory
- Sprint status visible during development
- Team collaboration context preserved

### Workflow Integration
- Automatic ticket creation from `/add-feature`
- Bug tracking in `/debug-issue`
- Project metrics in `/project-status`

### Token Reduction
By syncing Jira context to memory:
- **~4× reduction** in tokens for Jira-related queries
- Persistent context between sessions
- Faster issue/sprint lookups

## Installation Verification

```bash
# Test Jira connection (when MCP server available)
jira-mcp-server --test-connection

# Test skill integration
/mcp-jira status
```

## Important Notes

### Current Status (April 2026)
- **Jira MCP servers ARE available** via community packages
- Two main options: Jira Data Center (`@atlassian-dc-mcp/jira`) and Jira Cloud (`mcp-jira-cloud`)
- Both are **community-maintained**, not official Atlassian products
- `mcp-jira-cloud` offers **74 tools** for comprehensive integration

### Package Details
- **Jira Data Center:** `@atlassian-dc-mcp/jira@0.16.0` (updated 2026-04-14)
- **Jira Cloud:** `mcp-jira-cloud@4.2.1` (MIT license, 74 tools)
- **Actively maintained** with recent updates

### Security Considerations
- Review package permissions before installation
- Community packages may have different security audits than official ones
- Monitor GitHub repositories for security updates
- Consider self-hosting if corporate security policies require it

### Production Readiness
- **Jira Cloud package** (`mcp-jira-cloud`) appears more mature (version 4.2.1)
- **Jira Data Center package** is actively updated (0.16.0 released yesterday)
- Test in non-production environment first
- Backup Jira data before extensive automation

---

*Dernière mise à jour: 2026-04-15 - Phase 4: Intégration MCP Jira (serveurs communautaires disponibles)*