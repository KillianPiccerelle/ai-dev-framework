# Commit format

Conventional Commits format: type(scope): description

Allowed types:
- feat     : new feature
- fix      : bug fix
- docs     : documentation only
- refactor : refactoring without behavior change
- test     : adding or modifying tests
- chore    : maintenance, dependencies, config

Examples:
feat(auth): add refresh token endpoint
fix(api): fix pagination on empty results
docs(readme): update installation instructions
test(auth): add token revocation tests

Rules:
- Lowercase description, no trailing period
- Max 72 characters
