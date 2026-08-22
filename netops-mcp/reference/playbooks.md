# Extra diagnostic playbooks

Always `list_devices` first. Prefer getters over `run_show_command`.

## BGP flap / high prefixes

1. `get_bgp_neighbors` + `get_bgp_neighbors_detail`
2. Check prefix count vs expected; look for session reset reason
3. `get_interfaces_counters` on the peering interface (CRC, drops)
4. `ping_from_device` / `traceroute_from_device` to peer
5. Do not clear BGP as a fix unless the user approves — it is a change

## High CPU / control-plane

`get_environment` → `get_interfaces_counters` (broadcast storms) →
LLDP to find a looped access port. CoPP/control-plane ACL is a change.

## VLAN / MAC miss

`get_mac_address_table` (or equivalent) → `get_lldp_neighbors` →
`get_interfaces` on the access port (errdisable, speed, discards).
STP/loop: do not disable STP to "make it work".

## WAN / underlay

Ping both underlay next-hops from the edge, then the overlay. If
underlay is dead, do not tune SD-WAN policies.

## After a commit

Re-run the same getters you used to diagnose. Ticket the evidence
(`atlassian-ops`). If probes stay red, roll back — do not keep committing.
