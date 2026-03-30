#!/bin/bash
set -e

REPO=$1
PR_NUMBER=$2
MARKER=$3
NEW_CONTENT=$4

if [ -z "$REPO" ] || [ -z "$PR_NUMBER" ] || [ -z "$MARKER" ] || [ -z "$NEW_CONTENT" ]; then
  echo "Usage: $0 <repo> <pr_number> <marker> <new_content>"
  exit 1
fi

COMMENT_ID=$(gh api --paginate "repos/${REPO}/issues/${PR_NUMBER}/comments" \
  --jq ".[] | select(.body | startswith(\"${MARKER}\")) | .id" | head -1)

if [ -n "$COMMENT_ID" ]; then
  OLD_BODY=$(gh api --paginate "repos/${REPO}/issues/comments/$COMMENT_ID" --jq '.body')
  OLD_CONTENT=$(printf "%s\n" "$OLD_BODY" | tail -n +2)
  printf -v BODY '%s\n%s\n\n<details>\n<summary><b>Previous update</b></summary>\n\n%s\n\n</details>' \
    "$MARKER" "$NEW_CONTENT" "$OLD_CONTENT"
  gh api --paginate "repos/${REPO}/issues/comments/$COMMENT_ID" -X PATCH -f body="$BODY" > /dev/null
else
  printf -v BODY '%s\n%s' "$MARKER" "$NEW_CONTENT"
  gh issue comment "${PR_NUMBER}" --repo "${REPO}" --body "$BODY" > /dev/null
fi
