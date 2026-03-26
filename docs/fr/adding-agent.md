# Ajouter un agent au framework

## Structure d'un agent

Chaque agent est un fichier Markdown dans `agents/fr/` et `agents/en/`.

```
agents/
├── fr/
│   └── mon-agent.md
└── en/
    └── mon-agent.md
```

## Format du fichier

```markdown
---
name: mon-agent
description: >
  Description claire et concise. Explique ce que fait l'agent,
  dans quel contexte l'invoquer, et ce qu'il ne fait pas.
  Cette description est lue par Claude pour décider si l'agent est pertinent.
tools: [Read, Write, Edit, Bash, Grep, Glob]
model: sonnet
readonly: false
---

Instructions système de l'agent...
```

## Champs du frontmatter

**name** : identifiant unique, kebab-case, correspond au nom du fichier.

**description** : utilisée par Claude pour décider si l'agent est pertinent.
Doit répondre à : quand l'invoquer, ce qu'il produit, ce qu'il ne fait pas.

**tools** : liste des outils autorisés. Principe du moindre privilège :
n'accorder que ce qui est nécessaire.
- `Read` : lire des fichiers
- `Write` : créer des fichiers
- `Edit` : modifier des fichiers existants
- `Bash` : exécuter des commandes
- `Grep` : rechercher dans les fichiers
- `Glob` : lister des fichiers par pattern

**model** : `opus` pour les tâches complexes (architecture, décisions),
`sonnet` pour les tâches courantes, `haiku` pour les validations rapides.

**readonly** : `true` si l'agent ne doit jamais modifier de fichiers.

## Règles d'écriture

L'agent doit savoir quoi lire dans `memory/` avant d'agir.
L'agent doit savoir quoi produire et où le mettre.
L'agent doit avoir une règle claire sur ce qu'il ne fait pas.

## Publier après ajout

```bash
./scripts/publish.sh
```
