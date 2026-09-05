# Gap analysis

Evidence-backed scan of [gesh75/claude-skills](https://github.com/gesh75/claude-skills)
(this tree is the skills library; CI is lint-only). Ranked by impact.
Out of scope: rewrites, dependency upgrades, new product features.

**Proved this pass**

- `python3 .github/bin/skill_lint.py .` → **134 skills, 0 errors / 0 warnings**.
- README inventory matches disk: **91** `*/SKILL.md` + **43** top-level skill
  `*.md` + **100** `reference/*.md`.
- Documented stocktake path is broken on a clone (command output below).
- Existing pytest suite is not installed and not run in CI.
- GitHub Actions `lint` on `main` is green (latest: `33a9164`, 2026-08-25).
- No committed live secrets found (examples use env vars / placeholders).

**Skipped**

- Full `/skill-stocktake` AI verdict pass (needs Claude + `results.json`).
- Installing VideoDB / running `videodb/scripts/ws_listener.py`.
- Rewriting `continuous-learning` vs `continuous-learning-v2` overlap.
- Updating the GitHub repo description (says 123 skills; README says 134).

---

## P0 — fix now

### P0-1. Documented stocktake scan inventories **zero** skills on a clone

**Files:** `README.md` (lines 74–76), `CONTRIBUTING.md` (lines 61–66),
`skill-stocktake/scripts/scan.sh`.

**Evidence:** `scan.sh` defaults to `$HOME/.claude/skills` and
`$PWD/.claude/skills`. This repo *is* the skills tree at the root; those
paths do not exist in a clone or in CI.

```text
$ bash skill-stocktake/scripts/scan.sh
{
  "scan_summary": {
    "global": { "found": false, "count": 0 },
    "project": { "found": false, "path": "", "count": 0 }
  },
  "skills": []
}
```

`CONTRIBUTING.md` then tells you to run
`bash skill-stocktake/scripts/quick-diff.sh skill-stocktake/results.json`,
but `skill-stocktake/results.json` is gitignored and absent → exit 1:
`Error: RESULTS_JSON not found`.

**Fix shipped this PR:** fall back to the repo root when
`~/.claude/skills` is missing.

### P0-2. Even when pointed at this tree, scan invents fake skills

**File:** `skill-stocktake/scripts/scan.sh` (`find … -maxdepth 1 -name '*.md'`).

**Evidence:** `SKILL_STOCKTAKE_GLOBAL_DIR=. bash skill-stocktake/scripts/scan.sh`
returns **137** (not 134). Extra paths:

| Path | Extracted `name:` |
|------|-------------------|
| `./README.md` | `my-skill` (from the anatomy example) |
| `./CONTRIBUTING.md` | `my-skill          # kebab-case…` |
| `./PACKS.md` | empty |

The linter already excludes those meta files (`.github/bin/skill_lint.py`
lines 68–71). The stocktake find does not, so a correctly-installed
`~/.claude/skills` copy of this repo would also over-count.

**Fix shipped this PR:** same meta-file exclusion as the linter
(including `GAP_ANALYSIS.md`).

### P0-3. The only executable test suite is not in CI

**Files:** `continuous-learning-v2/scripts/test_parse_instinct.py`
(50+ pytest cases), `.github/workflows/lint.yml` (lint only).

**Evidence:** workflow step is solely
`python3 .github/bin/skill_lint.py . --quiet`. This environment has no
`pytest` (`ModuleNotFoundError: No module named 'pytest'`), so the suite
cannot run locally without an extra install and would never fail a PR.

**Fix shipped this PR:** CI job installs pytest and runs that file.

---

## P1 — soon

### P1-1. `evaluate-session.sh` double-counts zero matches (`set -e` footgun)

**File:** `continuous-learning/evaluate-session.sh` line 59.

```bash
message_count=$(grep -c '"type":"user"' "$transcript_path" 2>/dev/null || echo "0")
```

`grep -c` prints `0` and exits 1 on no matches, so `|| echo "0"` appends
a second `0` → `$message_count` is `0\n0`. Then
`[ "$message_count" -lt … ]` is `integer expression expected` (proved
with a transcript that has only `"type":"assistant"`).

**Fix shipped this PR:** `|| true` and default to `0`.

### P1-2. Official security-policy LICENSE link is dead

**File:** `.github/SECURITY.md` line 43:
`[LICENSE](../blob/main/LICENSE)` resolves to `/LICENSE` path
`blob/main/LICENSE`, which does not exist. Correct target: `../LICENSE`.

### P1-3. GitHub repo description is stale

API `description` still says **123** skills; README / lint say **134**.
Cannot be fixed in-tree.

### P1-4. Reference files are not linted for stale model IDs

Linter only walks skill bodies. `project-guidelines-example/reference/example-code.md`
still has `claude-sonnet-4-5-20250514` (current convention: `claude-sonnet-4-6`).

### P1-5. `skill-stocktake` comments mention bats tests that do not exist

`scan.sh` / `quick-diff.sh` headers: “intended for bats tests”.
`find . -name '*.bats'` → 0 files. No automated coverage of the audit
scripts (the clone-empty-scan bug would have been caught).

---

## P2 — later / cleanup

| Gap | Evidence |
|-----|----------|
| `continuous-learning` vs `continuous-learning-v2` overlap | v1 skill still documents comparing “v1 vs v2”; v2 SKILL.md says it supersedes v1. Keep both only if the Stop-hook path is still used; otherwise retire v1. |
| Dead Remotion example | `remotion-video-creation/rules/charts.md` → `assets/charts/bar-chart.tsx` missing. |
| Example markdown links look “dead” | `README.md` / `CONTRIBUTING.md` `reference/advanced.md` and `deep-research/SKILL.md` `](url)` are templates, not real files. |
| No tests for `.github/bin/skill_lint.py` | `# pragma: no cover` on the read-error path; CI cannot regress the linter. |
| Unused import | `test_parse_instinct.py` imports `unittest.mock` and never uses it. |
| `videodb/scripts/ws_listener.py` | Third-party runtime (`videodb`, `dotenv`) not declared; script is skill support, not package code. |
| Repo description / README “private library” vs public GitHub | README says private; `gh repo view` is public. Docs drift only. |

---

## Improvement plan (smallest next steps)

1. ~~Unbreak stocktake scan on clones + exclude meta files.~~ done this PR
2. ~~Run the existing instinct-cli pytest in CI.~~ done this PR
3. ~~Fix `evaluate-session.sh` `grep -c` / `set -e`.~~ done this PR
4. Next agent job: add bats (or a 20-line Python) tests for
   `skill-stocktake/scripts/scan.sh` asserting a clone inventories 134
   skills and never emits `README.md` / `PACKS.md`.
5. After that: either retire `continuous-learning` (v1) or make v2 the
   only documented hook; fix the SECURITY.md LICENSE link; refresh the
   GitHub repo description to 134.
