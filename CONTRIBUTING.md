# Contributing

This is a personal Claude Code skills library. These are the conventions I follow
when adding or editing skills — they keep the library lean, correctly triggered, and
auditable. (See [LICENSE](LICENSE): the repo is All Rights Reserved; this guide
documents *how* the library is maintained, not an invitation to redistribute.)

## Adding a skill

A skill is one of exactly two shapes — nothing else is treated as a skill:

- a top-level `<name>.md`, or
- a `<name>/SKILL.md` directory (use this when the skill needs `reference/` files).

Every skill needs valid YAML frontmatter:

```markdown
---
name: my-skill          # kebab-case, must match the file/dir name
description: One sentence — WHAT it does + WHEN to trigger. Keep under ~350 chars.
---

# My Skill

Core guidance and the most-used patterns, inline.
```

## Conventions

| Rule | Why |
|------|-----|
| `name:` is kebab-case and matches the filename/dirname | How the skill resolves |
| `description:` is trigger-oriented and **under ~350 chars** | It's loaded into context on *every* turn |
| Body over ~400 lines → use **progressive disclosure** | Move bulky code/detail into `reference/*.md`, loaded on demand |
| Reference detail lives in `reference/*.md` with a `## Reference Files` index | Keeps the always-loaded body small |
| Current Claude model IDs only | `claude-opus-4-8`, `claude-sonnet-4-6`, `claude-haiku-4-5` |
| No duplicate / shadow skills | A name must resolve to exactly one skill |
| No dead references | Every `reference/X.md` / sibling-file / cross-skill link must exist |
| No secrets | No real keys/tokens — use obvious placeholders in examples |

### Progressive disclosure

Keep in `SKILL.md`: the trigger, core principles, most-used patterns, a quick reference.
Move out to `reference/*.md`: long code blocks, per-framework deep dives, rarely-needed detail.
End the body with:

```markdown
## Reference Files
- [reference/advanced.md](reference/advanced.md) — read when …
```

## Before committing — run the audit

`skill-stocktake/` inventories and scores every skill. Run it after changes:

```bash
# Only skills changed since the last run
bash skill-stocktake/scripts/quick-diff.sh skill-stocktake/results.json

# Full re-evaluation
bash skill-stocktake/scripts/scan.sh
```

The scan counts only real skills (`<name>.md` or `<dir>/SKILL.md`) — `reference/`,
`rules/`, `agents/`, and sibling content files are ignored.

A quick local sanity check that all frontmatter parses:

```bash
for f in */SKILL.md *.md; do
  python3 -c "import yaml,sys; fm=yaml.safe_load(open('$f').read().split('---')[1]); assert fm.get('name') and fm.get('description')" || echo "INVALID: $f"
done
```

## Commits

Conventional Commits:

```
feat: add <skill> for <purpose>
fix: correct <thing> in <skill>
docs: <change>
refactor: progressive disclosure for <skill>
chore: <maintenance>
```

Keep commits focused; one logical change per commit.

## Retiring a skill

Don't delete outright — move it out of the tree (e.g. `~/.claude/_retired_skills/`) so it
stops loading but stays recoverable. Note what replaces it in the commit message.
