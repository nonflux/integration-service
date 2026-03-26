# Fix Review Feedback

Address PR review comments and push fixes.

## Steps

1. Read all review comments: `gh pr view <number> --json reviews,comments`
2. Read inline comments: `gh api repos/{owner}/{repo}/pulls/<number>/comments`
3. For each comment:
   - Understand what the reviewer is asking
   - Make the requested change
   - If you disagree, reply explaining why (do NOT silently ignore)
4. Run `make test` — verify fixes don't break anything
5. Run `make lint` — verify style
6. Stage and commit: `git add -A && git commit -s -m "fix: address review feedback"`
7. Push to the PR branch

## Constraints

- Address ALL review comments — do not skip any
- Do not make unrelated changes in the same commit
- If a comment is unclear, reply asking for clarification
- Preserve existing test coverage
