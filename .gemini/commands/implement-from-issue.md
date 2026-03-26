# Implement From Issue

Read a GitHub issue and implement the requested changes.

## Steps

1. Read the full issue with `gh issue view <number>`
2. Understand what needs to be done — read referenced files if mentioned
3. Create a branch: `git checkout -b agent/<issue-number>-<short-desc>`
4. Plan the implementation:
   - Identify which files to modify or create
   - Check existing patterns in similar files
   - Determine what tests are needed
5. Implement the changes following GEMINI.md coding standards
6. Write or update tests for new/changed functionality
7. Run `make test` — fix any failures
8. Run `make lint` — fix any style issues
9. Stage and commit: `git add -A && git commit -s -m "<type>: <description>"`
10. Push branch: `git push origin agent/<issue-number>-<short-desc>`
11. Open PR: `gh pr create --title "<type>: <description>" --body "..."`
    - PR body must include: what changed, why, `Closes #<issue-number>`

## Constraints

- Follow existing code patterns — read similar files before writing new code
- Keep changes focused on the issue scope
- Do not modify unrelated files
- If `make test` or `make lint` fail, fix the issues before committing
- If the issue is too large, implement the minimum viable change and note remaining work
