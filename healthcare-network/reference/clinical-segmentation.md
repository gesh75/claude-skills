# Clinical segmentation pattern

Goal: a biomedical device cannot talk to a guest iPad, a HVAC controller,
or the open internet, and a compromised WOW cannot scan imaging modalities.

## Zone model (default)

```
                    +------------------+
   Guest/Patient ---| Internet VRF     |
                    +------------------+
   Users/WOW -------| Clinical user    |--+
                    +------------------+  |
   Voice/RTLS ------| Real-time        |  |  broker
                    +------------------+  |  (FW + NAC +
   Biomed/IoMT -----| Biomedical       |--+   reverse proxy)
                    +------------------+  |
   EHR/PACS/core ---| Clinical apps    |--+
                    +------------------+
   BAS/cameras -----| Building / OT    |
                    +------------------+
   Mgmt/OOB --------| Management       |
                    +------------------+
```

East-west default-deny between zones. Allow-lists are **named flows**,
not "VLAN 20 to VLAN 30".

## Named flows to inventory

- Modality → PACS/VNA (DICOM)
- Infusion / monitoring → device vendor cloud **or** on-prem broker (prefer broker)
- WOW → EHR, print, meds cabinets
- Nurse call / RTLS → location engine, alerting
- Care Everywhere / HIE → DMZ
- MyChart / telehealth → DMZ + WAF
- Vendor support → PAM jump, time-bound, recorded

If a vendor demands "any-any to the pump VLAN for support", refuse.
Give them a jump host and a change window.

## Wireless

- Separate SSIDs/PSK is not segmentation. Use 802.1X + dynamic VLAN/SGT
  or a microtunnel overlay.
- Voice and RTLS need survey, QoS, and sticky roaming — treat as a
  project, not an SSID checkbox.
- Patient/guest: client isolation + internet only.

## Exceptions

Every exception: ticket, expiry, owner, compensating control. MAB for a
pump is fine; MAB for a Windows PC is not.
