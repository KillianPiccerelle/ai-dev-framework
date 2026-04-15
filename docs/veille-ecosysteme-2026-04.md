# Veille — Écosystème Claude Code & Outils IA Dev (Avril 2026)

> Fichier consolidé, dédupliqué, annoté.
> Statut d'intégration dans ai-dev-framework v3 indiqué pour chaque ressource.

---

## Légende

| Emoji | Verdict |
|-------|---------|
| ✅ | Déjà intégré dans le framework |
| 🔜 | À intégrer — action planifiée |
| 🔌 | Plugin externe à référencer (pas d'intégration directe) |
| 📚 | Référence / inspiration — pas d'intégration |
| ⏳ | À surveiller — pas mûr ou pas pertinent maintenant |
| ❌ | Non pertinent — hors scope ou doublon |

---

## 1. CONTEXTE & ANALYSE CODEBASE

### Repomix
- **URL** : https://github.com/yamadashy/repomix
- **Stars** : ~22.7k
- **Description** : Pack un repo entier en un seul fichier optimisé LLM. Tree-sitter compression (~70% réduction tokens). CLI + web + Chrome extension. Remote repos supportés.
- **Statut** : ✅ **Intégré** — skill `/repomix` créé (v3.1.0)

### LightRAG
- **URL** : https://github.com/hkuds/lightrag
- **Stars** : ~27.6k
- **Description** : RAG basé sur graphes de connaissances. Extrait entités et relations, construit un knowledge graph, retrieval multi-modal. Support PostgreSQL, Neo4j, MongoDB, Redis.
- **Analyse** : Très lourd (service standalone + BDD + pipeline d'ingestion). Pertinent uniquement sur codebases 500k+ lignes. Incompatible avec l'approche portable du framework.
- **Statut** : ❌ **Non pertinent** pour le framework — infrastructure trop lourde

### code-review-graph
- **URL** : https://github.com/tirth8205/code-review-graph
- **Description** : Analyse structurelle du codebase, réduction 6.8× des tokens pour les reviews via graphe de dépendances.
- **Statut** : ✅ **Déjà intégré** — skill `/code-review-graph` + intégration `code-reviewer`

---

## 2. MÉMOIRE & PERSISTANCE

### Karpathy — LLM Wiki Pattern
- **URL** : https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- **Description** : Pattern architectural : les LLMs maintiennent un wiki Markdown persistant mis à jour incrémentalement plutôt que de re-dériver la connaissance à chaque requête. 3 opérations : Ingest (sources → wiki), Query (recherche + filing), Lint (détection contradictions, stale claims, orphaned pages).
- **Analyse** : Directement applicable au système `memory/` du framework. Le "Lint" est particulièrement précieux : détecter les entrées memory/ obsolètes, contradictoires ou orphelines. C'est exactement le gap dans notre `/project-status`.
- **Statut** : 🔜 **À intégrer** — ajouter une opération "memory lint" dans `/project-status`

### Claude Mem
- **URL** : https://github.com/thedotmack/claude-mem
- **Description** : Mémoire persistante entre sessions Claude Code.
- **Statut** : ❌ **Non pertinent** — couvert par `memory/` + `session-save.js`

### Claude Session Restore
- **URL** : https://github.com/ZENG3LD/claude-session-restore
- **Description** : Restauration de sessions Claude Code.
- **Statut** : ❌ **Non pertinent** — couvert par `memory/` + `session-save.js`

### Basic Memory (MCP)
- **URL** : dans hesreallyhim/awesome-claude-code
- **Description** : Communication bidirectionnelle LLM-markdown via MCP. Markdown comme couche de connaissance structurée que les agents lisent et écrivent.
- **Analyse** : Concept proche de notre `memory/` mais via protocole MCP. Intéressant si on voulait exposer `memory/` via MCP pour des outils externes.
- **Statut** : ⏳ **À surveiller** — pertinent si on fait un `/mcp-memory` plus tard

---

## 3. QUALITÉ & MONITORING

### cc-lens
- **URL** : https://github.com/Arindam200/cc-lens
- **Description** : Dashboard analytics local pour Claude Code. Sessions, tokens, coûts estimés, session replay, activity calendars, tool rankings. 100% local, aucune télémétrie.
- **Analyse** : Outil de monitoring excellent pour comprendre l'utilisation du framework. Pas d'intégration directe mais à mentionner comme companion tool dans la doc.
- **Statut** : 🔌 **Plugin externe** — référencer dans `docs/`

### ccxray
- **URL** : dans hesreallyhim/awesome-claude-code
- **Description** : Proxy HTTP transparent entre Claude Code et l'API Anthropic. Dashboard temps réel : token tracking, cost tracking, visualisation de la context window.
- **Analyse** : Très utile pour debugger les agents et optimiser les coûts. Companion tool, pas d'intégration framework.
- **Statut** : 🔌 **Plugin externe** — référencer dans `docs/`

### agenttop
- **URL** : https://github.com/vicarious11/agenttop
- **Description** : Dashboard de monitoring pour agents AI, style `top` Unix.
- **Statut** : ⏳ **À surveiller** — concept intéressant, maturité incertaine

### openlogs.dev
- **URL** : https://openlogs.dev
- **Description** : Monitoring d'agents en auto-hébergé.
- **Statut** : ⏳ **À surveiller**

---

## 4. SKILLS & COLLECTIONS

### Everything Claude Code
- **URL** : https://github.com/affaan-m/everything-claude-code
- **Stars** : ~128k
- **Description** : 30 agents, 136 skills, 60 slash commands. Skills sécurité : security-review, security-scan, django-security, laravel-security, springboot-security. Instincts, multi-langage.
- **Statut** : ✅ **Utilisé** — patterns sécurité extraits et appliqués à `security-reviewer` (v3.1.0)

### UI UX Pro Max
- **URL** : https://github.com/nextlevelbuilder/ui-ux-pro-max-skill
- **Description** : 50+ styles, 161 palettes de couleurs, 99 guidelines UX. Force Claude à produire des UI professionnelles.
- **Statut** : ✅ **Intégré** — skill `/ui-design` créé (v3.1.0)

### Superpowers
- **URL** : https://github.com/obra/superpowers
- **Description** : Force Claude à adopter une pensée structurée et vérifier avant d'agir. Règles clés : vérifier le problème est réel, confirmer le scope, ne pas implémenter ce qui n'a pas été demandé.
- **Statut** : ✅ **Utilisé** — patterns appliqués à `backend-dev` et `frontend-dev` (v3.1.0)

### agnix
- **URL** : dans hesreallyhim/awesome-claude-code
- **Description** : Linter pour fichiers de configuration agent (CLAUDE.md, AGENTS.md, SKILL.md) avec auto-fixes. Détecte erreurs de typo, chemins invalides, incohérences.
- **Analyse** : Directement applicable à `ai-framework doctor` — ajouter validation des fichiers agents/skills/workflows.
- **Statut** : 🔜 **À intégrer** — enrichir `scripts/doctor.sh` avec validation des fichiers framework

### Ralph Orchestrator (circuit breaker)
- **URL** : dans hesreallyhim/awesome-claude-code
- **Description** : Orchestrateur avec circuit breaker patterns et rate limiting pour éviter les boucles infinies d'agents. Safeguards de production.
- **Analyse** : Pattern à appliquer à l'agent `orchestrator` — limiter les itérations, détecter les boucles.
- **Statut** : 🔜 **À intégrer** — ajouter safeguards à `agents/orchestrator.md`

### Awesome Claude Code (hesreallyhim)
- **URL** : https://github.com/hesreallyhim/awesome-claude-code
- **Description** : Community bible — skills curatés, hooks, slash commands, orchestrateurs. Contient ccxray, agnix, Ralph, Claude Code Infrastructure Showcase.
- **Statut** : 📚 **Référence** — annuaire de référence

### Antigravity Awesome Skills
- **URL** : https://github.com/sickn33/antigravity-awesome-skills
- **Description** : 1200+ skills prêts à l'emploi. Qualité variable.
- **Statut** : 📚 **Référence** — catalogue à consulter ponctuellement

### Claude Skills (alirezarezvani)
- **URL** : https://github.com/alirezarezvani/claude-skills
- **Description** : Collection de skills orientée productivité développeur.
- **Statut** : 📚 **Référence**

### Awesome Claude Skills (ComposioHQ)
- **URL** : https://github.com/ComposioHQ/awesome-claude-skills
- **Description** : 9000+ repos indexés avec métriques d'adoption.
- **Statut** : 📚 **Référence** — annuaire avec métriques d'adoption

### Awesome Claude Skills (travisvn)
- **URL** : https://github.com/travisvn/awesome-claude-skills
- **Description** : Liste curatée complémentaire.
- **Statut** : 📚 **Référence**

### Awesome Claude Code Toolkit (rohitg00)
- **URL** : https://github.com/rohitg00/awesome-claude-code-toolkit
- **Description** : Collection curatée d'outils pour Claude Code.
- **Statut** : 📚 **Référence**

### HolyClaude (CoderLuii)
- **URL** : https://github.com/CoderLuii/HolyClaude
- **Description** : Collection de ressources Claude Code. (Repo introuvable au moment de la veille.)
- **Statut** : ⏳ **À vérifier** — URL à reconfirmer

---

## 5. AGENTS & MULTI-AGENTS

### ClawTeam (HKUDS)
- **URL** : https://github.com/HKUDS/ClawTeam
- **Description** : Framework CLI de coordination d'agents en swarm. Leader spawne des workers avec git worktrees isolés + fenêtres tmux. Dépendances entre tâches, messaging inter-agents, zéro orchestration humaine. Fonctionne avec Claude Code, Codex, agents custom.
- **Analyse** : Alternative concrète aux cmux/gmux. Plus mature et orienté dev. La notion de git worktrees isolés par agent est très propre. Pertinent pour Phase 6 si on veut des workflows vraiment parallèles.
- **Statut** : 🔜 **À évaluer** — candidat sérieux pour workflows parallèles (Phase 6)

### My Brain Is Full Crew
- **URL** : https://github.com/gnekt/My-Brain-Is-Full-Crew
- **Description** : 8 agents AI pour Obsidian vault : Architect, Scribe, Sorter, Seeker, Connector, Librarian, Transcriber, Postman. Communication inter-agents. 100% local, MIT.
- **Analyse** : Pattern de communication inter-agents inspirant pour l'`orchestrator`. Centré Obsidian — pas d'intégration directe.
- **Statut** : 📚 **Référence** — pattern crew pour enrichir l'orchestrator

### Claude Agent Blueprints (danielrosehill)
- **URL** : https://github.com/danielrosehill/Claude-Code-Repos-Index
- **Description** : 75+ templates de workspaces agents au-delà du coding.
- **Statut** : 📚 **Référence**

### VoiceMode MCP
- **URL** : https://github.com/mbailey/voicemode-mcp
- **Description** : Conversations vocales avec Claude Code via Whisper + Kokoro.
- **Statut** : ⏳ **À surveiller** — hors scope actuellement

---

## 6. MCP (MODEL CONTEXT PROTOCOL)

### Anthropic Official MCP Servers
- **URL** : https://github.com/modelcontextprotocol/servers
- **Description** : Répertoire officiel : GitHub, Slack, Postgres, Puppeteer, et des centaines d'autres.
- **Statut** : ✅ **Utilisé** — source pour mcp-github, mcp-jira, mcp-notion

### n8n-MCP
- **URL** : https://github.com/czlonkowski/n8n-mcp
- **Description** : Connecte Claude Code à 400+ intégrations n8n via MCP. Méta-connecteur.
- **Analyse** : Redondant avec les skills mcp-github/jira/notion déjà créés. Ajoute une dépendance n8n lourde. Intéressant si on veut des intégrations au-delà de GitHub/Jira/Notion (Slack, email, webhooks).
- **Statut** : ⏳ **À surveiller** — pertinent si besoin de >3 intégrations MCP simultanées

### mcpfast.xyz
- **URL** : https://mcpfast.xyz
- **Description** : Community radar — agrège et classe les derniers MCP servers depuis GitHub, Twitter, HN, Reddit.
- **Statut** : 📚 **Référence** — à consulter pour suivre les nouveaux serveurs MCP

### Annuaires MCP
- **URLs** : mcp.so, pulsemcp.com, ecc.tools, mcpserverfinder.com
- **Description** : Annuaires communautaires de serveurs MCP.
- **Statut** : 📚 **Référence** — mcp.so et modelcontextprotocol/servers sont les plus complets

### Dokploy MCP
- **URL** : https://github.com/Dokploy/mcp
- **Description** : MCP server pour déployer des applications via Dokploy.
- **Analyse** : Intéressant pour enrichir `/setup-ci` avec une option de déploiement Dokploy (alternative à Railway/Fly.io/Vercel).
- **Statut** : ⏳ **À surveiller** — potentiel ajout dans `devops-engineer`

---

## 7. GUIDES & ARTICLES

### Anthropic — Harness Design for Long-Running Apps
- **URL** : https://www.anthropic.com/engineering/harness-design-long-running-apps
- **Description** : Patterns officiels Anthropic pour applications Claude longue durée. 6 patterns clés :
  1. Séparer génération et évaluation (agent dédié à l'évaluation)
  2. Context reset > compaction pour Sonnet (clean slate + structured handoff)
  3. Sprint-based decomposition (une feature à la fois)
  4. Pre-work contracts (définir le succès avant d'implémenter)
  5. File-based communication entre agents
  6. Supprimer les composants non load-bearing au fur et à mesure
- **Analyse** : Patterns directement applicables à nos workflows longs (`/add-feature`, `/refactor`). Le "pre-work contract" est le gap le plus évident dans `architect`.
- **Statut** : 🔜 **À appliquer** — enrichir `architect.md` + workflows `/add-feature` et `/refactor`

### Claude Code Best Practice (shanraisshan)
- **URL** : https://github.com/shanraisshan/claude-code-best-practice
- **Description** : Guide des meilleures pratiques pour utiliser Claude Code efficacement.
- **Statut** : 📚 **Référence**

### Claude Code Ultimate Guide (FlorianBruniaux)
- **URL** : https://github.com/FlorianBruniaux/claude-code-ultimate-guide
- **Description** : 23K+ lignes de docs, 219 templates, 271 quizzes. Débutant → power user.
- **Statut** : 📚 **Référence** — à mentionner dans `docs/` comme ressource d'apprentissage

### Awesome Claude Code (Karpathy gist — LLM Wiki)
- Voir section 2 ci-dessus.

---

## 8. DESIGN & DOCUMENTATION

### Awesome Design MD
- **URL** : https://github.com/VoltAgent/awesome-design-md
- **Description** : Patterns et styles pour fichiers Markdown. Templates de documentation.
- **Analyse** : Pourrait améliorer la qualité des outputs `memory/` et `docs/` générés par les agents.
- **Statut** : 📚 **Référence** — source d'inspiration pour templates `memory/`

### System Design Notes
- **URL** : https://github.com/liquidslr/system-design-notes
- **Description** : Notes structurées sur le system design (architecture distribuée, scalabilité, patterns).
- **Statut** : 📚 **Référence** — enrichir les ADR templates dans `memory/decisions/`

---

## 9. PLATEFORMES EXTERNES

### Supabase CLI
- **URL** : https://github.com/supabase/cli
- **Description** : CLI Supabase (BaaS open-source). Database, auth, storage, edge functions.
- **Statut** : 📚 **Référence** — à mentionner dans `/stack-advisor` comme option BaaS

### Public APIs
- **URL** : https://github.com/public-apis/public-apis
- **Description** : Liste massive d'APIs publiques gratuites classées par catégorie.
- **Statut** : 📚 **Référence** — ressource utile pendant `/new-project`

### Waza (tw93)
- **URL** : https://github.com/tw93/Waza
- **Description** : Collection générale de logiciels et outils curatés.
- **Statut** : ❌ **Non pertinent** — trop générique

### Vibeyard
- **URL** : https://github.com/elirantutia/vibeyard
- **Description** : Outil lié au "vibe coding". Maturité et scope incertains.
- **Statut** : ⏳ **À vérifier**

### NotebookLM-py
- **URL** : https://github.com/teng-lin/notebooklm-py
- **Description** : Implémentation Python de NotebookLM. Analyse de documents, génération de podcasts.
- **Statut** : ❌ **Non pertinent** — outil de recherche, hors scope

### LangChain
- **URL** : https://github.com/langchain-ai/langchain
- **Description** : Framework Python pour apps LLM. Chaînes, agents, RAG, tools.
- **Statut** : 📚 **Référence** — mentionné dans template `ai-app`

### Flowise
- **URL** : https://github.com/FlowiseAI/Flowise
- **Description** : Plateforme low-code pour workflows AI visuels.
- **Statut** : ❌ **Non pertinent** — approche visuelle vs. framework code-first

### Obsidian
- **URL** : https://github.com/obsidianmd
- **Description** : App de prise de notes Markdown. Conceptuellement proche du système `memory/`.
- **Statut** : 📚 **Référence** — inspiration pour enrichir `memory/`

### PolymathicAI — The Well
- **URL** : https://github.com/PolymathicAI/the_well
- **Description** : Dataset de simulations physiques pour ML scientifique.
- **Statut** : ❌ **Non pertinent** — hors scope total

---

## Résumé des actions par priorité

### 🔴 Priorité haute — impact direct sur la qualité du framework

| Action | Source | Effort |
|--------|--------|--------|
| Memory lint dans `/project-status` | Karpathy LLM Wiki | Moyen |
| Pre-work contracts dans `architect` + `/add-feature` | Anthropic Harness | Faible |
| Circuit breaker dans `orchestrator` | Ralph Orchestrator | Faible |
| Validation fichiers framework dans `doctor.sh` | agnix pattern | Moyen |

### 🟡 Priorité moyenne — nouvelles capacités

| Action | Source | Effort |
|--------|--------|--------|
| Évaluer ClawTeam pour workflows parallèles | ClawTeam | Élevé |
| Documenter cc-lens + ccxray comme companion tools | cc-lens / ccxray | Faible |
| Enrichir `devops-engineer` avec Dokploy | Dokploy MCP | Faible |

### 🟢 Priorité basse — à surveiller

| Ressource | Pourquoi surveiller |
|-----------|---------------------|
| n8n-MCP | Si besoin d'intégrations au-delà GitHub/Jira/Notion |
| VoiceMode MCP | Accessibilité si demandée |
| Basic Memory MCP | Si on expose `memory/` via MCP |
| agenttop / openlogs | Monitoring agents en production |

---

*Généré le 2026-04-15 — Veille ai-dev-framework v3.1.0*
