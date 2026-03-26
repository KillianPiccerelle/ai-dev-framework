---
name: schema-design
description: >
  Designs a normalized database schema from functional requirements.
  Produces schema with explanations. Invoke before writing migrations.
tags: [database, schema, architecture]
---

Read memory/project-context.md and memory/stack.md before starting.

Three-step process:
1. IDENTIFY entities from business context
2. DEFINE relationships (one-to-one, one-to-many, many-to-many)
3. NORMALIZE to third normal form

Conventions:
- Primary keys: UUID v4
- Timestamps: created_at, updated_at on all tables
- Soft delete: nullable deleted_at
- Naming: snake_case columns, plural tables

For each table: purpose, necessary indexes, FK constraints with ON DELETE behavior.
Produce ASCII diagram of table relationships.
