#!/usr/bin/env bash
set -euo pipefail

QUOTES_JSON="${1:-/home/sand/.config/eww/data/time_of_day_quotes_with_bold.json}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq required" >&2
  exit 2
fi

if [ ! -f "$QUOTES_JSON" ]; then
  echo "Quotes JSON not found: $QUOTES_JSON" >&2
  exit 3
fi

JSON_TYPE=$(jq -r 'type' "$QUOTES_JSON" 2>/dev/null || echo "null")
if [ "$JSON_TYPE" != "array" ] && [ "$JSON_TYPE" != "object" ]; then
  echo "Unsupported JSON top-level type: $JSON_TYPE" >&2
  exit 4
fi

trap 'exit 0' INT TERM

last_min=""
selected=""

while true; do
  hhmm=$(date +%H:%M)
  if [ "$hhmm" != "$last_min" ]; then
    if [ "$JSON_TYPE" = "object" ]; then
      len=$(jq -r --arg key "$hhmm" '(.[$key] // []) | length' "$QUOTES_JSON")
      if [ "$len" -gt 0 ]; then
        idx=$((RANDOM % len))
        selected=$(jq -c --arg key "$hhmm" --argjson i "$idx" '.[$key][$i]' "$QUOTES_JSON")
      else
        selected='{}'
      fi
    else
      min_of_day=$((10#$(date +%H) * 60 + 10#$(date +%M)))
      len=$(jq -r --argjson idx "$min_of_day" '(.[$idx] // []) | length' "$QUOTES_JSON")
      if [ "$len" -gt 0 ]; then
        idx=$((RANDOM % len))
        selected=$(jq -c --argjson m "$min_of_day" --argjson i "$idx" '.[$m][$i]' "$QUOTES_JSON")
      else
        selected='{}'
      fi
    fi
    printf '%s\n' "$selected"
    echo $selected > $HOME/.config/eww/data/current_minute_quote.json
    last_min="$hhmm"
  fi
  sleep 1
done
