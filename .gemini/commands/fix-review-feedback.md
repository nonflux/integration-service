# Fix Review Feedback

Address PR review comments and push fixes.

## Steps

1. Read the review comments from `pr_comments.txt` in the root directory.
2. For each comment:
   - Understand what the reviewer is asking
   - Make the requested change
   - If you disagree, reply explaining why (do NOT silently ignore)
3. Stage and commit: `git add -A && git commit -s -m "fix: address review feedback"`
4. Push to the PR branch

## Posting Comments (In-Place Update with History)

When posting status updates on the PR, use the provided update-comment script:

```bash
.github/scripts/update-comment.sh "{owner}/{repo}" "<number>" "<!-- fullsend:fix-agent -->" "<your new content here>"
```

## Constraints

- Address ALL review comments — do not skip any
- Do not make unrelated changes in the same commit
- If a comment is unclear, reply asking for clarification
- Preserve existing test coverage
