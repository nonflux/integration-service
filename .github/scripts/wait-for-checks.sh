#!/bin/bash
set -euo pipefail

# wait-for-checks.sh — Poll CI check status on a PR until all complete.
#
# Usage: wait-for-checks.sh <repo> <pr_number> [timeout_seconds]
#
# Outputs (via GITHUB_OUTPUT):
#   result:      passed | failed | timeout
#   failure_log: path to collected failure logs (when result=failed)
#
# Requires: GH_TOKEN env var with repo read access.

REPO=$1
PR_NUMBER=$2
TIMEOUT=${3:-1800}

POLL_INTERVAL=60
GRACE_PERIOD=30

# Agent-owned checks to ignore while waiting for "real" CI
IGNORE_PATTERN="implement|Implementation Agent|Review Agent|Fix Agent"

output() {
  if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "$1=$2" >> "$GITHUB_OUTPUT"
  fi
  echo "$1=$2"
}

echo "⏳ Waiting for CI checks on PR #${PR_NUMBER} (timeout: ${TIMEOUT}s)…"
sleep "$GRACE_PERIOD"

START_TIME=$(date +%s)

while true; do
  ELAPSED=$(( $(date +%s) - START_TIME ))
  if [ "$ELAPSED" -ge "$TIMEOUT" ]; then
    echo "::warning::CI check timeout after ${TIMEOUT}s"
    output "result" "timeout"
    exit 0
  fi

  SHA=$(gh api "repos/${REPO}/pulls/${PR_NUMBER}" --jq '.head.sha')

  CHECKS=$(gh api "repos/${REPO}/commits/${SHA}/check-runs" \
    --paginate \
    --jq '[.check_runs[] | {name: .name, status: .status, conclusion: .conclusion}]' 2>/dev/null || echo "[]")

  RELEVANT=$(echo "$CHECKS" | jq --arg pat "$IGNORE_PATTERN" \
    '[.[] | select(.name | test($pat; "i") | not)]')

  TOTAL=$(echo "$RELEVANT" | jq 'length')
  COMPLETED=$(echo "$RELEVANT" | jq '[.[] | select(.status == "completed")] | length')
  PENDING=$(( TOTAL - COMPLETED ))

  echo "  CI: ${COMPLETED}/${TOTAL} completed (${PENDING} pending, ${ELAPSED}s elapsed)"

  if [ "$TOTAL" -eq 0 ]; then
    sleep "$POLL_INTERVAL"
    continue
  fi

  if [ "$PENDING" -gt 0 ]; then
    sleep "$POLL_INTERVAL"
    continue
  fi

  # All relevant checks have completed — evaluate results
  FAILED_CHECKS=$(echo "$RELEVANT" | jq \
    '[.[] | select(.conclusion != "success" and .conclusion != "neutral" and .conclusion != "skipped")]')
  FAILURE_COUNT=$(echo "$FAILED_CHECKS" | jq 'length')

  if [ "$FAILURE_COUNT" -eq 0 ]; then
    echo "✅ All CI checks passed"
    output "result" "passed"
    exit 0
  fi

  echo "❌ ${FAILURE_COUNT} check(s) failed — collecting logs…"

  LOG_FILE="/tmp/ci-failures-pr${PR_NUMBER}-$(date +%s).txt"
  echo "# CI Failure Logs for PR #${PR_NUMBER}" > "$LOG_FILE"
  echo "" >> "$LOG_FILE"

  # List failed check names
  echo "$FAILED_CHECKS" | jq -r '.[] | "- **" + .name + "** (" + .conclusion + ")"' >> "$LOG_FILE"
  echo "" >> "$LOG_FILE"

  # Attempt to fetch workflow run logs for the failing checks
  BRANCH=$(gh api "repos/${REPO}/pulls/${PR_NUMBER}" --jq '.head.ref')
  FAILED_RUNS=$(gh api "repos/${REPO}/actions/runs?branch=${BRANCH}&status=failure&per_page=10" \
    --jq '.workflow_runs[].id' 2>/dev/null || true)

  for RUN_ID in $FAILED_RUNS; do
    echo "---" >> "$LOG_FILE"
    echo "## Workflow Run ${RUN_ID}" >> "$LOG_FILE"
    gh run view "$RUN_ID" --repo "$REPO" --log-failed 2>/dev/null | tail -300 >> "$LOG_FILE" || \
      echo "(could not fetch logs for run ${RUN_ID})" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
  done

  # Truncate if too large (keep first 50KB for the agent)
  if [ "$(wc -c < "$LOG_FILE")" -gt 51200 ]; then
    head -c 51200 "$LOG_FILE" > "${LOG_FILE}.tmp"
    echo -e "\n\n[… log truncated at 50 KB]" >> "${LOG_FILE}.tmp"
    mv "${LOG_FILE}.tmp" "$LOG_FILE"
  fi

  output "result" "failed"
  output "failure_log" "$LOG_FILE"
  exit 0
done
