---
name: jwt-auth
description: >
  Implémente une authentification JWT stateless complète : login,
  refresh token, logout, middleware de validation.
tags: [auth, security, api]
---

Lis memory/stack.md avant de commencer pour adapter l'implémentation à la stack du projet.

Ce skill produit quatre éléments :
1. Route POST /auth/login → retourne access_token (15min) + refresh_token
2. Route POST /auth/refresh → renouvelle l'access_token
3. Route POST /auth/logout → invalide le refresh_token en base
4. Middleware de validation pour les routes protégées

Règles de sécurité non négociables :
- access_token : durée maximale 15 minutes
- refresh_token : stocké hashé en base (bcrypt/argon2), révocable individuellement
- Tokens transmis via httpOnly cookies uniquement, jamais localStorage
- Algorithme JWT explicitement validé (rejeter "none")

Structure de la table refresh_tokens :
id, user_id (FK), token_hash, expires_at, created_at, revoked_at (nullable)

Tests à écrire (par test-engineer, avant l'implémentation) :
- Login credentials valides → 200 + tokens
- Login mauvais mot de passe → 401
- Login utilisateur inexistant → 401 (même message)
- Route protégée, token valide → 200
- Route protégée, token expiré → 401
- Route protégée, pas de token → 401
- Refresh token valide → 200 + nouveaux tokens
- Refresh token révoqué → 401
- Logout → 200 + révocation en base
- Route protégée après logout → 401

Après implémentation, mettre à jour memory/conventions/auth.md.
