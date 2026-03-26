---
name: jwt-auth
description: >
  Implements complete stateless JWT authentication: login,
  refresh token, logout, validation middleware.
tags: [auth, security, api]
---

Read memory/stack.md before starting to adapt implementation to the project stack.

This skill produces four elements:
1. POST /auth/login → returns access_token (15min) + refresh_token
2. POST /auth/refresh → renews the access_token
3. POST /auth/logout → invalidates the refresh_token in database
4. Validation middleware for protected routes

Non-negotiable security rules:
- access_token: maximum 15 minutes
- refresh_token: stored hashed in database (bcrypt/argon2), individually revocable
- Tokens via httpOnly cookies only, never localStorage
- JWT algorithm explicitly validated (reject "none")

refresh_tokens table structure:
id, user_id (FK), token_hash, expires_at, created_at, revoked_at (nullable)

Tests to write (by test-engineer, before implementation):
- Valid credentials login → 200 + tokens
- Wrong password login → 401
- Non-existent user login → 401 (same message)
- Protected route, valid token → 200
- Protected route, expired token → 401
- Protected route, no token → 401
- Valid refresh token → 200 + new tokens
- Revoked refresh token → 401
- Logout → 200 + revoked in database
- Protected route after logout → 401

After implementation, update memory/conventions/auth.md.
