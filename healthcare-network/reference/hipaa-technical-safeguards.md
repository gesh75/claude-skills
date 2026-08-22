# HIPAA technical safeguards — network mapping

Source of truth: 45 CFR 164.312, NIST SP 800-66r2, HHS 405(d) HICP,
CISA HPH Cybersecurity Performance Goals. This is a mapping for network
managers, not legal advice.

## 164.312(a) Access control

| Control | Network evidence |
|---------|------------------|
| Unique user ID | TACACS/RADIUS per-admin; no shared enable |
| Emergency access | Break-glass jump + logged local; reviewed weekly |
| Auto-logoff | NAC reauth + workstation policy; wireless idle |
| Encryption/decryption | Management plane SSH/TLS only; no telnet/http |

## 164.312(b) Audit controls

Log: AAA, VPN, NAC, firewall, DNS, DHCP, wireless controllers, jump hosts.
Retention per legal hold (typically ≥ 6 years for HIPAA; confirm with
privacy). Logs are **not** PHI warehouses — drop payloads, keep metadata.
Clock sync (NTP/PTP) is a control.

## 164.312(c) Integrity

Config backup with diff; unauthorized change alert. Routing/filtering that
prevents a guest device from speaking HL7/DICOM to a core app.

## 164.312(d) Person/entity authentication

MFA for all remote admin and vendor access (HPH CPG floor). 802.1X for
users; MAB only with inventory + expiry. Certificates for EAP-TLS where
the fleet can take it.

## 164.312(e) Transmission security

ePHI in motion: TLS 1.2+ for app paths; IPsec/MACSec where the app cannot.
No cleartext PHI on wifi, guest, or vendor VRF. Email/file drop is not a
network control — still call it out.

## HITRUST / 405(d) / CPG — how to talk to compliance

- HITRUST CSF: inherited vs implemented; network owns NWK, NET, OPS slices.
- HHS 405(d) HICP: pick the org size (small/medium/large) and implement
  the **network** practices, not the whole book.
- CISA HPH CPGs: MFA, known-asset inventory, email/web protection, backup
  of **network config**, reduce internet attack surface (no management
  on public IPs).

## Joint Commission / CMS

They will ask "how do you know the infusion pumps cannot reach the
internet" and "who approved the last change on the OR network". Answer
with a diagram, a NAC policy, and a CAB record — not a slide.

## 42 CFR Part 2 (SUD)

Stricter than HIPAA for substance-use records. Separate VRF, separate
admin role, no casual troubleshooting captures.
