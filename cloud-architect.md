---
name: cloud-architect
description: Decision frameworks for cloud architecture — serverless vs containers
  vs VMs, multi-region triggers, managed vs self-hosted, and IaC/cost readiness.
  Use when choosing cloud compute, planning migrations, or scoping multi-region.
metadata:
  model: opus
---

# Cloud Architect

Decision frameworks for choosing cloud compute models, region strategy, and
managed-vs-self-hosted trade-offs. Bias toward the simplest option that meets
the requirement; add complexity only when a concrete trigger demands it.

## When to Activate

- Choosing a compute model for a new service (serverless / containers / VMs)
- Deciding whether a workload needs multi-region or stays single-region
- Evaluating managed services vs self-hosting (databases, queues, search, etc.)
- Planning a migration (lift-and-shift vs re-platform vs re-architect)
- Reviewing an architecture for cost, resilience, or lock-in risk

Do NOT activate for: application code, in-cluster app design, or pure query
tuning (use database-architect / postgres-patterns instead).

## Compute Model Decision

Pick the lowest-operations option whose constraints you can live with.

| Pick | When | Avoid when |
|------|------|-----------|
| **Serverless** (Lambda/Cloud Functions/Container Apps) | Spiky/low-baseline traffic, event-driven glue, fast time-to-market, want zero infra ops | Sustained high throughput (cost crosses over vs containers), >15min jobs, strict tail-latency SLOs sensitive to cold starts, heavy local state |
| **Containers** (ECS/EKS/GKE/Cloud Run) | Steady traffic, long-running services, need portability, mixed language stack, want autoscaling without managing OS | Team has no container/K8s operating capacity; a single tiny service (serverless is cheaper to run) |
| **VMs** (EC2/Compute Engine) | Licensing tied to host, specialized kernels/GPUs/drivers, lift-and-shift of legacy, predictable 24/7 load with reserved/committed pricing | You want to avoid patching/AMI/scaling toil and the workload fits a managed runtime |

Crossover rule of thumb: serverless wins below ~30-40% sustained utilization;
above that, reserved containers/VMs are usually cheaper. Validate with the
provider pricing calculator before committing — do not guess the breakpoint.

Managed container runtime (Cloud Run / App Runner / Container Apps) is the
default middle ground: container portability without running a control plane.
Reach for full K8s only when you need its ecosystem (operators, service mesh,
multi-tenant scheduling) — it is a platform commitment, not a default.

## Multi-Region Decision

Single-region is the default. Go multi-region only when a trigger below is real
and funded — it multiplies cost, data-consistency complexity, and test surface.

| Trigger | Pattern |
|---------|---------|
| RTO ≤ minutes / RPO ≤ seconds for revenue-critical path | Active-active or warm active-passive with async replication |
| Regulated data residency (must serve/store in-region) | Region-pinned deployments + per-region data stores |
| Global users with latency SLO unmet by CDN/edge alone | Read replicas near users; route by geo |
| Single-region outage is an existential business risk | Active-passive DR with tested, automated failover |

If none apply: stay single-region, multi-AZ. Multi-AZ already covers the
common datacenter-failure case at a fraction of multi-region cost. Reach for
multi-region only after multi-AZ + tested backups are in place.

Always quantify RPO/RTO with the business before designing — the number drives
synchronous-vs-async replication and active-active-vs-passive, which dominate cost.

## Managed vs Self-Hosted

Default to managed. Self-host only when a specific blocker forces it.

| Choose managed (RDS/Aurora, MSK, OpenSearch, ElastiCache…) when | Self-host (on K8s/VMs) only when |
|---|---|
| Standard engine/version, want automated backups, patching, failover | You need an engine/version/extension the managed service won't run |
| Team is small or ops capacity is scarce | Cost at your scale clearly beats managed AND you have on-call to run it |
| Compliance is satisfied by the provider's certifications | Strict data control or air-gap rules forbid managed |
| You'd otherwise rebuild HA/backup/monitoring yourself | You need fine-grained tuning the managed knob set can't reach |

Total cost of self-hosting = infra + engineering on-call + patching + incident
risk. Count all four before claiming managed is "too expensive."

## Migration Decision

| Approach | When |
|----------|------|
| **Lift-and-shift** (rehost) | Time-pressured exit from a datacenter; defer optimization to later |
| **Re-platform** (move to managed equivalents) | Want quick managed-service wins (managed DB, load balancer) without rewriting app |
| **Re-architect** (decompose/serverless) | App is the strategic bottleneck and justifies investment; new scale/agility requirements |
| **Strangler-fig** (incremental) | Large monolith that cannot tolerate a big-bang cutover |

## Readiness Checklist

Before approving any cloud design:

- [ ] Compute model justified against the table above (not picked by habit)
- [ ] Single-AZ failure survivable (multi-AZ); multi-region only if a trigger fired
- [ ] RPO/RTO numbers agreed with the business and reflected in the design
- [ ] Cost estimated with the provider calculator at expected AND 3x load
- [ ] IaC for all infra (Terraform/OpenTofu/CDK) — no click-ops in prod
- [ ] Least-privilege IAM; secrets in a secret manager, never in env/files in repo
- [ ] Encryption at rest and in transit on by default
- [ ] Observability planned day one: metrics, structured logs, traces, alarms
- [ ] Autoscaling policy and a hard cost/budget alarm configured
- [ ] Lock-in noted explicitly; portability bought only where it pays for itself
- [ ] Backups exist AND a restore has been tested (untested backup = no backup)

## Cross-References

- Database technology and schema choices → `database-architect`
- LLM-app infrastructure and cost routing → `cost-aware-llm-pipeline`
- Container build/runtime specifics → `docker-patterns`
- CI/CD and rollout mechanics → `deployment-patterns`
