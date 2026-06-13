---
name: database-architect
description: Decision frameworks for data-layer design — data-store selection by
  workload, schema and index rules, and normalization-vs-denormalization. Use
  when choosing a database, modeling a schema, or re-architecting a data layer.
metadata:
  model: opus
---

# Database Architect

Decision frameworks for choosing a data store, modeling schemas, and deciding
how far to normalize. Start from access patterns and scale targets, not from a
favorite technology. For engine-specific tuning and migration mechanics, defer
to the cross-referenced skills rather than duplicating them here.

## When to Activate

- Selecting a database technology for a new service
- Modeling a schema, choosing keys, or planning partitions/sharding
- Deciding normalization level for a given read/write pattern
- Re-architecting an existing data layer or planning a cross-engine migration

Do NOT activate for: tuning an existing query (use `postgres-patterns`) or
executing a migration toolchain (use `database-migrations`).

## Before Choosing Anything

Answer these first — they drive every decision below:

1. **Access patterns** — what are the top 5 queries by frequency? Point lookups,
   range scans, joins, aggregations, full-text, graph traversal?
2. **Read/write ratio** and absolute throughput (ops/sec at peak).
3. **Consistency need** — strong (read-your-writes) or eventual acceptable?
4. **Scale target** — data volume and growth rate over 12–24 months.
5. **Relationships** — highly relational, hierarchical, document-shaped, or
   connection-heavy (graph)?

## Data-Store Selection

| Store type | Best for | Examples | Avoid when |
|------------|----------|----------|-----------|
| **Relational** | Transactional data with relationships, joins, strong consistency, ad-hoc queries | PostgreSQL, MySQL | Schema-less/rapidly-shifting shape; single-table extreme write scale |
| **Document** | Aggregate-oriented entities read/written whole; flexible/nested schema | MongoDB, Firestore | Data is highly relational and you need multi-entity joins/transactions |
| **Key-value** | Cache, sessions, feature flags, point lookups by known key at high QPS | Redis, DynamoDB | You need queries on non-key attributes or range scans across keys |
| **Wide-column** | Massive write throughput, time-partitioned, known query path | Cassandra, ScyllaDB, Bigtable | Ad-hoc queries or strong cross-row consistency needed |
| **Columnar / OLAP** | Analytical scans/aggregations over large datasets | ClickHouse, BigQuery, Redshift | High-rate single-row OLTP updates |
| **Time-series** | Append-heavy metrics/events queried by time window | TimescaleDB, InfluxDB | General-purpose relational workloads |
| **Graph** | Many-hop relationship traversals (fraud, social, recommendations) | Neo4j, Neptune | Relationships are shallow — a relational FK join is simpler/faster |
| **Search** | Full-text relevance ranking, faceting, fuzzy match | Elasticsearch, OpenSearch | As a system of record (use it as a derived index, not the source of truth) |

Decision rules:

- **Default to PostgreSQL.** It covers relational + JSONB documents + full-text +
  time-series (Timescale) + vectors (pgvector) up to substantial scale. Add a
  specialized store only when a measured limit forces it.
- **Polyglot persistence costs operational overhead.** Each extra engine adds
  on-call, backup, and consistency-sync burden. Add one only for a workload the
  primary store demonstrably can't serve.
- **Strong vs eventual consistency** is the first fork: if you need
  read-your-writes on the critical path, that rules out most eventually-consistent
  stores for that data.

## Schema & Key Decisions

- **Primary keys:** prefer a stable surrogate key. Use a natural key only when it
  is genuinely immutable. UUIDv7 / ULID over random UUIDv4 for index locality on
  high-insert tables.
- **Foreign keys + constraints ON in the database** by default — let the engine
  enforce integrity; application checks alone drift.
- **Partition** when a table grows past tens of millions of rows AND queries
  filter on the partition key (usually time or tenant). Don't partition early.
- **Shard** only when a single primary can't hold the write volume or dataset.
  Choose a shard key that spreads writes evenly and matches the dominant query —
  resharding later is expensive.
- **Multi-tenancy:** shared-schema + tenant_id (cheapest, default) → schema-per-
  tenant (isolation) → database-per-tenant (strongest isolation, highest ops).
  Move down the list only when isolation/compliance demands it.

## Index Decision Rules

- Index columns used in WHERE, JOIN, and ORDER BY of your top queries — not every
  column. Each index slows writes and consumes storage.
- **Composite index column order:** equality predicates first, then range, then
  sort column. A covering index (includes selected columns) enables index-only
  scans.
- Use **partial indexes** for queries that always filter on a constant (e.g.
  `WHERE status = 'active'`).
- Match the index type to the access pattern: B-tree (default), GIN (JSONB /
  full-text / array containment), GiST (geospatial / ranges), BRIN (huge
  naturally-ordered tables).
- Validate every index against a real `EXPLAIN` plan; drop indexes that the
  planner never uses.

## Normalization vs Denormalization Checklist

Start normalized (3NF). Denormalize deliberately, only when these hold:

- [ ] A read path is hot and the join/aggregation is a proven bottleneck (measured, not assumed)
- [ ] The read/write ratio is heavily read-skewed (denormalized data is cheaper to read, costlier to keep consistent)
- [ ] You have a concrete plan to keep the duplicate data consistent (triggers, app logic, or a refresh job) and accept the staleness window
- [ ] A materialized view or cache wouldn't solve it more cheaply first

Default leanings:

- **OLTP** → normalized; integrity and write-efficiency dominate.
- **OLAP / reporting** → denormalized (star schema, pre-aggregates); read speed dominates.
- **Middle ground** → keep the normalized source of truth, add materialized views
  or a derived read model (CQRS) rather than denormalizing the base tables.

## Cross-References

- PostgreSQL query tuning, indexing internals, RLS → `postgres-patterns`
- Migration tooling, zero-downtime cutover, rollback mechanics → `database-migrations`
- Analytical/columnar specifics → `clickhouse-io`
- Compute/region/managed-vs-self-hosted for the DB host → `cloud-architect`

## Output When Designing

Provide: technology choice with rationale and rejected alternatives; schema with
keys, relationships, and constraints; index list tied to specific queries;
partition/shard plan if scale warrants; consistency model; and a migration
outline (recommend only — execute via `database-migrations`).
