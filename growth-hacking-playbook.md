---
name: growth-hacking-playbook
description: AARRR funnel, viral loops, retention mechanics, and growth-experiment design. Use when planning user acquisition/activation/retention, designing growth experiments, diagnosing a funnel bottleneck, or building a PLG/viral-loop strategy.
category: Marketing & Growth
version: 1.0.0
---

# Growth Hacking Playbook: From Zero to Viral

This skill teaches how to systematically grow products using the AARRR framework. Learn viral mechanics, retention optimization, and how to run growth experiments that compound over time.

## When to Activate

Use this skill when:
- Planning or auditing a growth strategy for a product
- A specific funnel stage is leaking (low activation, poor retention, weak referral)
- Designing a viral loop or referral mechanic
- Setting up growth experiments, cohort analysis, or metric dashboards
- Deciding which acquisition channels to test for a given product type
- Building a product-led growth (PLG) motion

## The AARRR Funnel

### Framework Overview

```
Acquisition → Activation → Retention → Referral → Revenue
   ↓            ↓            ↓           ↓         ↓
 Find users  First wins  Keep coming  Tell friends Monetize
```

**Key principle:** Optimize each stage before moving to the next. No point acquiring users if activation is broken.

### Stage Summaries

| Stage | Goal | Primary metric |
|-------|------|----------------|
| **Acquisition** | Get your first users | CPA, channel ROI |
| **Activation** | First "aha moment" (<10 min) | Activation rate, time-to-activation |
| **Retention** | Keep users coming back | Day 1 / 7 / 30 retention, cohort curves |
| **Referral** | Users bring friends | Viral coefficient (k), invite rate |
| **Revenue** | Monetize the userbase | MRR, ARPU, LTV, churn |

**Acquisition:** Channels include Product Hunt, Indie Hackers, Reddit, Twitter/X, guest posts/podcasts, paid ads.

**Activation:** Activation = first "aha moment," usually under 10 minutes (Slack: first message; Notion: first page; Figma: first design; Stripe: first payment). Optimize the onboarding path to the first win.

**Retention:** Driven by habit loops, regular value, community, progress mechanics, and exclusivity. Good products flatten at 30%+ retention; great products at 50%+.

**Referral:** A viral coefficient `k > 1` means exponential growth; `k < 1` decays. Built via invite mechanics (Dropbox storage incentive, LinkedIn profile views, Slack history unlock).

**Revenue:** Models include SaaS subscription, freemium, usage-based, and marketplace commission.

> Full per-stage channel lists, examples, optimization tactics, and viral-loop mechanics: see [Channel Tactics reference](growth-hacking-playbook-reference/channel-tactics.md).

## Decision Guide: Find the Bottleneck

Diagnose which stage leaks most before optimizing:

```
1. Are users arriving?        → No  → fix ACQUISITION (test channels)
2. Do they reach first value? → No  → fix ACTIVATION (shorten onboarding)
3. Do they come back?         → No  → fix RETENTION (habit loops, value)
4. Do they invite others?     → No  → fix REFERRAL (viral loop design)
5. Do they pay?               → No  → fix REVENUE (pricing, upgrade triggers)
```

Optimize the earliest broken stage first — a leak upstream wastes all downstream effort.

## Viral Loop Design (Quick Template)

```
1. Core user action: [what users do]
2. Invite mechanism: [how they invite]
3. Friction to invite: 1 click = best, 3 = acceptable, 5+ = too much
4. Value for invitee: [why should they join?]
5. Loop closure: [does new user repeat action?]
```

> Worked loop examples (Dropbox, LinkedIn, Twitter) and activation/retention deep tactics: [Channel Tactics reference](growth-hacking-playbook-reference/channel-tactics.md).

## Running Experiments (Quick Loop)

```
Hypothesis → Test (effort/cost/time) → Measure (users, CAC, activation, ROI) → Decide (double down / optimize / kill)
```

> Full experiment template, minimum sample-size math, cohort analysis, and compounding model: [Experiment Templates reference](growth-hacking-playbook-reference/experiment-templates.md).
> Metric definitions and formulas (viral coefficient, retention, LTV, significance): [Metric Formulas reference](growth-hacking-playbook-reference/metric-formulas.md).

## Checklist: Growth Hacking Ready

- ✓ Defined AARRR stages with metrics
- ✓ Identified bottleneck (which stage leaks most?)
- ✓ Built or improved activation
- ✓ Tested 3+ acquisition channels
- ✓ Running cohort analysis
- ✓ Tracking viral coefficient
- ✓ Running 1-2 experiments/week
- ✓ Team aligned on growth priorities
- ✓ Monitoring CAC vs LTV
- ✓ Celebrating small wins

Growth is discipline, not luck. Measure, iterate, scale.

## Reference Files

- [growth-hacking-playbook-reference/channel-tactics.md](growth-hacking-playbook-reference/channel-tactics.md) — per-stage acquisition channels, activation/retention/referral/revenue deep tactics, viral-loop mechanics, channels by product type, and the full PLG playbook.
- [growth-hacking-playbook-reference/experiment-templates.md](growth-hacking-playbook-reference/experiment-templates.md) — experimentation framework, full experiment template, minimum sample-size math, cohort analysis, and growth compounding.
- [growth-hacking-playbook-reference/metric-formulas.md](growth-hacking-playbook-reference/metric-formulas.md) — quantitative formulas for activation, retention, viral coefficient, revenue, acquisition, sample size, and compounding.
