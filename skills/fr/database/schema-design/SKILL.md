---
name: schema-design
description: >
  Conçoit un schéma de base de données normalisé à partir des besoins fonctionnels.
  Produit le schéma et les explications. À invoquer avant d'écrire les migrations.
tags: [database, schema, architecture]
---

Lis memory/project-context.md pour comprendre les entités métier.
Lis memory/stack.md pour connaître la base de données cible.

Processus en trois étapes :

1. IDENTIFIER les entités à partir du contexte métier.
   Lister toutes les "choses" dont le système a besoin de garder une trace.

2. DÉFINIR les relations entre entités.
   Pour chaque relation : one-to-one, one-to-many, many-to-many ?
   Les many-to-many nécessitent une table de jonction.

3. NORMALISER jusqu'à la 3ème forme normale.
   Vérifier : pas de données dupliquées, chaque attribut dépend
   uniquement de la clé primaire.

Conventions à appliquer :
- Clés primaires : UUID v4 (pas d'entier auto-incrémenté)
- Timestamps : created_at et updated_at sur toutes les tables
- Soft delete : deleted_at nullable (ne jamais supprimer physiquement)
- Nommage : snake_case pour les colonnes, pluriel pour les tables

Pour chaque table, documenter : l'objectif de la table, les index nécessaires,
les contraintes de clé étrangère avec leur comportement ON DELETE.

Produire un diagramme ASCII des relations entre tables.
