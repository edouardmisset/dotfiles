#!/usr/bin/env bash
set -euo pipefail

# Runs eslint (via pnpm), outputs JSON, and prints a table of ruleId
# occurrence counts (errors + warnings, by default), sorted descending.
#
# Usage: eslint-summary.zsh [--warnings-only|--errors-only] [eslint args...]
#
# Any extra arguments are passed through to `eslint`.

usage() {
  echo "Usage: $(basename "$0") [--warnings-only|--errors-only] [eslint args...]" >&2
  exit 1
}

for cmd in pnpm jq column; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: required command '$cmd' not found" >&2
    exit 1
  fi
done

severity_filter='true'
case "${1:-}" in
  --warnings-only)
    severity_filter='.severity == 1'
    shift
    ;;
  --errors-only)
    severity_filter='.severity == 2'
    shift
    ;;
  -h|--help)
    usage
    ;;
esac

json=$(pnpm exec eslint . --cache --format json "$@" 2>/dev/null) || true

if [[ -z "$json" ]]; then
  echo "No eslint output (check that eslint runs correctly)." >&2
  exit 1
fi

jq -r --arg filter "$severity_filter" '
  [
    .[]
    | select((.errorCount // 0) + (.warningCount // 0) > 0)
    | .messages[]
    | select(.ruleId != null)
    | select(
        if $filter == "true" then true
        elif $filter == ".severity == 1" then .severity == 1
        else .severity == 2
        end
      )
    | .ruleId
  ]
  | group_by(.)
  | map({ruleId: .[0], count: length})
  | sort_by(-.count)
  | if length == 0 then
      "No matching lint issues found."
    else
      (["RULE", "COUNT"] | @tsv),
      (.[] | [.ruleId, (.count | tostring)] | @tsv)
    end
' <<<"$json" | column -t -s $'\t'
