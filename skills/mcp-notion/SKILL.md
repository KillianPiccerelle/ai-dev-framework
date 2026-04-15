---
name: mcp-notion
description: >
  Interact with Notion workspaces via MCP (Model Context Protocol).
  Read/write pages, query databases (data sources), sync documentation to project memory.
tags: [mcp, notion, integration, external, documentation]
---

# Skill: mcp-notion

Integrates Notion with Claude Code via the official Notion MCP server. Synchronizes Notion documentation, pages, and databases (data sources) with project memory for enhanced documentation awareness.

## Prerequisites

### 1. Choose Notion MCP Option

**Option A: Remote Notion MCP (Recommended)**
- OAuth-based, easier installation
- Access via: `https://mcp.notion.com`
- No local server management
- **Recommended for most users**

**Option B: Local Notion MCP Server**
- Official package: `@notionhq/notion-mcp-server`
- Self-hosted, more control
- 22 tools available

### 2. Install Local Server (Optional)
```bash
# Install official Notion MCP server
npm install -g @notionhq/notion-mcp-server

# Verify installation
notion-mcp-server --version
```

### 3. Configure Notion Authentication

#### Create Notion Integration
1. Go to [Notion Integrations](https://www.notion.so/profile/integrations)
2. Create a new **internal integration** or select existing
3. Note the **Integration Token** (starts with `ntn_`)

#### Configure Integration Capabilities
For security, consider read-only configuration:
- **Read content** (minimum for syncing)
- **Update content** (if you need to write back)
- **Insert content** (for creating new pages)

#### Connect Content to Integration
1. Visit the **Access** tab in integration settings
2. Select pages/databases to connect
3. Or connect individually via page ••• menu → "Connect to integration"

### 4. Configure Claude Code
Add to your `~/.claude/settings.json`:

**For Remote MCP (Recommended):**
```json
{
  "mcpServers": {
    "notion": {
      "url": "https://mcp.notion.com"
      // OAuth will be handled automatically
    }
  }
}
```

**For Local Server:**
```json
{
  "mcpServers": {
    "notion": {
      "command": "notion-mcp-server",
      "env": {
        "NOTION_TOKEN": "${env.NOTION_TOKEN}"
      }
    }
  }
}
```

## Commands

### `/mcp-notion search`
Search for pages and databases in Notion.

**Usage:**
```bash
# Search all content
/mcp-notion search "project documentation"

# Search with filters
/mcp-notion search --filter "page" "API specifications"

# Search in specific workspace
/mcp-notion search --workspace "Engineering" "meeting notes"
```

**Output:**
- List of pages with title, type, last edited
- Page URLs and IDs
- Content preview (first 200 chars)

### `/mcp-notion get-page`
Get contents of a Notion page.

**Usage:**
```bash
# Get page by ID
/mcp-notion get-page "1a6b35e6e67f802fa7e1d27686f017f2"

# Get page with full content
/mcp-notion get-page --full "page-id"

# Get page as markdown
/mcp-notion get-page --format markdown "page-id"
```

**Output:**
- Page title and properties
- Content in requested format
- Child pages/blocks if available
- Last edited timestamp

### `/mcp-notion query-db`
Query a Notion database (data source).

**Usage:**
```bash
# Query database by ID
/mcp-notion query-db "data-source-id"

# Query with filters
/mcp-notion query-db --filter "Status = 'Active'" "db-id"

# Query with sorting
/mcp-notion query-db --sort "Last edited" --desc "db-id"
```

**Output:**
- Database schema (properties)
- Query results with all properties
- Result count and pagination info
- Data source metadata

### `/mcp-notion sync`
Synchronize Notion content to project memory.

**Usage:**
```bash
# Full sync of connected content
/mcp-notion sync

# Sync specific page and children
/mcp-notion sync --page "page-id"

# Sync database content
/mcp-notion sync --database "data-source-id"

# Sync with depth limit
/mcp-notion sync --depth 2
```

**Output:**
- Creates/updates `memory/notion-context.md`
- Summary of synchronized items
- Link to memory file
- Sync statistics (pages, databases, blocks)

### `/mcp-notion create-page`
Create a new Notion page.

**Usage:**
```bash
# Create page with title
/mcp-notion create-page "Meeting Notes 2026-04-15"

# Create under parent page
/mcp-notion create-page --parent "parent-page-id" "New Documentation"

# Create with content
/mcp-notion create-page --content "# Title\nContent here" "Page Title"
```

**Output:**
- Created page ID
- Page URL
- Confirmation with properties

## Notion MCP Server Tools (22 tools)

### **Pages Tools**
- `retrieve-a-page` - Get page details and content
- `create-a-page` - Create new page
- `update-a-page` - Update page properties/content
- `move-page` - Move page to different parent
- `archive-a-page` - Archive (delete) page
- `search` - Search pages and databases

### **Data Sources (Databases) Tools**
- `query-data-source` - Query database with filters/sorts
- `retrieve-a-data-source` - Get data source metadata/schema
- `update-a-data-source` - Update data source properties
- `create-a-data-source` - Create new data source
- `list-data-source-templates` - List available templates
- `retrieve-a-database` - Get database metadata (includes data source IDs)

### **Blocks & Content Tools**
- `retrieve-block-children` - Get child blocks of a page/block
- `append-block-children` - Add blocks to page/block
- `update-a-block` - Update block content
- `delete-a-block` - Remove block

### **Comments & Discussions**
- `create-a-comment` - Add comment to page/block
- `retrieve-comments` - Get comments on page/block

### **Users & Workspace**
- `list-users` - Get workspace users
- `retrieve-a-user` - Get user details
- `retrieve-a-workspace` - Get workspace info

### **Miscellaneous**
- `get-version` - Get API version info

## Memory Integration

The skill creates and maintains `memory/notion-context.md` with:

### Workspace Context
```markdown
## Notion Workspace: Engineering Team

**Last Sync:** 2026-04-15 18:30:00
**Connected Pages:** 24 | **Databases:** 6

### Key Documentation
| Page | Type | Last Edited | Status | Link |
|------|------|-------------|--------|------|
| 📋 Project Requirements | Page | 2026-04-14 | 🔄 Active | [Link](https://notion.so/...) |
| 🗂️ API Specifications | Database | 2026-04-13 | ✅ Complete | [Link](https://notion.so/...) |
| 📊 Sprint Planning | Page | 2026-04-15 | 🔄 Active | [Link](https://notion.so/...) |
| 🔧 Development Guidelines | Page | 2026-04-12 | ✅ Complete | [Link](https://notion.so/...) |

### Active Databases (Data Sources)
| Database | Type | Records | Last Updated |
|----------|------|---------|--------------|
| 🐛 Bug Tracker | Data Source | 142 | 2026-04-15 |
| 🚀 Feature Backlog | Data Source | 89 | 2026-04-14 |
| 📈 Project Metrics | Data Source | 56 | 2026-04-13 |

### Recent Updates
- **2026-04-15:** Updated "Sprint Planning" with new tasks
- **2026-04-14:** Added 3 new bugs to "Bug Tracker"
- **2026-04-13:** Completed "API Specifications" review

### Quick Access
- **Project Docs:** `page-id-1`
- **Bug Database:** `data-source-id-abc`
- **Team Directory:** `page-id-2`
```

### Content Classification
- **🔄 Active:** Recently edited (last 7 days)
- **✅ Complete:** Not edited in 30+ days, marked complete
- **📋 Template:** Used as template for new pages
- **🗄️ Archived:** Archived/inactive content

## Integration Points

### In `/new-project` workflow
During project setup:
1. Create project documentation structure in Notion
2. Link to requirements/planning pages
3. Set up project databases (backlog, tasks, docs)

### In `/add-feature` workflow
When adding features:
1. Check Notion for requirements/specifications
2. Update feature backlog database
3. Document implementation in project docs

### In `/project-status` workflow
Include Notion metrics:
- Documentation completeness
- Active pages/databases
- Recent updates timeline
- Team collaboration stats

### In `/onboard` workflow
For new team members:
1. Sync essential documentation to memory
2. Provide links to key Notion pages
3. Grant access to relevant databases

### In `/doc-writer` agent
When generating documentation:
1. Check existing Notion docs for consistency
2. Update or create pages as needed
3. Maintain documentation structure

## Configuration Examples

### Basic Configuration (Local)
```json
{
  "mcpServers": {
    "notion": {
      "command": "notion-mcp-server",
      "env": {
        "NOTION_TOKEN": "${env.NOTION_TOKEN}"
      }
    }
  }
}
```

### Multiple Workspaces
```json
{
  "mcpServers": {
    "notion-eng": {
      "command": "notion-mcp-server",
      "args": ["--workspace", "engineering"],
      "env": {
        "NOTION_TOKEN": "${env.NOTION_ENG_TOKEN}"
      }
    },
    "notion-docs": {
      "command": "notion-mcp-server",
      "args": ["--workspace", "documentation"],
      "env": {
        "NOTION_TOKEN": "${env.NOTION_DOCS_TOKEN}"
      }
    }
  }
}
```

### Read-Only Configuration
```json
{
  "mcpServers": {
    "notion-readonly": {
      "command": "notion-mcp-server",
      "args": ["--readonly"],
      "env": {
        "NOTION_TOKEN": "${env.NOTION_READONLY_TOKEN}"
      }
    }
  }
}
```

## Security Considerations

### Token Management
- Store Notion tokens in environment variables
- Use tokens with minimal required permissions
- Consider read-only tokens for syncing
- Rotate tokens periodically

### Permission Scopes
- **Read content:** View pages, databases, blocks
- **Update content:** Edit existing content
- **Insert content:** Create new pages/blocks
- **Comments:** Add/read comments

### Content Security
- Only connect necessary pages/databases
- Review integration access regularly
- Consider separate integrations for different security levels
- Use page-level permissions within Notion

### Secret Detection
The framework's `secret-detector.js` hook will detect:
- Notion integration tokens (`ntn_`)
- API keys in synced content
- Sensitive information in documentation

## Troubleshooting

### Common Issues

**"Notion token not found"**
```bash
# Check token is set
echo $NOTION_TOKEN

# Test token with curl
curl -H "Authorization: Bearer $NOTION_TOKEN" \
     -H "Notion-Version: 2022-06-28" \
     https://api.notion.com/v1/users/me
```

**"Page not accessible"**
```bash
# Verify page is connected to integration
# Check integration access settings

# Test page access
curl -H "Authorization: Bearer $NOTION_TOKEN" \
     -H "Notion-Version: 2022-06-28" \
     https://api.notion.com/v1/pages/PAGE_ID
```

**"MCP server connection failed"**
```bash
# Test local server
notion-mcp-server --version

# Check for remote MCP availability
# Visit: https://developers.notion.com/docs/mcp
```

### Version Compatibility
- **v2.0.0+:** Uses data sources instead of databases
- **Migration:** Automatic for MCP tools
- **Backward compatibility:** `retrieve-a-database` still works
- **Check version:** `notion-mcp-server --version`

## Expected Benefits

### Documentation Awareness
- Notion docs automatically linked to project memory
- Real-time documentation updates
- Cross-reference between code and docs

### Workflow Integration
- Automatic doc creation from `/add-feature`
- Documentation sync in `/project-status`
- Onboarding docs in `/onboard`

### Token Reduction
By syncing Notion context to memory:
- **~6× reduction** in tokens for documentation queries
- Persistent documentation context between sessions
- Faster page/database lookups

### Collaboration Enhancement
- Team documentation always in sync
- Single source of truth for project docs
- Reduced context switching between tools

## Installation Verification

```bash
# Test Notion connection
notion-mcp-server --test-connection

# Test skill integration
/mcp-notion search "test"
```

## Important Notes

### Current Status (April 2026)
- **Official Notion MCP server available** (`@notionhq/notion-mcp-server@2.2.1`)
- **Remote MCP recommended** for easiest setup
- **22 tools available** for comprehensive integration
- **Data sources** replace databases in v2.0.0+

### Package Details
- **Official package:** `@notionhq/notion-mcp-server@2.2.1`
- **License:** MIT
- **Maintained by:** Notion team
- **GitHub:** `github.com/makenotion/notion-mcp-server`

### Remote vs Local
- **Remote MCP:** Easier setup, OAuth, Notion-hosted
- **Local MCP:** More control, self-hosted, 22 tools
- **Recommendation:** Start with remote, move to local if needed

### Production Considerations
- Test integration in non-production workspace first
- Review connected content permissions
- Monitor API rate limits (3 requests/second)
- Backup important documentation independently

---

*Dernière mise à jour: 2026-04-15 - Phase 4: Intégration MCP Notion (serveur officiel disponible)*