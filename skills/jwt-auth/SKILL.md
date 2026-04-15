---
name: jwt-auth
description: >
  Implements complete stateless JWT authentication: login, refresh token,
  logout, validation middleware.
tags: [auth, security, api]
---

Read memory/stack.md before starting to adapt to the project stack.

Produces:
1. POST /auth/login → access_token (15min) + refresh_token
2. POST /auth/refresh → renews access_token
3. POST /auth/logout → invalidates refresh_token in DB
4. Validation middleware for protected routes

Security rules (non-negotiable):
- access_token: max 15 minutes
- refresh_token: stored hashed (bcrypt/argon2), individually revocable
- httpOnly cookies only, never localStorage
- Explicitly validate algorithm (reject "none")

refresh_tokens table: id, user_id (FK), token_hash, expires_at, created_at, revoked_at

Tests to write before implementing:
- Valid login → 200 + tokens
- Wrong password → 401
- Non-existent user → 401 (same message)
- Protected route, valid token → 200
- Protected route, expired token → 401
- Protected route, no token → 401
- Valid refresh → 200 + new tokens
- Revoked refresh → 401
- Logout → 200 + revoked in DB
- Protected route after logout → 401
