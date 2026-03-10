#!/usr/bin/env zsh

set -euo pipefail

# Optional: forward any selection flags you want, e.g.:
#   ./gh-watch-notify --branch main --workflow build.yml
selector=("$@")

# Get the latest run ID matching the selector
run_id=$(gh run list "${selector[@]}" --limit 1 --json databaseId --jq '.[0].databaseId')

# Watch that run interactively (no pipes, so TTY is preserved)
gh run watch --exit-status 
ret=$?

# Fetch a compact summary for the notification
summary=$(
  gh run view "$run_id" \
    --json name,conclusion,headBranch \
    --jq '.name + " (" + .headBranch + ") → " + .conclusion'
)

# Fallback if something went wrong fetching the summary
if [[ -z "${summary:-}" ]]; then
  summary="Run $run_id finished with exit status $ret"
fi

terminal-notifier -title "GitHub Actions" -message "$summary"

exit "$ret"
