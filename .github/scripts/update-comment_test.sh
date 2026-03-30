#!/bin/bash
set -e

# Mock gh command
gh() {
  if [[ "$*" == *"repos/test/repo/issues/1/comments"* && "$*" == *"--jq "* ]]; then
    if [[ "$*" != *"--paginate"* ]]; then
      echo "ERROR: --paginate flag missing" >&2
      exit 1
    fi
    if [ "$MOCK_COMMENT_EXISTS" = "true" ]; then
      echo "123"
    else
      echo ""
    fi
  elif [[ "$*" == *"repos/test/repo/issues/comments/123"* && "$*" == *"--jq '.body'"* ]]; then
    echo -e "<!-- marker -->\nOld content"
  elif [[ "$*" == *"repos/test/repo/issues/comments/123"* && "$*" == *"-X PATCH"* ]]; then
    echo "PATCH called" >&2
  elif [[ "$*" == *"repos/test/repo/issues/1/comments"* && "$*" == *"-X POST"* ]]; then
    echo "POST called" >&2
  fi
}
export -f gh

echo "Running update-comment tests..."

# Test 1: New comment
export MOCK_COMMENT_EXISTS=false
OUTPUT=$(./.github/scripts/update-comment.sh "test/repo" "1" "<!-- marker -->" "New comment" 2>&1)
if ! echo "$OUTPUT" | grep -q "POST called"; then
  echo "Test 1 Failed: Expected POST but got '$OUTPUT'"
  exit 1
fi
echo "Test 1 Passed"

# Test 2: Update comment
export MOCK_COMMENT_EXISTS=true
OUTPUT=$(./.github/scripts/update-comment.sh "test/repo" "1" "<!-- marker -->" "New comment" 2>&1)
if ! echo "$OUTPUT" | grep -q "PATCH called"; then
  echo "Test 2 Failed: Expected PATCH but got '$OUTPUT'"
  exit 1
fi
echo "Test 2 Passed"

echo "All tests passed!"
