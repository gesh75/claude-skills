# Skill packs

A **pack** is a set of skills that route to each other for one role.
Skills stay independently loadable; this file is the map.

## senior-network-manager

Role: Senior Network Manager / NOC lead / network operations manager
for enterprise and **healthcare** environments.

| Skill | Job |
|-------|-----|
| [senior-network-manager](senior-network-manager/SKILL.md) | Operating cadence, RACI, routing |
| [network-project-analysis](network-project-analysis/SKILL.md) | RFC / design / SOW deep review |
| [healthcare-network](healthcare-network/SKILL.md) | HIPAA, HITRUST, clinical, IoMT |
| [notion-ops](notion-ops/SKILL.md) | Runbooks, CMDB-lite, RFC narrative |
| [lucid-diagrams](lucid-diagrams/SKILL.md) | Lucidchart layers and stencils |
| [atlassian-ops](atlassian-ops/SKILL.md) | Jira / JSM / Confluence |
| [network-diagrams](network-diagrams/SKILL.md) | Mermaid / PlantUML as code |
| [network-change-cab](network-change-cab/SKILL.md) | CAB, freeze, rollback |
| [network-observability](network-observability/SKILL.md) | SLO, capacity, NOC health |
| [network-security-posture](network-security-posture/SKILL.md) | Segmentation, NAC, ZTA, vendors |
| [netops-mcp](netops-mcp/SKILL.md) | Live device read / consent-gated write |

Install: copy those directories into `~/.claude/skills/` (this repo
already *is* that tree). Descriptions stay short so the router can
load them every turn; bodies and `reference/` load on trigger.

Typical flow:

```
ask → senior-network-manager (route)
    → network-project-analysis (score the design)
    → healthcare-network (if clinical)
    → network-diagrams + lucid-diagrams (show it)
    → notion-ops + atlassian-ops (write it down)
    → network-change-cab (ship it)
    → netops-mcp (touch the box)
    → network-observability (prove it)
```
