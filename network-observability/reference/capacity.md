# Capacity practice

## Headroom policy

Alert at 70% of committed (95th percentile, busy hour), act at 80%,
emergency at 90%. Wireless is AP client-count and airtime, not just
backhaul.

## What to forecast (90 days)

- WAN and internet (per site, per overlay)
- DC spine/leaf and DCI
- Public bandwidth / DIA
- Wireless (clients/AP, RTLS, voice)
- NAC concurrent, VPN concurrent
- Optics inventory and TAC hours
- IP/DHCP scope exhaustion
- License (DNA/SmartNet/flex)

## Math

Use 95th percentile busy-hour, not average. Growth = trailing 6 months
unless a program (new clinic, EHR, PACS) has a stated increment — then
use the program number.

Circuits: order at 90 days for fiber, 30+ for DIA; never at 90%.

## Review

Monthly in the SNM cadence. Output is a table: resource, 95th, headroom,
date-to-70%, action (watch/order/redesign). Tie orders to Jira.
