#!/bin/bash
set -e

# update-comment.sh - Post or update a GitHub comment in place with history
#
# Usage:
#   update-comment.sh <repo> <number> <marker> <content>
#   update-comment.sh <repo> <number> <marker> @<file>
#
# If content starts with @, it is read from the specified file path.

REPO=$1
NUMBER=$2
MARKER=$3
RAW_CONTENT=$4

if [ -z "$REPO" ] || [ -z "$NUMBER" ] || [ -z "$MARKER" ] || [ -z "$RAW_CONTENT" ]; then
  echo "Usage: $0 <repo> <number> <marker> <content|@file>"
  exit 1
fi

# Read content from file if prefixed with @
if [[ "$RAW_CONTENT" == @* ]]; then
  CONTENT_FILE="${RAW_CONTENT#@}"
  if [ ! -f "$CONTENT_FILE" ]; then
    echo "Error: File not found: $CONTENT_FILE" >&2
    exit 1
  fi
  NEW_CONTENT=$(cat "$CONTENT_FILE")
else
  NEW_CONTENT="$RAW_CONTENT"
fi

COMMENT_ID=$(gh api --paginate "repos/${REPO}/issues/${NUMBER}/comments" \
  --jq ".[] | select(.body | startswith(\"${MARKER}\")) | .id" | head -1)

if [ -n "$COMMENT_ID" ]; then
  OLD_BODY=$(gh api "repos/${REPO}/issues/comments/$COMMENT_ID" --jq '.body')
  OLD_CONTENT=$(printf "%s\n" "$OLD_BODY" | tail -n +2)
  printf '%s\n%s\n\n<details>\n<summary><b>Previous update</b></summary>\n\n%s\n\n</details>' \
    "$MARKER" "$NEW_CONTENT" "$OLD_CONTENT" > /tmp/update-comment-body.txt
  gh api "repos/${REPO}/issues/comments/$COMMENT_ID" -X PATCH -F body=@/tmp/update-comment-body.txt > /dev/null
else
  printf '%s\n%s' "$MARKER" "$NEW_CONTENT" > /tmp/update-comment-body.txt
  gh api "repos/${REPO}/issues/${NUMBER}/comments" -X POST -F body=@/tmp/update-comment-body.txt > /dev/null
fi
