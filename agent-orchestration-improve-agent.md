---
name: agent-orchestration-improve-agent
description: "Systematic improvement of existing agents through performance analysis, prompt engineering, and continuous iteration."
---

# Agent Performance Optimization Workflow

Improve an existing agent with a data-driven loop: **baseline → change → A/B → rollout → rollback**.
Every change is measured against a baseline and reversible.

## Use this skill when

- Improving an existing agent's reliability, accuracy, or cost
- Diagnosing failure modes (prompt quality, tool misuse, format errors)
- Running structured A/B tests or eval suites before shipping a prompt change

## Do not use this skill when

- Building a brand-new agent from scratch (use the `planner` / `architect` agents)
- No metrics, feedback, or test cases exist yet — collect those first
- The task is unrelated to agent quality

## The 5-Step Loop

### 1. Baseline — measure before you touch anything

Run the agent against a fixed, representative test set and record numbers. Without a
baseline you cannot tell whether a change helped.

Capture per run:

- Task success rate (binary pass/fail against expected output)
- Correctness / accuracy on graded tasks
- Tool-use efficiency (right tool, no redundant calls)
- Latency (time to first token, total time)
- Token consumption and cost per task
- Failure signals: user corrections, retries, abandonment

Classify failures by root cause so fixes are targeted:

| Failure mode | Typical fix |
|---|---|
| Instruction misunderstanding | Sharpen role/task wording |
| Output format errors | Add explicit schema + a parsed example |
| Context loss in long runs | Summarize/compact, reduce prompt bloat |
| Tool misuse | Clarify tool descriptions and when-to-use rules |
| Constraint violations | Add explicit guardrails / refusals |
| Edge-case mishandling | Add few-shot examples covering the case |

**Tooling:** snapshot baseline behavior with the `evalview` MCP or the `eval-harness`
skill / `/eval` command. Persist the baseline numbers (e.g. via the `continuous-learning`
skill or a checked-in results file) so later runs compare against the same reference.

```text
Baseline (record and store):
- Task success rate:      [X%]
- Avg corrections/task:   [Y]
- Tool-call efficiency:   [Z%]
- Avg latency:            [Xms]
- Cost per task:          [$X]
```

### 2. Change — make one targeted improvement

Change one thing at a time so the A/B test attributes the result correctly. Common levers:

- **Role definition:** one-sentence mission, explicit do/don't, success criteria.
- **Reasoning structure:** add explicit step-by-step or self-verification checkpoints
  for tasks that fail on logic, not knowledge.
- **Few-shot examples:** curate diverse passing cases plus previously failed cases;
  order simple → complex; annotate the key decision point.
- **Output format:** specify an exact schema and forbid text outside it; provide one
  filled example.
- **Tool guidance:** tighten tool descriptions and selection rules.

Keep a changelog entry describing the single change and its hypothesis.

### 3. A/B — compare improved vs. baseline

Run both variants over the same test set and compare.

- Same fixed test set for A (current) and B (changed)
- Enough tasks to be meaningful (aim for ≥100 where feasible)
- Blind grading where a human is in the loop, plus automated scoring
- Compare success rate, cost, latency, and any safety metric

**Tooling:** the `evalview` MCP supports snapshot comparison across agent versions; use
it to diff B against the stored baseline. For correctness-sensitive changes, route a
sample through the `code-reviewer` (and `security-reviewer` for sensitive logic) agents
to sanity-check generated output.

A change ships only if B beats A on the target metric **without** regressing safety, cost,
or latency beyond agreed bounds.

### 4. Rollout — deploy in controlled stages

Never flip 100% at once.

1. Internal validation (small slice of traffic)
2. Limited beta (e.g. ~20%)
3. Gradual ramp (20% → 50% → 100%)
4. Observation window with monitoring before declaring done

Version prompts in git: `agent-name-v[MAJOR].[MINOR].[PATCH]` with a changelog and the
metrics for each version, so any version is reproducible and comparable.

### 5. Rollback — revert fast if metrics regress

Define triggers up front and wire them to monitoring so reverting is mechanical, not a
judgment call:

```text
Rollback triggers:
- Success rate drops >10% from baseline
- Critical errors increase >5%
- Cost per task increases >20%
- Any safety/constraint violation

Rollback steps:
1. Detect via monitoring/alert
2. Switch traffic to the previous stable version
3. Root-cause the regression
4. Fix, re-A/B, then re-attempt rollout
```

## Done When

- Target metric improved by a meaningful margin vs. baseline (e.g. ≥15% success,
  ≥25% fewer corrections)
- No regression in safety, cost, or latency beyond agreed bounds
- New version tagged in git with metrics and changelog recorded
- Rollback path verified

## Keep Iterating

Each loop builds on the last. Re-baseline after a successful rollout so the next change
is measured against the new, higher bar. Feed recurring lessons back into the agent's
examples and guardrails (the `continuous-learning` skill can capture these automatically).
