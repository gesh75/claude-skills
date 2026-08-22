# NAC and management plane

## 802.1X rollout (sane order)

1. Monitor mode, inventory MACs, fix the CMDB
2. User SSIDs and user wired to EAP-TLS or PEAP (match identity team)
3. Printers/WOWs: MAB with owner + 12-month expiry
4. Biomedical: MAB or closed VLAN, never user AD as a crutch
5. Enforce; dead devices get a ticket, not a permanent exception

Guest: web auth + isolation + internet only. Contractors: expiry or it
is a finding.

## Policy

Identity → VLAN/SGT/overlay. The switch is not the identity store.
Failed auth goes to a quarantine VLAN with remediation, not to corp.

## Management plane checklist

- [ ] No SSH/HTTPS/SNMP from user or guest VRFs
- [ ] Control-plane ACL / CoPP
- [ ] MFA on VPN and PAM
- [ ] Per-admin AAA, no shared local except break-glass (logged)
- [ ] Streaming or trap + syslog off-box
- [ ] Backup every config, restore tested quarterly
- [ ] Firmware/PSIRT tracked; critical on internet-facing within SLA

## Zero Trust overlay

Useful for users-to-apps. It does not replace NAC on campus or
isolation of pumps. If a vendor sells ZTA as "then you can flatten
VLANs", treat that as a risk, not a design.
