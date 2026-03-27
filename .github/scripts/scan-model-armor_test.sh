#!/bin/bash
set -e

echo "Running scan-model-armor tests..."

curl() {
  if [ "$MOCK_RESPONSE" = "MATCH_FOUND" ]; then
    echo '{"sanitizationResult": {"filterMatchState": "MATCH_FOUND"}}'
  elif [ "$MOCK_RESPONSE" = "NO_MATCH_FOUND" ]; then
    echo '{"sanitizationResult": {"filterMatchState": "NO_MATCH_FOUND"}}'
  else
    echo '{"sanitizationResult": {"filterMatchState": "UNKNOWN"}}'
  fi
}
gcloud() {
  echo "mock-token"
}
export -f curl
export -f gcloud

echo "test content" > mock_input.txt

export MOCK_RESPONSE="MATCH_FOUND"
RESULT=$(./.github/scripts/scan-model-armor.sh mock_input.txt "loc" "proj" "temp")
if [ "$RESULT" != "true" ]; then echo "Test 1 failed"; exit 1; fi

export MOCK_RESPONSE="NO_MATCH_FOUND"
RESULT=$(./.github/scripts/scan-model-armor.sh mock_input.txt "loc" "proj" "temp")
if [ "$RESULT" != "false" ]; then echo "Test 2 failed"; exit 1; fi

export MOCK_RESPONSE="UNKNOWN"
RESULT=$(./.github/scripts/scan-model-armor.sh mock_input.txt "loc" "proj" "temp")
if [ "$RESULT" != "true" ]; then echo "Test 3 failed"; exit 1; fi

rm mock_input.txt
echo "All tests passed!"
