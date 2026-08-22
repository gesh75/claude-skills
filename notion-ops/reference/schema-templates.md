# Notion schema templates (network)

## RFC page template

```
# RFC-NNNN Title
Status: Draft | Review | Approved | Implemented | Aborted
Services: (relation)
Sites: (relation)
CAB: date
Risk: Low | Medium | High | Clinical
Jira: URL
Lucid: URL

## Problem
## Outcome / non-goals
## Current vs target (embed Lucid)
## Cutover & rollback
## Security / ePHI
## Cost
## Decision
```

## Incident / postmortem template

```
# INC-NNNN — short name
Sev: 1–4
Clinical impact: none | delay | diversion
ePHI involved: yes/no (never the data itself)
Timeline (UTC)
What failed
Why (5 whys, not blame)
Fix vs workaround
Actions: owner · due · Jira
Runbook updates
```

## Runbook template

```
# RB — <service> — <failure mode>
Last tested: date · who
Impact if ignored
Detect (alert name)
Diagnose (read-only steps)
Mitigate
Rollback / escalate
Related RFC / diagram
```

## CMDB-lite — Device

Properties: hostname, role, platform, site, mgmt (no creds), serial
(optional), EOS date, NAC profile, zone, owner, Lucid shape id.

Views: by site, by EOS date, by zone, by missing owner.

## Hygiene

- Archive, do not delete, pages that shipped.
- A database with >20 unowned rows is a defect.
- Duplicate "copy of copy" pages get merged on sight.
