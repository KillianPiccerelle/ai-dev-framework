# Guide de migration : v2 → v3

## Ce qui change en v3

### Simplification de la structure
- **Avant (v2)** : agents/fr/, agents/en/, workflows/fr/, workflows/en/
- **Après (v3)** : agents/, workflows/ (anglais uniquement, source unique)
- **Docs** : toujours bilingues dans docs/fr/ et docs/en/

### Nouveaux agents
- `codebase-analyst` — analyse approfondie du repo, supporte les autres agents
- `qa-engineer` — tests avancés, edge cases, détection de sécurité

### Nouveaux workflows
- `/map-project` — génère docs/project-map.md
- `/project-status` — rapport de santé et de progression
- `/upgrade-framework` — migration non-destructive depuis v1/v2

### Nouveau template
- `ai-app` — applications IA avec règles spécifiques LLM

## Migration automatique

La façon la plus simple de migrer un projet :

```bash
cd mon-projet
~/ai-dev-framework/scripts/init-project.sh
claude
/upgrade-framework
```

Le workflow /upgrade-framework gère tout de façon non-destructive.

## Ce qui est préservé
- Toutes les règles personnalisées dans CLAUDE.md
- Tous les fichiers memory/ (project-context, stack, decisions, conventions)
- Tous les workflows personnalisés
- Tous les agents personnalisés
- Tout le code source (jamais touché)
