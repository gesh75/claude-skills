# Gap analysis — claude-skills

Scan date: 2026-09-05. Scope: this checkout (`gesh75/claude-skills`), not a
rewrite of the skill corpus. Evidence is from running commands in this tree,
not from memory.

**Inventory (linter):** 134 skills — 91 `*/SKILL.md` + 43 top-level `*.md`.
Matches the README table. `python3 .github/bin/skill_lint.py .` →
`134 clean · 0 errors · 0 warnings`.

**This PR's safe fixes (3):**

1. `skill-stocktake/scripts/scan.sh` + `quick-diff.sh` — inventory *this* repo
   and skip repo-doc markdown (`README.md`, `PACKS.md`, …).
2. `continuous-learning/evaluate-session.sh` — `grep -c || echo 0` crash on
   zero matches.
3. `.github/workflows/lint.yml` — run the existing instinct pytest file.

---

## P0 — fix or it lies

### P0-1. Documented stocktake scans the wrong tree and counts docs as skills

**Files:** `skill-stocktake/scripts/scan.sh`, `skill-stocktake/scripts/quick-diff.sh`  
**Cited by:** `README.md` (skill-stocktake section), `CONTRIBUTING.md` (“Before committing”)

**Evidence (before this PR, from repo root):**

```text
$ bash skill-stocktake/scripts/scan.sh
# scan_summary.global.found = false
# scan_summary.project.found = false
# skills = []
```

Default project path was `$PWD/.claude/skills` (ECC overlay). This repository
*is* the skills library; that overlay does not exist here. The documented
command therefore printed an empty inventory.

Workaround `bash skill-stocktake/scripts/scan.sh .` then **over-counted**:

```text
# Warning: CWD_SKILLS_DIR does not look like a .claude/skills path: .
# project.count = 137
# empty name: PACKS.md
```

`find … -maxdepth 1 -name '*.md'` included `README.md`, `CONTRIBUTING.md`, and
`PACKS.md`. The vendored linter already excludes those
(`.github/bin/skill_lint.py` `find_skill_files`). Scanner and
linter disagreed by 3. This file (`GAP_ANALYSIS.md`) is on the same denylist
so it is not itself a fourth “skill”.

**Fix in this PR:** if `$PWD/.claude/skills` is absent and `$PWD` has
`<dir>/SKILL.md`, scan `$PWD`. Drop the same doc-file denylist as the linter.
Re-run: `project.count = 134`, no empty names, no warning.

### P0-2. Stop-hook script dies on a short / empty transcript

**File:** `continuous-learning/evaluate-session.sh` line 59 (pre-fix)

**Evidence:** `grep -c` exits 1 when the count is 0 *and still prints `0`*.
`$(grep -c … || echo "0")` therefore becomes `0\n0`. With `set -e`:

```text
$ message_count=$(grep -c '"type":"user"' /tmp/no-users.jsonl || echo "0")
$ [ "$message_count" -lt 10 ]
# bash: [: 0
# 0: integer expression expected
```

The Stop hook then aborts instead of skipping a short session. Reproduced in
this environment with a one-line JSONL file that has no `"type":"user"`.

**Fix in this PR:** capture `grep -c … || true` and default empty to `0`.

### P0-3. Existing unit tests never run in CI

**Files:** `continuous-learning-v2/scripts/test_parse_instinct.py` (50+ tests,
including path-traversal / invalid-id guards), `.github/workflows/lint.yml`

**Evidence:** the only workflow job was `skill-lint`.
`gh run list` on `main` shows `lint` success only — no pytest job.
`python3 -c "import pytest"` fails in a clean environment; the suite is
unrunnable without an explicit install, and CI never installed it.

Those tests are the only automated check of executable Python in the library
(instinct promote path-traversal, registry atomic write). They were dead
weight in CI.

**Fix in this PR:** `instinct-tests` job — `pip install pytest` at job time
(not a repo runtime dependency) and run that file.

---

## P1 — real, but not this PR

| ID | Area | Evidence | Why skipped |
|----|------|----------|-------------|
| P1-1 | Docs / correctness | `continuous-learning/SKILL.md` line 119: `See: docs/continuous-learning-v2-spec.md` — `docs/` does not exist (`ls docs` → No such file). | Deleting one stale sentence is safe but not a failing hook; left for a docs pass. |
| P1-2 | Docs / correctness | `configure-ecc/SKILL.md` catalogs 12 skills not in this tree (`jpa-patterns`, `laravel-*`, `springboot-*`, `golang-*`, `java-coding-standards`). Upstream ECC catalog vs this personal subset. | Editing the ECC install map without a product decision is a rewrite of a skill, not a gap-scan fix. |
| P1-3 | Correctness / lint hole | Linter only reads top-level `*.md` and `*/SKILL.md`. `project-guidelines-example/reference/example-code.md` line 77 still has `claude-sonnet-4-5-20250514`. Stale-model check never sees `reference/`. | Extending the linter is a feature. One-line model bump is safe later. |
| P1-4 | Docs | `.github/SECURITY.md` links `[LICENSE](../blob/main/LICENSE)`; `.github/ISSUE_TEMPLATE/new-skill.yml` links `../blob/main/CONTRIBUTING.md`. Those paths do not exist on disk (`../blob/` is a GitHub URL fragment, not a relative file). | Cosmetic; GitHub sometimes still resolves them in the UI. |
| P1-5 | DX / overlap | `continuous-learning` (v1 Stop hook) and `continuous-learning-v2` both load. `skill-stocktake/SKILL.md` already uses v1 as the example *Retire* target. | Retirement needs an explicit “move out of tree” decision (`CONTRIBUTING.md`). |
| P1-6 | CI | No job asserts stocktake JSON count == linter count. Easy to regress P0-1. | Follow-up after this PR’s scanner change settles. |

---

## P2 — backlog

| ID | Area | Evidence | Notes |
|----|------|----------|-------|
| P2-1 | Dead code / comments | `scan.sh` header mentions “bats tests”; no `*.bats` in the repo. | Don’t invent a bats suite here. |
| P2-2 | Tests | `skill_lint.py` is the CI gate and has no unit tests (`# pragma: no cover` on the read-error path). | Fine while the script stays ~250 lines; add tests if the linter grows. |
| P2-3 | Scripts | `videodb/scripts/ws_listener.py` imports `dotenv` + `videodb` — no requirements pin, no test. Example companion, not CI-critical. | |
| P2-4 | Security | No secret-scan workflow. Grep of `api_key` / `sk-` hits are placeholders (`YOUR_EXA_API_KEY_HERE`, `os.environ[...]`). No live credential found. | Add gitleaks only if the repo goes public. |
| P2-5 | DX | README skill counts are a manual table. They happen to be correct today; they will rot. | A one-line `scan.sh \| jq` in CI (P1-6) is enough. |
| P2-6 | Docs | `PACKS.md` is not a skill (correct) but was counted as one by the old scanner (empty `name`). | Fixed as part of P0-1. |
| P2-7 | License | `LICENSE` is All Rights Reserved with a third-party Apache carve-out. No per-file `NOTICE` for ECC-origin skills beyond `origin: ECC` frontmatter. | Legal hygiene, not a code defect. |

---

## What this scan proved

- Linter is green on all 134 skills; README counts match `find`.
- `gh run list` / `gh pr list`: lint on `main` is green; no open issues.
- Documented `scan.sh` (pre-fix) returned **zero** skills from this repo root.
- `scan.sh .` (pre-fix) returned **137** including `PACKS.md` with an empty name.
- `evaluate-session.sh`’s `grep -c \|\| echo 0` produces a non-integer and trips
  `[: integer expression expected]`.
- `test_parse_instinct.py` exists and is substantial; CI never invoked it.
- No committed live secrets turned up in a targeted grep.

## What was skipped (on purpose)

- No skill-body rewrites, no progressive-disclosure campaigns, no dependency
  bumps, no retiring `continuous-learning` v1, no linter feature work, no
  bats suite, no secret-scanner workflow, no LICENSE/NOTICE overhaul.
- `configure-ecc`’s missing-skill catalog is upstream-shaped; not silently
  trimmed.
- Reference-file stale model IDs (P1-3) left in place.

## Next recommended agent job

Add a CI assertion that `scan.sh | jq '.scan_summary.project.count'` equals
the linter’s skill count (134), then either retire `continuous-learning` v1
or delete the dangling `docs/continuous-learning-v2-spec.md` pointer.
