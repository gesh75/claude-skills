# Scoring model (1–5)

Score each lens. **Approve** requires all lenses ≥ 3 and no lens at 1.
**Approve-with-conditions** allows one 2 if treatment is funded and dated.
Any 1 is **rework** or **reject**.

## Availability

| 5 | Dual path, tested failover, documented RTO/RPO, no hidden L2 loops |
| 4 | Dual path, failover tested in lab, production test scheduled |
| 3 | Dual path on paper, failover untested, known maintenance impact |
| 2 | Partial redundancy; a single module/circuit/site takes a service down |
| 1 | Obvious SPOF on a production or clinical path |

## Security

| 5 | Segmented, NAC, least-privilege mgmt, logged, reviewed |
| 4 | Segmentation + NAC plan with a dated rollout |
| 3 | VRFs/VLANs exist; east-west still messy; mgmt isolated |
| 2 | Flat or shared; vendor access unmanaged |
| 1 | Management exposed, default creds, or ePHI on user VLAN |

## Operability

| 5 | Source-of-truth config, telemetry, runbooks, on-call that has done this |
| 4 | Tooling in place; runbooks draft; on-call named |
| 3 | Some monitoring; tribal knowledge still required |
| 2 | Hero-dependent; backups untested |
| 1 | No backups, no monitoring, no as-built |

## Cost (3-year TCO honesty)

| 5 | Capex + opex + optics + TAC + power + refresh dated; 20% contingency |
| 4 | TCO present, contingency 10% |
| 3 | BoM complete; opex estimated |
| 2 | Hardware-only quote |
| 1 | Number from a slide with no BoM |

## Compliance (healthcare / regulated)

| 5 | Control mapping (HIPAA/HITRUST/CPG) with evidence owners |
| 4 | Mapping exists; a few gaps with treatments |
| 3 | Aware; BAAs and logging called out |
| 2 | "We'll handle compliance later" |
| 1 | PHI path unidentified |

Write the numeric score **and** one sentence of evidence per lens.
