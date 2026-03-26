# Commit format

Use the Conventional Commits format:

type(scope): short description

Allowed types:
- feat     : new feature
- fix      : bug fix
- docs     : documentation only
- refactor : refactoring without behavior change
- test     : adding or modifying tests
- chore    : maintenance, dependencies, config

Examples:
feat(auth): add refresh token endpoint
fix(api): fix pagination on empty notes
docs(readme): update installation instructions
test(auth): add token revocation tests

Rules:
- Description in lowercase, no trailing period
- Maximum 72 characters
- Commit body in English if needed
