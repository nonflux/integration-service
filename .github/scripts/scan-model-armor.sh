#!/bin/bash
set -e

INPUT_FILE=$1
GCP_LOCATION=$2
GCP_PROJECT_ID=$3
MODEL_ARMOR_TEMPLATE=$4

if [ -z "$INPUT_FILE" ] || [ -z "$GCP_LOCATION" ] || [ -z "$GCP_PROJECT_ID" ] || [ -z "$MODEL_ARMOR_TEMPLATE" ]; then
  echo "Usage: $0 <input_file> <gcp_location> <gcp_project_id> <template>"
  exit 1
fi

export SCAN_TEXT=$(cat "$INPUT_FILE")

RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  "https://modelarmor.${GCP_LOCATION}.rep.googleapis.com/v1/projects/${GCP_PROJECT_ID}/locations/${GCP_LOCATION}/templates/${MODEL_ARMOR_TEMPLATE}:sanitizeUserPrompt" \
  -d "$(jq -n '{user_prompt_data: {text: env.SCAN_TEXT}}')")

MATCH=$(echo "$RESPONSE" | jq -r '.sanitizationResult.filterMatchState // "UNKNOWN"')

if [ "$MATCH" = "MATCH_FOUND" ]; then
  echo "true"
elif [ "$MATCH" = "NO_MATCH_FOUND" ]; then
  echo "false"
else
  echo "true" # Fail secure
fi
