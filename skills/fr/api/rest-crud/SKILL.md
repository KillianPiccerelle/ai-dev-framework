---
name: rest-crud
description: >
  Crée un endpoint REST complet (CRUD) pour une ressource donnée.
  Inclut validation, pagination, gestion d'erreurs, tests.
tags: [api, rest, crud]
---

Lis memory/stack.md pour identifier le framework HTTP et l'ORM utilisés.
Lis memory/conventions/error-handling.md pour le format des erreurs.

Ce skill produit pour une ressource [NOM] :

Routes :
- GET    /[ressources]           → liste paginée
- GET    /[ressources]/:id       → détail d'un élément
- POST   /[ressources]           → création
- PUT    /[ressources]/:id       → mise à jour complète
- DELETE /[ressources]/:id       → suppression

Pagination : cursor-based (plus robuste que offset), paramètres cursor et limit.
Format de réponse uniforme :
- Succès liste : { data: [...], nextCursor: "...", total: N }
- Succès élément : { data: {...} }
- Erreur : { error: { code: "...", message: "..." } }

Validation des inputs obligatoire sur POST et PUT.
Chaque route authentifiée vérifie les permissions avant d'agir.

Tests à produire :
- CRUD nominal (créer, lire, modifier, supprimer)
- Pagination (première page, page suivante, dernière page)
- Validation (champs manquants, types incorrects)
- Permissions (accès à une ressource d'un autre utilisateur → 403)
- Ressource inexistante → 404
