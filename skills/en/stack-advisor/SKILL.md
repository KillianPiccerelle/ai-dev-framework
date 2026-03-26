---
name: stack-advisor
description: >
  Recommends a technical stack suited to the current project.
  Reads memory/project-context.md and produces memory/stack.md.
  Invoke with /stack-advisor at project start.
tags: [architecture, stack, setup]
---

Read memory/project-context.md before starting.

Ask the user these questions if answers are not in the context:
- What type of application? (SaaS, pure API, AI app, fullstack, mobile backend)
- What performance constraints? (latency, data volume, concurrent users)
- What are the team's technical skills?
- What is the estimated monthly infrastructure budget?
- What is the target date for v1?

Once information is collected, apply the decision matrix described
in the stack-advisor agent and produce memory/stack.md with this format:

# Technical Stack — [Project Name]

## Summary of choices

| Layer | Choice | Main reason |
|-------|--------|-------------|
| Runtime | ... | ... |
| Framework | ... | ... |
| Database | ... | ... |
| Auth | ... | ... |
| Tests | ... | ... |
| Deployment | ... | ... |

## Decision details

### [Layer]
Retained choice: [technology]
Justification: [why this choice fits THIS project]
Rejected alternatives: [what was considered and why it was discarded]

[Repeat for each layer]

## Points of attention
[Risks or decisions to reconsider if context changes]
