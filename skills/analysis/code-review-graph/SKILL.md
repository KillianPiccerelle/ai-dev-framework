---
name: code-review-graph
description: >
  [À IMPLÉMENTER] Analyze codebase structure and impact radius using code-review-graph plugin.
  Builds persistent structural map to identify minimal set of files affected by changes.
tags: [analysis, review, structure, impact]
---

**⚠️ EN CONSTRUCTION - Intégration prévue pour la prochaine version**

Ce skill intégrera le plugin code-review-graph qui promet 6.8× moins de tokens en review en analysant uniquement les fichiers impactés par un changement.

## Fonctionnalités prévues

1. **build** — Build structural graph of entire codebase
2. **update** — Incremental update of changed files only  
3. **impact** — Analyze impact radius of specific changes
4. **visualize** — Generate interactive HTML visualization

## Dépendances
- code-review-graph plugin (pip install code-review-graph)
- Python ≥3.10
- Accès MCP configuré

## Statut
L'intégration est planifiée selon la roadmap dans FRAMEWORK_CONTEXT.md. Le skill sera pleinement fonctionnel après:
- Test du plugin sur wave-agent-build
- Intégration dans l'agent code-reviewer
- Validation de la réduction de tokens

---

*Dernière mise à jour: 2026-04-13 - Intégration oh-my-mermaid terminée, code-review-graph en préparation*