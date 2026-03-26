# Ajouter un agent au framework

## Structure d'un fichier agent

Créer agents/mon-agent.md avec ce format :

```markdown
---
name: mon-agent
description: >
  Description claire. Explique ce que fait l'agent, quand l'invoquer,
  et ce qu'il ne fait PAS. Cette description est lue par Claude pour
  décider si l'agent est pertinent pour une demande donnée.
tools: [Read, Write, Edit, Bash, Grep, Glob]
model: sonnet
readonly: false
---

Instructions système de l'agent...
```

## Champs du frontmatter

**name** : identifiant unique, kebab-case, correspond au nom du fichier.

**description** : utilisée par Claude pour évaluer la pertinence.
Doit répondre : quand l'invoquer, ce qu'il produit, ce qu'il évite.

**tools** : principe du moindre privilège — n'accorder que ce qui est nécessaire.

**model** : opus (tâches complexes), sonnet (standard), haiku (validations rapides).

**readonly** : true si l'agent ne doit jamais modifier de fichiers.

## Règles d'écriture

L'agent doit savoir quoi lire dans memory/ avant d'agir.
L'agent doit savoir quoi produire et où le mettre.
L'agent doit avoir une règle claire sur ce qu'il ne fait pas.

## Publier après ajout

```bash
./scripts/publish.sh
```
