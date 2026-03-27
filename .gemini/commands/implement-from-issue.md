# Implement From Issue

Read a GitHub issue and implement the requested changes.

## Steps

1. Read the full issue from `issue_body.txt` in the root directory.
2. Understand what needs to be done — read referenced files if mentioned
3. Create a branch: `git checkout -b agent/<issue-number>-<short-desc>`
4. Plan the implementation:
   - Identify which files to modify or create
   - Check existing patterns in similar files
   - Determine what tests are needed
5. Implement the changes following GEMINI.md coding standards
6. Write or update tests for new/changed functionality
7. Stage and commit: `git add -A && git commit -s -m "<type>: <description>"`
8. Push branch: `git push origin agent/<issue-number>-<short-desc>`
9. Open PR: `gh pr create --title "<type>: <description>" --body "..."`
    - PR body must include: what changed, why, `Closes #<issue-number>`

## Posting Comments (In-Place Update with History)

When posting status updates on issues or PRs, use the provided update-comment script:

```bash
.github/scripts/update-comment.sh "{owner}/{repo}" "<number>" "<!-- fullsend:implementation-agent -->" "<your new content here>"
```

## Constraints

- Follow existing code patterns — read similar files before writing new code
- Keep changes focused on the issue scope
- Do not modify unrelated files
- If the issue is too large, implement the minimum viable change and note remaining work
