---
name: schema-design
description: >
  Designs a normalized database schema from functional requirements.
  Produces the schema and explanations. Invoke before writing migrations.
tags: [database, schema, architecture]
---

Read memory/project-context.md to understand business entities.
Read memory/stack.md to know the target database.

Three-step process:

1. IDENTIFY entities from business context.
   List all "things" the system needs to keep track of.

2. DEFINE relationships between entities.
   For each relationship: one-to-one, one-to-many, many-to-many?
   Many-to-many relationships require a junction table.

3. NORMALIZE to third normal form.
   Verify: no duplicated data, each attribute depends only on
   the primary key.

Conventions to apply:
- Primary keys: UUID v4 (not auto-incremented integers)
- Timestamps: created_at and updated_at on all tables
- Soft delete: nullable deleted_at (never physically delete)
- Naming: snake_case for columns, plural for tables

For each table, document: table purpose, necessary indexes,
foreign key constraints with their ON DELETE behavior.

Produce an ASCII diagram of relationships between tables.
