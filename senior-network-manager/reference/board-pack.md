# Board / exec pack — Senior Network Manager

Use when the user asks for a monthly ops review, quarterly business review,
or board/CIO slide narrative. One page of truth. No vanity graphs.

## Required sections (in order)

1. **Service health (this period)**
   - Availability by service (core, campus, DC, WAN/SD-WAN, internet, wireless, voice, clinical)
   - SLO vs SLA: met / burn / missed
   - Sev1/Sev2 count, MTTD, MTTR, change-caused vs defect-caused
2. **Risk register (top 5)**
   - Statement, likelihood, impact, owner, due, residual after treatment
   - Always include: single points of failure, expiring hardware/circuits, unpatched infra, vendor concentration
3. **Change & freeze**
   - Changes shipped / backed out / deferred
   - Upcoming freeze (clinical, financial close, go-live)
4. **Capacity & spend**
   - Links, WAN, internet, wireless AP density, DC fabric, licenses, TAC cases
   - Forecast 90 days; call out anything that breaches 70% headroom
5. **Program status**
   - 3–5 active programs only (refresh, segmentation, SD-WAN, EHR, DC)
   - Red/amber/green + next milestone + blocker
6. **Ask**
   - Decision needed from leadership (money, freeze, risk acceptance, hire)
   - Cost of delay in dollars or clinical/operational impact

## Rules

- Lead with the miss, not the win.
- Every red item has an owner and a date.
- Do not pad with "transformation" language.
- Healthcare: add a **clinical safety** line (any event that could have delayed care).
- Pair with `network-observability` for the numbers and `atlassian-ops` for the ticket evidence.

## Slide budget

Max 8 slides. Speaker notes hold the evidence. Lucid one-pager of the
target-state topology goes in the appendix, never as slide 1.
