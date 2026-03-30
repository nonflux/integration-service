# Triage Issue

Classify a GitHub issue and apply labels.

## Steps

1. Read the issue title, body, and comments from `issue_body.txt`
2. Determine the type: `kind/bug`, `kind/feature`, `kind/enhancement`, `kind/docs`, `kind/chore`
3. Determine the area: `area/controller`, `area/api`, `area/gitops`, `area/tekton`, `area/test`
4. Determine priority: `priority/critical`, `priority/high`, `priority/medium`, `priority/low`
5. Apply labels using `gh issue edit <number> --add-label <labels>`
6. If the issue has enough detail for implementation, also add `ready-for-implementation`
7. If the issue lacks detail, post a comment asking for clarification
8. Post a triage summary comment on the issue (see Posting Comments below)

## Posting Comments (In-Place Update with History)

When posting status updates on issues or PRs, use the provided update-comment script:

```bash
.github/scripts/update-comment.sh "{owner}/{repo}" "<number>" "<!-- fullsend:triage-agent -->" "<your new content here>"
```

## Constraints

- Do NOT modify any code files
- Do NOT create branches or PRs
- Only add labels and post comments
- If you cannot determine a category, use the most general option
