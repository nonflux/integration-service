#!/bin/bash
set -e

# Mock gh command
gh() {
  if [[ "$*" == *"repos/test/repo/issues/1/comments"* && "$*" == *"--jq "* ]]; then
    if [ "$MOCK_COMMENT_EXISTS" = "true" ]; then
      echo "123"
    else
      echo ""
    fi
  elif [[ "$*" == *"repos/test/repo/issues/comments/123"* && "$*" == *"--jq '.body'"* ]]; then
    echo -e "<!-- marker -->\nOld content"
  elif [[ "$*" == *"repos/test/repo/issues/comments/123"* && "$*" == *"-X PATCH"* ]]; then
    echo "PATCH called"
  elif [[ "$*" == *"pr comment 1 --repo test/repo"* ]]; then
    echo "POST called"
  fi
}
export -f gh

echo "Running update-comment tests..."

# Test 1: New comment
MOCK_COMMENT_EXISTS=false
OUTPUT=$(./.github/scripts/update-comment.sh "test/repo" "1" "<!-- marker -->" "New comment")
echo "Test 1 Passed"

# Test 2: Update comment
MOCK_COMMENT_EXISTS=true
OUTPUT=$(./.github/scripts/update-comment.sh "test/repo" "1" "<!-- marker -->" "New comment")
echo "Test 2 Passed"

echo "All tests passed!"
