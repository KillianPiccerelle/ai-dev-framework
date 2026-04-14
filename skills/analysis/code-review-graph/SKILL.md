---
name: code-review-graph
description: >
  Analyze codebase structure and impact radius using code-review-graph plugin.
  Builds persistent structural map to identify minimal set of files affected by changes.
tags: [analysis, review, structure, impact]
---

# Skill: code-review-graph

Integrates the code-review-graph plugin to reduce review tokens by 6.8× by analyzing only files impacted by changes.

## Commands

### `/code-review-graph build`
Builds a complete structural dependency graph of the entire codebase.

**Usage:**
```bash
# Build graph for current directory
/code-review-graph build

# Build with custom output directory
/code-review-graph build --output .code-review-graph/
```

**Output:**
- Creates `.code-review-graph/` directory with JSON graph files
- Generates visualizations in HTML format
- Reports token reduction estimate

### `/code-review-graph update`
Performs incremental update of the graph for changed files only.

**Usage:**
```bash
# Update graph with recent changes (git diff)
/code-review-graph update

# Update since specific commit
/code-review-graph update --since abc123
```

**Output:**
- Updates existing graph with minimal processing
- Reports files updated vs unchanged

### `/code-review-graph impact <path>`
Analyzes impact radius of specific file changes.

**Usage:**
```bash
# Analyze impact of single file
/code-review-graph impact src/app.js

# Analyze multiple files
/code-review-graph impact src/app.js src/utils.js

# Analyze with custom depth
/code-review-graph impact --depth 3 src/app.js
```

**Output:**
- List of directly impacted files
- List of indirectly impacted files (transitive dependencies)
- Token reduction estimate for review
- Visual impact graph

### `/code-review-graph visualize`
Generates interactive HTML visualization of the codebase structure.

**Usage:**
```bash
# Open visualization in browser
/code-review-graph visualize

# Generate static HTML file
/code-review-graph visualize --output viz.html
```

**Output:**
- Interactive force-directed graph in browser
- Searchable file dependency explorer
- Click-through navigation between files

## Dependencies
- `code-review-graph` plugin (`pip install code-review-graph`)
- Python ≥3.10
- Git repository (for incremental updates)
- Browser (for visualization)

## Integration Points

### In `map-project` workflow
After generating project map, ask: "Generate structural dependency graph with code-review-graph?"

### In `code-reviewer` agent
Before code review:
1. Check if `.code-review-graph/` exists
2. If not, offer to build graph
3. Use graph to identify minimal impacted files for review
4. Only review files in impact radius of changes

### In `add-feature` workflow
After implementing feature:
1. Run impact analysis on changed files
2. Validate no unexpected side effects
3. Update graph incrementally

## Workflow Example

```bash
# 1. Build initial graph
/code-review-graph build

# 2. Make changes to code
edit src/feature.js

# 3. Analyze impact
/code-review-graph impact src/feature.js

# 4. Review only impacted files (6.8× token reduction)
/code-reviewer --files impacted-files.txt

# 5. Update graph incrementally
/code-review-graph update
```

## Expected Token Reduction

| Codebase Size | Traditional Review | With code-review-graph | Reduction |
|---------------|-------------------|------------------------|-----------|
| 100 files     | ~100k tokens      | ~15k tokens            | 6.8×      |
| 500 files     | ~500k tokens      | ~74k tokens            | 6.8×      |
| 1000 files    | ~1M tokens        | ~147k tokens           | 6.8×      |

## Installation

```bash
# Install the plugin globally
pip install code-review-graph

# Verify installation
code-review-graph --version
```

## Notes
- First run (`build`) processes entire codebase (may take minutes)
- Subsequent runs (`update`) are incremental and fast
- Graph is persisted in `.code-review-graph/` directory
- Add `.code-review-graph/` to `.gitignore`

---

*Dernière mise à jour: 2026-04-14 - Intégration complète terminée*