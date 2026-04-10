---
name: env-setup
description: >
  Scans all source files for environment variable references and generates
  a complete, commented .env.example. Invoke the devops-engineer agent.
tags: [devops, environment, configuration]
---

Read memory/stack.md before starting to identify the runtime and framework.

Invoke the devops-engineer agent to:

1. Scan all source files for environment variable references:
   - Node.js: process.env.VAR_NAME
   - Python: os.environ.get('VAR_NAME'), os.getenv('VAR_NAME'), config('VAR_NAME')
   - Any config loader pattern present in the codebase

2. Deduplicate and sort findings by concern group.

Produce .env.example with this structure:

```
# ── Database ──────────────────────────────────────────────────
DATABASE_URL=          # PostgreSQL connection string. Format: postgresql://user:pass@host:5432/db
DB_POOL_SIZE=          # Connection pool size. Default: 10

# ── Auth ──────────────────────────────────────────────────────
JWT_SECRET=            # Random string min 32 chars. Generate: openssl rand -hex 32
JWT_EXPIRES_IN=        # Token lifetime. Example: 15m

# ── External APIs ─────────────────────────────────────────────
STRIPE_SECRET_KEY=     # From Stripe dashboard → Developers → API keys
STRIPE_WEBHOOK_SECRET= # From Stripe dashboard → Webhooks → signing secret

# ── App ───────────────────────────────────────────────────────
PORT=3000              # HTTP port the server listens on
NODE_ENV=development   # development | production | test
```

Rules:
- Every variable present, none with real values
- Each variable commented: what it is, where to get it, accepted format or example
- Groups separated by a comment header
- Variables only referenced in tests go in a separate # ── Test ── group
