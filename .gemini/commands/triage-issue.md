# Triage Issue

Classify a GitHub issue and apply labels.

## Steps

1. Read the issue title and body using `gh issue view <number>`
2. Determine the type: `kind/bug`, `kind/feature`, `kind/enhancement`, `kind/docs`, `kind/chore`
3. Determine the area: `area/controller`, `area/api`, `area/gitops`, `area/tekton`, `area/test`
4. Determine priority: `priority/critical`, `priority/high`, `priority/medium`, `priority/low`
5. Apply labels using `gh issue edit <number> --add-label <labels>`
6. If the issue has enough detail for implementation, also add `ready-for-implementation`
7. If the issue lacks detail, post a comment asking for clarification
8. Post a triage summary comment on the issue (see Posting Comments below)

## Posting Comments (In-Place Update with History)

When posting comments on the issue, update your previous comment in place
and collapse the old content into a `<details>` block. Use the marker `<!-- fullsend:triage-agent -->`.

1. Find your existing comment:
   ```
   COMMENT_ID=$(gh api "repos/{owner}/{repo}/issues/<number>/comments" \
     --jq '.[] | select(.body | startswith("<!-- fullsend:triage-agent -->")) | .id' | head -1)
   ```
2. If found, fetch the old body, collapse it, and update:
   ```
   OLD_BODY=$(gh api "repos/{owner}/{repo}/issues/comments/$COMMENT_ID" --jq '.body')
   OLD_CONTENT=$(echo "$OLD_BODY" | tail -n +2)
   NEW_BODY="<!-- fullsend:triage-agent -->
   <your new content here>

   <details>
   <summary><b>Previous update</b></summary>

   ${OLD_CONTENT}

   </details>"
   gh api "repos/{owner}/{repo}/issues/comments/$COMMENT_ID" -X PATCH -f body="$NEW_BODY"
   ```
3. If not found, create a new comment:
   ```
   gh issue comment <number> --body "<!-- fullsend:triage-agent -->
   <your content here>"
   ```

## Constraints

- Do NOT modify any code files
- Do NOT create branches or PRs
- Only add labels and post comments
- If you cannot determine a category, use the most general option
