<!-- Keep it short. See CONTRIBUTING.md for the conventions. -->

## What & why

<!-- One or two sentences: what this changes and the reason. -->

## Type of change

- [ ] 🧩 New skill
- [ ] 🐛 Skill fix (stale ref / dead link / frontmatter / trigger)
- [ ] ♻️ Refactor (progressive disclosure, dedup, merge)
- [ ] 🗑️ Retire a skill
- [ ] 📖 Docs / tooling

## Skills affected

<!-- List skill names added / changed / retired. -->

## Checklist

- [ ] Frontmatter valid — `name:` (kebab-case, matches file/dir) + `description:`
- [ ] Description is trigger-oriented and under ~350 chars
- [ ] Body over ~400 lines uses progressive disclosure (`reference/*.md`)
- [ ] No dead references — every `reference/` / sibling / cross-skill link resolves
- [ ] Current model IDs only (`claude-opus-4-8` / `claude-sonnet-4-6` / `claude-haiku-4-5`)
- [ ] No duplicate / shadow skill; a name resolves to exactly one skill
- [ ] No secrets or real keys in examples
- [ ] Ran the audit: `bash skill-stocktake/scripts/quick-diff.sh skill-stocktake/results.json`

## Retire note (if applicable)

<!-- Moved out of the tree (not deleted)? What replaces it? -->
