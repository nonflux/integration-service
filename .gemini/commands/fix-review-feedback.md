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

## Posting Comments (In-Place Update with History)

When posting status updates on the PR, update your previous comment in place
and collapse the old content into a `<details>` block. Use the marker `<!-- fullsend:fix-agent -->`.

1. Find your existing comment:
   ```
   COMMENT_ID=$(gh api "repos/{owner}/{repo}/issues/<number>/comments" \
     --jq '.[] | select(.body | startswith("<!-- fullsend:fix-agent -->")) | .id' | head -1)
   ```
2. If found, fetch the old body, collapse it, and update:
   ```
   OLD_BODY=$(gh api "repos/{owner}/{repo}/issues/comments/$COMMENT_ID" --jq '.body')
   # Strip the marker line from old body for the collapsed section
   OLD_CONTENT=$(echo "$OLD_BODY" | tail -n +2)
   NEW_BODY="<!-- fullsend:fix-agent -->
   <your new content here>

   <details>
   <summary><b>Previous update</b></summary>

   ${OLD_CONTENT}

   </details>"
   gh api "repos/{owner}/{repo}/issues/comments/$COMMENT_ID" -X PATCH -f body="$NEW_BODY"
   ```
3. If not found, create a new comment:
   ```
   gh pr comment <number> --body "<!-- fullsend:fix-agent -->
   <your content here>"
   ```

## Constraints

- Address ALL review comments — do not skip any
- Do not make unrelated changes in the same commit
- If a comment is unclear, reply asking for clarification
- Preserve existing test coverage
