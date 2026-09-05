#!/usr/bin/env bash
# quick-diff.sh — compare skill file mtimes against results.json evaluated_at
# Usage: quick-diff.sh RESULTS_JSON [CWD_SKILLS_DIR]
# Output: JSON array of changed/new files to stdout (empty [] if no changes)
#
# When CWD_SKILLS_DIR is omitted:
#   1. $PWD/.claude/skills if that directory exists (project overlay)
#   2. $PWD if this checkout *is* a skills library (has <dir>/SKILL.md)
#   3. otherwise $PWD/.claude/skills (may not exist → no project files)
#
# Environment:
#   SKILL_STOCKTAKE_GLOBAL_DIR   Override ~/.claude/skills (for testing only;
#                                do not set in production — intended for bats tests)
#   SKILL_STOCKTAKE_PROJECT_DIR  Override project dir detection (for testing only)

set -euo pipefail

# Repo-doc markdown that is never a skill (keep in sync with .github/bin/skill_lint.py).
_STOCKTAKE_DOC_MD="README.md CONTRIBUTING.md LICENSE.md SECURITY.md PACKS.md CHANGELOG.md CODE_OF_CONDUCT.md GAP_ANALYSIS.md"

_looks_like_skills_library() {
  local dir="$1" hit
  case "$dir" in
    */.claude/skills|*/.claude/skills/*) return 0 ;;
  esac
  hit=$(find "$dir" -mindepth 2 -maxdepth 2 -name SKILL.md -type f -print -quit 2>/dev/null || true)
  [[ -n "$hit" ]]
}

_resolve_project_skills_dir() {
  if [[ -n "${SKILL_STOCKTAKE_PROJECT_DIR:-}" ]]; then
    printf '%s\n' "$SKILL_STOCKTAKE_PROJECT_DIR"
    return
  fi
  if [[ -n "${1:-}" ]]; then
    printf '%s\n' "$1"
    return
  fi
  if [[ -d "$PWD/.claude/skills" ]]; then
    printf '%s\n' "$PWD/.claude/skills"
    return
  fi
  if _looks_like_skills_library "$PWD"; then
    printf '%s\n' "$PWD"
    return
  fi
  printf '%s\n' "$PWD/.claude/skills"
}

list_skill_files() {
  local dir="$1" f base
  {
    find "$dir" -maxdepth 1 -name '*.md' -type f
    find "$dir" -mindepth 2 -name 'SKILL.md' -type f
  } 2>/dev/null | sort | while IFS= read -r f; do
    base="${f##*/}"
    case " $_STOCKTAKE_DOC_MD " in
      *" $base "*) continue ;;
    esac
    printf '%s\n' "$f"
  done
}

RESULTS_JSON="${1:-}"
CWD_SKILLS_DIR="$(_resolve_project_skills_dir "${2:-}")"
GLOBAL_DIR="${SKILL_STOCKTAKE_GLOBAL_DIR:-$HOME/.claude/skills}"

if [[ -z "$RESULTS_JSON" || ! -f "$RESULTS_JSON" ]]; then
  echo "Error: RESULTS_JSON not found: ${RESULTS_JSON:-<empty>}" >&2
  exit 1
fi

# Warn only when the path exists and is neither a .claude/skills tree nor a
# skills-library checkout (top-level <dir>/SKILL.md).
if [[ -n "$CWD_SKILLS_DIR" && -d "$CWD_SKILLS_DIR" ]] && ! _looks_like_skills_library "$CWD_SKILLS_DIR"; then
  echo "Warning: CWD_SKILLS_DIR does not look like a skills library: $CWD_SKILLS_DIR" >&2
fi

evaluated_at=$(jq -r '.evaluated_at' "$RESULTS_JSON")

# Fail fast on a missing or malformed evaluated_at rather than producing
# unpredictable results from ISO 8601 string comparison against "null".
if [[ ! "$evaluated_at" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]]; then
  echo "Error: invalid or missing evaluated_at in $RESULTS_JSON: $evaluated_at" >&2
  exit 1
fi

# Pre-extract known paths from results.json once (O(1) lookup per file instead of O(n*m))
known_paths=$(jq -r '.skills[].path' "$RESULTS_JSON" 2>/dev/null)

tmpdir=$(mktemp -d)
# Use a function to avoid embedding $tmpdir in a quoted string (prevents injection
# if TMPDIR were crafted to contain shell metacharacters).
_cleanup() { rm -rf "$tmpdir"; }
trap _cleanup EXIT

# Shared counter across process_dir calls — intentionally NOT local
i=0

process_dir() {
  local dir="$1"
  while IFS= read -r file; do
    local mtime dp is_new
    mtime=$(date -u -r "$file" +%Y-%m-%dT%H:%M:%SZ)
    dp="${file/#$HOME/~}"

    # Check if this file is known to results.json (exact whole-line match to
    # avoid substring false-positives, e.g. "python-patterns" matching "python-patterns-v2").
    if echo "$known_paths" | grep -qxF "$dp"; then
      is_new="false"
      # Known file: only emit if mtime changed (ISO 8601 string comparison is safe)
      [[ "$mtime" > "$evaluated_at" ]] || continue
    else
      is_new="true"
      # New file: always emit regardless of mtime
    fi

    jq -n \
      --arg path "$dp" \
      --arg mtime "$mtime" \
      --argjson is_new "$is_new" \
      '{path:$path,mtime:$mtime,is_new:$is_new}' \
      > "$tmpdir/$i.json"
    i=$((i+1))
  # A skill file is a top-level <name>.md OR a <dir>/SKILL.md. Everything else
  # (reference/, rules/, agents/, sibling content files, STYLE_PRESETS.md, etc.)
  # is supporting content and must NOT be counted as a skill.
  done < <(list_skill_files "$dir")
}

[[ -d "$GLOBAL_DIR" ]] && process_dir "$GLOBAL_DIR"
[[ -n "$CWD_SKILLS_DIR" && -d "$CWD_SKILLS_DIR" ]] && process_dir "$CWD_SKILLS_DIR"

if [[ $i -eq 0 ]]; then
  echo "[]"
else
  jq -s '.' "$tmpdir"/*.json
fi
