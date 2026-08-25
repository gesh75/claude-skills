# T-minus and commander model

## Roles on the bridge

- **Commander** (usually SNM or delegated senior): go / hold / back out
- **Implementer**: types, only after commander
- **Verifier**: independent; runs probes and calls app owner
- **Scribe**: timeline in the ticket (UTC)
- **Clinical liaison** (if clinical path): house supervisor / clinical eng

One person is not implementer and verifier.

## Verify list (minimum)

- Named synthetic probe (HTTP/TCP/IP SLA) on the service
- Interface/error counters vs baseline
- Control plane (BGP/OSPF neighbors) vs baseline
- App owner sentence in the ticket: "service OK"
- Healthcare: one clinical workflow (e.g. Hyperspace login, DICOM store)

## Abort criteria (pre-agreed)

- Any Sev1 elsewhere in the blast radius
- Rollback time would exceed window
- Unexpected diff vs staged config
- Clinical unit says stop

## After

Close with evidence (not "looks good"). Open Problem if you mitigated
without understanding. Update the runbook the same day, not "later".
