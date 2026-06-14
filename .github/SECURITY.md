# Security Policy

This is a personal, private Claude Code skills library. The skills are **prompt
and reference content** (Markdown) plus a few shell/Python helper scripts — there
is no deployed service or runtime exposed to users. "Security" here means: no
secrets in the repo, and no skill content that would steer Claude toward unsafe
actions.

## Reporting a concern

If you spot any of the following, please report it privately — **do not open a
public issue**:

- A leaked secret (API key, token, password, private key) committed anywhere in
  the repo or its history.
- Personal/sensitive information (PII) that shouldn't be public.
- A skill whose guidance could induce harmful, destructive, or injection-style
  behavior (e.g. prompt-injection payloads, instructions to exfiltrate data).

**How:** use GitHub's [private vulnerability reporting](https://github.com/gesh75/claude-skills/security/advisories/new)
(Security → Report a vulnerability), or email **georgy75@gmail.com**.

Please include the file path, the line(s), and why it's a concern. I aim to
acknowledge within a few days.

## What's in scope

- Committed secrets / credentials.
- PII or other sensitive data in skill content.
- Skill content that encourages unsafe or malicious agent behavior.
- Vulnerabilities in the `skill-stocktake/scripts/*` helper scripts (e.g. shell
  injection, unsafe file handling).

## Not in scope

- The behavior of Claude Code itself, or of any third-party tool/MCP a skill
  references — report those to their respective projects.
- Third-party content that retains its own upstream license (see
  [LICENSE](../blob/main/LICENSE)).

## Handling

Confirmed leaked secrets are removed and **rotated**; if a secret reached the
git history, the history is rewritten or the repo re-created as needed. Skill
content issues are fixed or the skill retired.
