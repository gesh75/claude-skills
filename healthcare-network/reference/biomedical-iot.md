# Biomedical / IoMT network practice

Devices: infusion pumps, vents, patient monitors, anesthesia, imaging
modalities, lab analyzers, pharmacy robots, RTLS badges, nurse-call.

Governing ideas: IEC 80001 (IT networks incorporating medical devices),
FDA pre/post-market cybersecurity, clinical engineering ownership,
AAMI guidance. Network does not "patch the pump".

## Inventory is the control

You cannot isolate what you cannot name. Minimum fields: make, model,
software, MAC, serial, clinical dept, VLAN/SGT, ePHI yes/no, vendor
remote-access method, BAA, owner (clinical engineering).

Passive discovery (NAC + CMDB) beats a spreadsheet. Do not nmap a
life-support VLAN as a discovery strategy.

## Isolation pattern

1. Dedicated biomedical zone (see clinical-segmentation.md).
2. Allow only the brokered flows the device needs.
3. Block internet by default. If the vendor cloud is required, pin
   destinations, inspect, and document the residual risk.
4. QoS for real-time monitoring; do not share a congested user SSID.
5. Vendor access: PAM, recorded, time-bound, no persistent any-any VPN.

## What never to do

- Domain-join a modality to the user AD as a convenience
- Put pumps on the same SSID as staff laptops
- Run credentialed vulnerability scans that crash the device
- Store a vendor's "service password" in a public Confluence page
- Capture full packets "to debug HL7" on a unit with patients

## Incident

If a biomedical zone is suspected compromised: isolate the zone,
notify clinical engineering **and** the house supervisor, do not yank
power on life-support devices, preserve metadata, engage the vendor
and privacy. This is a clinical incident command issue, not just IT.
