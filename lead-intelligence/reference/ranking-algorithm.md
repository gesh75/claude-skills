# Stage 2: Mutual Ranking — Full Algorithm

For each scored target, analyze the user's social graph to find the warmest path.

## Algorithm

1. Pull user's X following list and LinkedIn connections
2. For each high-signal target, check for shared connections
3. Rank mutuals by:

| Factor | Weight |
|--------|--------|
| Number of connections to targets | 40% — highest weight, most connections = highest rank |
| Mutual's current role/company | 20% — decision maker vs individual contributor |
| Mutual's location | 15% — same city = easier intro |
| Industry alignment | 15% — same vertical = natural intro |
| Mutual's X handle / LinkedIn | 10% — identifiability for outreach |

## Weighted Bridge Ranking

Treat this as the canonical network-ranking stage for lead intelligence. Do not run a separate graph skill when this stage is enough.

Given:
- `T` = target leads
- `M` = your mutuals / existing connections
- `d(m, t)` = shortest hop distance from mutual `m` to target `t`
- `w(t)` = target weight from signal scoring

Compute the base bridge score for each mutual:

```text
B(m) = Σ_{t ∈ T} w(t) · λ^(d(m,t) - 1)
```

Where:
- `λ` is the decay factor, usually `0.5`
- a direct connection contributes full value
- each extra hop halves the contribution

For second-order reach, expand one level into the mutual's own network:

```text
B_ext(m) = B(m) + α · Σ_{m' ∈ N(m) \\ M} Σ_{t ∈ T} w(t) · λ^(d(m',t))
```

Where:
- `N(m) \\ M` is the set of people the mutual knows that you do not
- `α` is the second-order discount, usually `0.3`

Then rank by response-adjusted bridge value:

```text
R(m) = B_ext(m) · (1 + β · engagement(m))
```

Where:
- `engagement(m)` is a normalized responsiveness score
- `β` is the engagement bonus, usually `0.2`

Interpretation:
- Tier 1: high `R(m)` and direct bridge paths -> warm intro asks
- Tier 2: medium `R(m)` and one-hop bridge paths -> conditional intro asks
- Tier 3: no viable bridge -> direct cold outreach using the same lead record

## Output Format

```
MUTUAL RANKING REPORT
=====================

#1  @mutual_handle (Score: 92)
    Name: Jane Smith
    Role: Partner @ Acme Ventures
    Location: San Francisco
    Connections to targets: 7
    Connected to: @target1, @target2, @target3, @target4, @target5, @target6, @target7
    Best intro path: Jane invested in Target1's company

#2  @mutual_handle2 (Score: 85)
    ...
```
