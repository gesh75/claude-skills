# Confluence information architecture (network)

Space: **Network**. Tree:

```
Network
├── Start here (how we change things)
├── Runbooks (by service)
├── Standards (naming, QoS, NAC, addressing)
├── Sites (one child per campus)
├── Programs (refresh, SD-WAN, segmentation)
├── CAB (agendas + decisions)
└── Archive
```

Page title = searchable name. Labels: `runbook`, `standard`, `cab`,
`clinical`, `vendor`.

NOC runbooks live here even if the RFC narrative is in Notion — the
person on-call at 02:00 should not hunt two wikis. Put a one-line
pointer at the top of each runbook to the RFC.

Permissions: management-plane details (mgmt IPs ok, credentials never).
Vendor space is read-only to vendors if you must share; prefer a portal.

Review: every runbook has `last-tested`. Pages older than 12 months
without a test are automatically suspect — flag in the weekly ops review.
