# Staffing, on-call, and vendor lifecycle

## Org shape (default for a mid-size enterprise / health system)

| Function | Ratio / note |
|----------|----------------|
| Network engineering | Design + build; not 24x7 |
| NOC / monitoring | Follow-the-sun or outsourced L1 with in-house L2 |
| Wireless / NAC | Often understaffed; treat as its own lane |
| Cloud networking | Shared with cloud platform; SNM still owns interconnect |
| Clinical network (healthcare) | Named engineer + clinical engineering liaison |

On-call: primary + backup, 1-week rotation, documented escalation to SNM
within 15 min for Sev1. Comp time is a policy, not a favor.

## Hiring bar (senior engineer)

Must demonstrate: change discipline, vendor TAC use, packet/path reasoning,
and written RFCs. Lab heroics without CAB hygiene is a no-hire.

## Vendor model

- **Strategic (2–3):** campus, DC/WAN, security overlay. QBR required.
- **Tactical:** circuits, wireless survey, cabling, TAC overflow.
- **Forbidden:** a vendor who is the only person who understands a box.

QBR agenda: cases opened/closed, TAC time-to-engineer, bug backlog,
renewal, roadmap vs our programs, credits owed.

Renewals: start 120 days out. Never auto-renew a circuit or TAC SKU
without a capacity check.

## Outsourcing guardrails

Outsource L1 toil, not design authority. Managed service still needs:
named customer engineer, config backup we hold, consent-gated changes,
and our monitoring as source of truth — not theirs alone.
