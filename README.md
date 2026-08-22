# claude-skills

[![lint](https://github.com/gesh75/claude-skills/actions/workflows/lint.yml/badge.svg)](https://github.com/gesh75/claude-skills/actions/workflows/lint.yml)

Personal [Claude Code](https://claude.com/claude-code) skills library — the contents of `~/.claude/skills`.

A **skill** is a self-contained capability Claude Code loads on demand: a `description` that tells the model *when* to use it, and a body of guidance, checklists, and code it pulls in *only when triggered*. This repo is my curated, audited set of them.

## At a glance

| | |
|---|---|
| Directory skills (`<name>/SKILL.md`) | **91** |
| Standalone skills (`<name>.md`) | **43** |
| Active skills total | **134** |
| Progressive-disclosure reference files | **100** |
| Role packs | [senior-network-manager](PACKS.md) |

## Senior Network Manager pack

The library was software-engineering heavy and had **one** live-device skill
(`netops-mcp`). The SNM pack fills the role: healthcare, CAB, RFC analysis,
Notion / Lucid / Atlassian, diagrams, observability, posture.

See **[PACKS.md](PACKS.md)** for the routing table. Entry skill:
[`senior-network-manager`](senior-network-manager/SKILL.md).

## Layout

```
~/.claude/skills/
├── <skill-name>/
│   ├── SKILL.md              # the skill (frontmatter + core guidance)
│   └── reference/*.md        # detail loaded on demand (progressive disclosure)
├── <skill-name>.md           # single-file skill
├── PACKS.md                  # role packs (maps, not a skill)
└── skill-stocktake/          # the auditing tool (see below)
    └── scripts/
```

Two valid skill shapes, and **only** these are treated as skills:

- a **top-level** `<name>.md`, or
- a **`<dir>/SKILL.md`**.

Everything else (`reference/`, `rules/`, `agents/`, sibling content files, `PACKS.md`) is supporting material, not an independently-loaded skill.

### Anatomy of a skill

```markdown
---
name: my-skill
description: One tight sentence on WHAT it does + WHEN to trigger it. Always in context, so keep it short.
---

# My Skill

Core guidance, checklists, and the most-used patterns inline.
Heavy code / rarely-needed detail lives in reference/*.md, pulled in on demand.

## Reference Files
- [reference/advanced.md](reference/advanced.md) — read when …
```

Two cost surfaces drive how skills are written here:

1. **`description`** is loaded into context on *every* turn → keep it tight and trigger-oriented.
2. **Body** is loaded only when the skill fires → push bulky detail into `reference/*.md`.

## skill-stocktake

`skill-stocktake/` is an auditing tool that inventories every skill, scores it (Keep / Improve / Update / Retire / Merge), and caches verdicts.

```bash
# Full audit (re-evaluates everything)
bash skill-stocktake/scripts/scan.sh

# Quick scan (only skills changed since the last run)
bash skill-stocktake/scripts/quick-diff.sh skill-stocktake/results.json
```

The scan scripts count **only** real skills (`<name>.md` or `<dir>/SKILL.md`) — they ignore `reference/`, `rules/`, `agents/`, and sibling content files so the inventory reflects actual skills, not progressive-disclosure chunks.

## Conventions

- **Descriptions** stay trigger-oriented and well under ~350 characters.
- **Bodies** over ~400 lines use progressive disclosure (`reference/*.md`).
- **Model IDs** reference current Claude models — Opus 4.8 (`claude-opus-4-8`), Sonnet 4.6 (`claude-sonnet-4-6`), Haiku 4.5 (`claude-haiku-4-5`).
- **No duplicates / shadows** — a name resolves to exactly one skill.
- **Packs** (see [PACKS.md](PACKS.md)) are documentation; they do not load as skills.

## Notes

- This is a personal library; it is **private** and not intended as a distributable package.
- `skill-stocktake/results.json` (audit cache) and `*.bak` files are gitignored.
