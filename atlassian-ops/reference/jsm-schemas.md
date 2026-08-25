# JSM / Jira schemas for network

## Change (JSM)

Required: Change type (standard/normal/emergency), risk, window start/end,
implementation plan, rollback, test/verify, RFC link, services, sites,
peer reviewer, SNM approver, CAB date (if normal/major), clinical window
(healthcare), backout minutes.

Standard changes: pre-approved catalog only (e.g. add VLAN to an existing
template). Everything else is normal or emergency.

## Incident

Required: severity (1–4), affected services, start time, user impact,
clinical impact (none/delay/diversion), ePHI flag (boolean only),
detect source (alert, user, vendor), commander.

Sev1: SNM on the bridge in 15 minutes. Healthcare Sev1 with clinical
delay: house supervisor notified.

## Problem

Required: linked incidents, workaround, RCA due date, owning engineer.
Do not use Problem as a parking lot for "too hard".

## Request catalog (minimum)

- Port / VLAN / SVI (expiry on guest/contractor)
- Firewall / broker flow (named, expiry)
- VPN / vendor access (PAM, expiry, BAA check)
- Circuit / DNS / cert
- Wireless survey / AP move

Each request auto-links a Change if it mutates production.

## Automation worth having

- Change in window without rollback comment → block transition
- Incident Sev1 → page + Slack/Teams + status page
- Vendor access request without expiry → cannot close
- Linked RFC missing Lucid URL on major change → CAB warn
