---
name: oh-my-mermaid
description: >
  Generates interactive architecture diagrams using the oh-my-mermaid plugin.
  Scans codebase to produce visual diagrams in .omm/ folder.
tags: [architecture, diagrams, visualization]
---

Read memory/stack.md and memory/architecture.md before starting.

Three modes available:
1. **scan** (default) — Analyze codebase and generate diagrams in .omm/
2. **push** — Push diagrams to oh-my-mermaid cloud for sharing
3. **view** — Open local web viewer to explore diagrams

Usage: `/oh-my-mermaid [scan|push|view]`

The skill delegates to the installed oh-my-mermaid plugin commands:
- omm-scan → oh-my-mermaid scan
- omm-push → oh-my-mermaid push  
- omm-view → oh-my-mermaid view

Requires oh-my-mermaid plugin installed globally (~/.claude/plugins/).