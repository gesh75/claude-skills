# Network RFC / HLD skeleton

Fill every heading. "N/A" is allowed only with a reason.

```text
# RFC-NNNN — <title>
Status: draft | in-review | approved | implemented | aborted
Authors / reviewers / approver (SNM)
Related: Jira · Notion · Lucid · CAB

## 1. Problem
User-visible failure or constraint. Metric if it exists.

## 2. Outcome
What will be true after. SLO, sites, apps.

## 3. Non-goals
What we are explicitly not doing.

## 4. Current state
Sites, platforms, versions, known debt. Link as-is diagram.

## 5. Options
A / B / C with cost, risk, operability. Recommend one.

## 6. Target design
L1/L2/L3, overlay, identity, addressing, QoS, multicast, wireless,
OOB, internet edge, DC, WAN. Link to-be diagram.

## 7. Failure domains
What dies, detection, failover, RTO. Test plan.

## 8. Security & compliance
Segments, NAC, logging, BAA, ePHI path (if any).

## 9. Cutover
Waves, freeze, backout, verifier, comms. Healthcare clinical window.

## 10. Operability
Monitoring, backups, runbooks, who is on-call the night of.

## 11. Cost
BoM, opex 3-year, contingency, credits.

## 12. Risks
Id · severity · treatment · owner · due.

## 13. Decision
Approve / conditions / reject.
```

Keep the RFC in Notion (canonical narrative) and Jira (execution). Lucid
holds the pictures. Do not let a 40-page Word doc become the only copy.
