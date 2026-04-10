---
name: stack-advisor
description: >
  Recommends a technical stack suited to the current project.
  Reads memory/project-context.md and produces memory/stack.md.
tags: [architecture, stack, setup]
---

Read memory/project-context.md before starting.

Ask if not in context: application type, performance constraints,
team skills, monthly infra budget, v1 target date.

Invoke the stack-advisor agent to analyze the context and produce the recommendation.
Produce memory/stack.md with this format:

# Technical Stack — [Project Name]

## Summary

| Layer | Choice | Main reason |
|-------|--------|-------------|
| Runtime | | |
| HTTP Framework | | |
| Database | | |
| Auth | | |
| Tests | | |
| Deployment | | |

## Decision details
For each layer: choice, justification, rejected alternatives.

## Points of attention
Risks or decisions to reconsider if context changes.
