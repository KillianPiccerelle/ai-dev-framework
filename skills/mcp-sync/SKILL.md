---
name: mcp-sync
description: >
  Orchestrate synchronization of external context from multiple MCP sources.
  Sync GitHub, Jira, Notion context to unified project memory with conflict resolution.
tags: [mcp, sync, orchestration, integration, memory]
---

# Skill: mcp-sync

Orchestrates synchronization from multiple MCP sources (GitHub, Jira, Notion) to unified project memory. Provides conflict resolution, scheduling, and consolidated context management.

## Purpose

The `/mcp-sync` skill coordinates the three MCP connectors:
- `/mcp-github` - GitHub issues, PRs, commits
- `/mcp-jira` - Jira tickets, sprints, boards  
- `/mcp-notion` - Notion pages, databases, documentation

It creates a **unified external context** in `memory/external-context.md` with:
- Consolidated view from all sources
- Conflict detection and resolution
- Priority-based synchronization
- Scheduled updates

## Prerequisites

Requires the three MCP skills to be configured and accessible:
- `/mcp-github` - GitHub MCP server configured
- `/mcp-jira` - Jira MCP server configured  
- `/mcp-notion` - Notion MCP server configured

## Commands

### `/mcp-sync all`
Perform full synchronization from all sources.

**Usage:**
```bash
# Full sync from GitHub, Jira, Notion
/mcp-sync all

# Sync with specific priority order
/mcp-sync all --priority "github,jira,notion"

# Sync with conflict resolution
/mcp-sync all --resolve-conflicts
```

**Output:**
- Creates/updates `memory/external-context.md`
- Individual sync results from each source
- Conflict resolution summary
- Total items synchronized

### `/mcp-sync schedule`
Configure automatic synchronization scheduling.

**Usage:**
```bash
# Set daily sync schedule
/mcp-sync schedule --daily "09:00"

# Set sync on project status updates
/mcp-sync schedule --trigger "project-status"

# Configure event-based sync
/mcp-sync schedule --events "commit,push,issue-create"
```

**Output:**
- Schedule configuration saved
- Next scheduled sync time
- Trigger events registered

### `/mcp-sync conflicts`
List and resolve synchronization conflicts.

**Usage:**
```bash
# List all conflicts
/mcp-sync conflicts

# Resolve specific conflict
/mcp-sync conflicts --resolve "github-issue-42,jira-PROJ-101"

# Show conflict history
/mcp-sync conflicts --history
```

**Output:**
- Conflict list with sources and items
- Resolution recommendations
- Conflict history timeline

### `/mcp-sync status`
Show synchronization status and statistics.

**Usage:**
```bash
# Current sync status
/mcp-sync status

# Detailed statistics
/mcp-sync status --stats

# Source-specific status
/mcp-sync status --source "github"
```

**Output:**
- Last sync times per source
- Item counts synchronized
- Conflict statistics
- Schedule status

### `/mcp-sync config`
Configure synchronization preferences.

**Usage:**
```bash
# Set sync preferences
/mcp-sync config --preferences "sync-on-start,skip-archived"

# Configure memory structure
/mcp-sync config --memory-structure "unified"

# Set conflict resolution strategy
/mcp-sync config --conflict-strategy "priority-based"
```

**Output:**
- Configuration saved
- Applied preferences list
- Validation results

## Synchronization Workflow

### 1. Source Priority Configuration
Define sync priority order:
- **High priority:** GitHub issues, Jira blockers
- **Medium priority:** Jira sprints, Notion active docs
- **Low priority:** GitHub closed issues, Notion archived pages

### 2. Conflict Resolution Strategies
- **Priority-based:** Higher priority source wins
- **Timestamp-based:** Most recent update wins
- **Manual resolution:** User decides
- **Merge:** Combine information from both sources

### 3. Memory Structure Options
- **Unified:** Single `memory/external-context.md`
- **Separated:** `memory/github-context.md`, `memory/jira-context.md`, `memory/notion-context.md`
- **Hybrid:** Unified overview + separated details

## Memory Integration

The skill creates and maintains `memory/external-context.md` with:

### Unified External Context
```markdown
## External Context Summary

**Last Sync:** 2026-04-15 19:00:00
**Sources:** GitHub, Jira, Notion

### Consolidated Priority Items

#### 🔴 High Priority (Requires Immediate Attention)
| Source | Item | Type | Priority | Link |
|--------|------|------|----------|------|
| GitHub | #42 - Login fails on Safari | Bug | Critical | [Link](https://github.com/...) |
| Jira | PROJ-101 - Security vulnerability | Bug | Blocker | [Link](https://jira.com/...) |
| GitHub | #43 - API rate limiting issue | Bug | High | [Link](https://github.com/...) |

#### 🟡 Medium Priority (Current Sprint/Active)
| Source | Item | Type | Status | Link |
|--------|------|------|--------|------|
| Jira | PROJ-102 - Dark mode feature | Story | In Progress | [Link](https://jira.com/...) |
| Notion | Sprint Planning Q2 | Page | Active | [Link](https://notion.so/...) |
| GitHub | #101 - Login validation fix | PR | Review | [Link](https://github.com/...) |

#### 🟢 Low Priority (Backlog/Planning)
| Source | Item | Type | Status | Link |
|--------|------|------|--------|------|
| Notion | API Specifications v2 | Database | Planning | [Link](https://notion.so/...) |
| Jira | PROJ-103 - Documentation update | Task | Backlog | [Link](https://jira.com/...) |
| GitHub | #104 - Performance optimization | Issue | Enhancement | [Link](https://github.com/...) |

### Source Statistics
| Source | Last Sync | Items | Active | Resolved |
|--------|-----------|-------|--------|----------|
| GitHub | 2026-04-15 18:45 | 24 | 15 | 9 |
| Jira | 2026-04-15 18:50 | 18 | 12 | 6 |
| Notion | 2026-04-15 18:55 | folder12 | 8 | 4 |

### Conflict Resolution Log
| Conflict | Sources | Resolution | Date |
|----------|---------|------------|------|
| Login bug | GitHub#42 + JiraPROJ-101 | Merged (both tracked) | 2026-04-15 |
| Dark mode | GitHub#43 + JiraPROJ102 | Priority (Jira wins) | 2026-04-14 |

### Next Scheduled Sync
- **Automatic:** Daily at 09:00
- **Trigger:** On `/project-status` execution
- **Manual:** Via `/mcp-sync all`
```

## Integration Points

### In `/project-status` workflow
Automatically triggers sync:
1. Before generating status report
2. Include external context metrics
3. Update conflict resolution status

### In `/add-feature` workflow
Check external context:
1. Related issues/tickets from all sources
2. Documentation requirements
3. Priority conflicts

### In `/debug-issue` workflow
Cross-reference all sources:
1. Bug reports in GitHub/Jira
2. Documentation in Notion
3. Resolution tracking across platforms

### In `/onboard` workflow
Sync essential external context:
1. Key documentation from Notion
2. Active issues from GitHub/Jira
3. Project context from all sources

## Configuration Examples

### Basic Configuration
```json
{
  "mcpServers": {
    "github": {
      "command": "mcp-server-github",
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${env.GITHUB_TOKEN}"
      }
    },
    "jira": {
      "command": "mcp-jira-cloud",
      "env": {
        "JIRA_API_TOKEN": "${env.JIRA_TOKEN}"
      }
    },
    "notion": {
      "command": "notion-mcp-server",
      "env": {
        "NOTION_TOKEN": "${env.NOTION_TOKEN}"
      }
    }
  }
}
```

### Sync Preferences Configuration
Create `memory/sync-config.md`:
```markdown
## Synchronization Configuration

### Source Priority
1. GitHub (critical bugs)
2. Jira (blockers, sprint items)
3. Notion (active documentation)

### Conflict Resolution
- Strategy: Priority-based
- Fallback: Timestamp-based
- Manual threshold: 3+ conflicts

### Schedule
- Daily: 09:00 AM
- Trigger: `/project-status`
- Events: commit, issue-create, page-update

### Memory Structure
- Primary: Unified (`external-context.md`)
- Secondary: Separated sources
- Archives: `memory/sync-history/`
```

### Event-Based Sync Configuration
```json
{
  "hooks": {
    "post-commit": "/mcp-sync all --quick",
    "pre-project-status": "/mcp-sync all",
    "post-add-feature": "/mcp-sync conflicts --resolve"
  }
}
```

## Conflict Resolution Strategies

### 1. Priority-Based Resolution
**Rules:**
- GitHub critical bugs > Jira blockers > Notion docs
- Source priority order configurable
- Item priority within source considered

**Example:** GitHub critical bug vs Jira medium task → GitHub wins

### 2. Timestamp-Based Resolution
**Rules:**
- Most recent update wins
- Consider update frequency
- Account for source latency

**Example:** Jira ticket updated 5 min ago vs GitHub issue 1 hour ago → Jira wins

### 3. Merge Resolution
**Rules:**
- Combine information from both sources
- Preserve unique data from each
- Create cross-reference links

**Example:** GitHub issue + Jira ticket → merged entry with links to both

### 4. Manual Resolution
**Rules:**
- User decides for complex conflicts
- Log resolution decision
- Apply to similar future conflicts

**Example:** Conflicting priority assessments → user determines true priority

## Scheduling Options

### Time-Based Scheduling
- **Daily:** Fixed time each day
- **Interval:** Every X hours
- **Project phases:** Different schedules for different phases

### Event-Based Scheduling
- **GitHub events:** Commit, push, issue create/update
- **Jira events:** Ticket create/update, sprint start/end
- **Notion events:** Page update, database change
- **Framework events:** `/project-status`, `/add-feature`

### Manual Triggering
- **Command:** `/mcp-sync all`
- **Workflow integration:** Automatic in key workflows
- **Hook-based:** Post-commit, pre-deployment

## Performance Considerations

### Incremental Sync
- Only sync changed items since last sync
- Track last sync timestamp per source
- Skip archived/closed items after resolution

### Batch Processing
- Group similar items for efficient processing
- Limit concurrent source connections
- Queue management for high-volume projects

### Memory Optimization
- Trim historical data after X days
- Archive resolved items separately
- Compress duplicate information

## Troubleshooting

### Common Issues

**"Source connection failed"**
```bash
# Test individual sources
/mcp-github status
/mcp-jira status
/mcp-notion status

# Check source configurations
cat ~/.claude/settings.json | grep mcpServers
```

**"Conflict resolution loop"**
```bash
# Reset conflict history
/mcp-sync conflicts --reset

# Set manual resolution
/mcp-sync config --conflict-strategy "manual"

# Review conflict patterns
/mcp-sync conflicts --history --detailed
```

**"Sync performance issues"**
```bash
# Enable incremental sync
/mcp-sync config --preferences "incremental-only"

# Limit sync depth
/mcp-sync all --depth 1

# Skip low priority items
/mcp-sync all --priority "high,medium"
```

### Debug Mode
```bash
# Enable debug logging
/mcp-sync all --debug

# Show sync process details
/mcp-sync status --verbose

# Log to file
/mcp-sync all --log-file "sync.log"
```

## Expected Benefits

### Unified Context View
- Single source for all external context
- Cross-platform visibility
- Reduced cognitive load

### Conflict Management
- Automated conflict detection
- Consistent resolution strategies
- Resolution history tracking

### Workflow Efficiency
- Automatic sync in key workflows
- Reduced manual sync effort
- Consistent context across team

### Memory Optimization
- Consolidated memory structure
- Historical data management
- Performance optimization

## Verification

```bash
# Test sync functionality
/mcp-sync status

# Test conflict resolution
/mcp-sync conflicts --test

# Test schedule configuration
/mcp-sync schedule --test
```

## Important Notes

### Current Status (April 2026)
- **Orchestration skill** for three MCP connectors
- **All three MCP servers available:** GitHub, Jira, Notion
- **Community and official packages** confirmed functional

### Implementation Approach
1. **Phase 1:** Structure and orchestration logic (current)
2. **Phase 2:** Conflict resolution implementation
3. **Phase 3:** Scheduling and automation
4. **Phase 4:** Performance optimization

### Dependencies
- Requires `/mcp-github`, `/mcp-jira`, `/mcp-notion` to be configured
- Depends on MCP server availability and connectivity
- Assumes proper authentication for all sources

### Scalability Considerations
- Start with small project for testing
- Gradually increase sync frequency
- Monitor memory file growth
- Consider archiving strategy for large projects

---

*Dernière mise à jour: 2026-04-15 - Phase 4: Orchestration MCP Sync (triade complète)*