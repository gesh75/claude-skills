---
name: lucid-diagrams
description: Produce Lucidchart/Lucidspark network diagrams — physical, L2, L3, overlay, healthcare clinical. Use when the user asks for Lucid, Visio-quality topology, stakeholder drawings, or to structure layers/stencils. For Mermaid/PlantUML as code, use network-diagrams.
origin: snm-pack
---

# Lucid diagrams (network)

Lucid is the **stakeholder picture**. Layers beat giant stencils. If the
user needs versionable text, also emit Mermaid via `network-diagrams`.

## When to use

- "Draw this in Lucid / Lucidchart / Lucidspark"
- As-is / to-be campus, DC, WAN, internet edge, clinical zones
- CAB or board appendix diagrams
- Whiteboard a cutover in Lucidspark, then promote to Chart

## Layer contract (every Chart)

| Layer | Content | Default |
|-------|---------|---------|
| 00-background | sites, rooms, tiles | on |
| 10-physical | racks, cables, optics, DCs, circuits | on |
| 20-L2 | VLANs, port-channels, STP/MLAG domains | off |
| 30-L3 | VRFs, SVIs, BGP/OSPF, WAN | on |
| 40-overlay | SD-WAN, SGT/ACI, ZTA tunnels | off |
| 50-clinical | biomedical / EHR / voice zones (healthcare) | off |
| 60-labels | names, circuit IDs, IPs (no secrets) | on |
| 90-legend | symbols, line styles, revision | on |

Never put all layers on for a CIO. Pick 00+30+90 for exec, 10+20+30 for
engineers, 30+40+50 for security/clinical.

Conventions: [reference/stencil-conventions.md](reference/stencil-conventions.md).

## Drawing rules

1. **Left-to-right or top-to-bottom failure domains**, not art.
2. One line style per kind: solid physical, dashed overlay, red = cutover.
3. Devices named as in AAA/CMDB (`dfw-c-core-01`), not "Core Switch".
4. Circuits show carrier + ID + bandwidth on the line.
5. Revision block: date, RFC, author. Old rev moved to a "archive" page.
6. No vendor marketing shapes that hide the actual platform.
7. Healthcare: zone color = segmentation table, not interior-design pastels.

## Lucidspark vs Chart

- Spark: cutover sequencing, CAB debate, unknown-as-is.
- Chart: the thing you embed in Notion/Confluence after the fight.

Promote Spark → Chart only when names are real.

## If you cannot call Lucid APIs

Deliver: (1) a layer-by-layer inventory, (2) Mermaid/PlantUML equivalent,
(3) a paste-ready shape list (hostname, role, neighbors, circuit).
Do not fake a Lucid URL.

## Output

```text
DIAGRAM
- title · type (as-is|to-be|cutover) · audience

LAYERS
- which are on, and why

SHAPE LIST
- id · hostname · role · site · neighbors

EMBEDS
- Notion page · Confluence · RFC
```

## Reference Files
- [reference/stencil-conventions.md](reference/stencil-conventions.md)
