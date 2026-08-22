# Lucid stencil and color conventions

## Device shapes

| Role | Shape | Fill (dark theme) |
|------|-------|-------------------|
| Core / spine | rectangle, bold | #1f2a33 |
| Dist / leaf | rectangle | #243038 |
| Access / WLC | rounded rect | #243038 |
| Firewall / broker | diamond | #3a2424 |
| WAN / SD-WAN | hexagon | #1f2a33 |
| Circuit | labeled line | #5eead4 stroke |
| Biomedical zone | container | #1a2e28 stroke #5eead4 |
| Guest | container | #2a2a2a |
| User/clinical WS | container | #243044 |

Accent stroke `#5eead4` only for the thing being changed in a cutover
diagram. Everything else stays steel.

## Line styles

- Physical fiber: solid, 2px
- Copper: solid, 1px
- Port-channel / LAG: double or 3px
- Overlay / tunnel: dashed
- Failed / to-be-removed: red, dashed, "X" midpoint
- New in this RFC: teal, annotated "NEW"

## Text

IBM-style sans, 10–12pt device names, 8–9pt interface/circuit. No wrap
that hides the hostname. IPs in /xx, never with passwords.

## Page sizes

- CAB appendix: landscape 16:9, one failure domain per page
- Engineer LLD: as many pages as needed; index page first
- Board: one page, L3 + sites only

## File hygiene

`NET-{site}-{as-is|to-be|cutover}-vN`. The Notion RFC property holds the
canonical URL. Do not email .vsdx as the original.
