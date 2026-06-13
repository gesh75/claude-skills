---
name: finance-based-pricing-advisor
description: Evaluate pricing changes using financial impact analysis - ARPU/ARPA, conversion, churn risk, NRR, and payback. Recommends go/no-go on pricing decisions.
type: interactive
---

# Finance-Based Pricing Advisor

Evaluates a specific pricing change you're considering. Not a pricing strategy tool.

## Required Inputs
1. Current price / plan structure
2. Proposed change (increase / new tier / add-on / usage-based / discount)
3. Current metrics: MRR, customer count, churn rate, conversion rate, CAC

## Impact Framework

**Revenue math per change type:**

| Change | Formula |
|---|---|
| Price increase | ΔRevenue = (new_price − old_price) × customers × (1 − estimated_churn_increase%) |
| New premium tier | ΔRevenue = conversion_to_new_tier% × current_customers × price_delta |
| Add-on | ΔRevenue = attach_rate% × customers × add_on_price |
| Usage-based | ΔRevenue = avg_usage × per_unit_price − current_flat_fee (per customer) |
| Discount | ΔRevenue = −discount% × MRR + conversion_lift% × new_customers × MRR_per_customer |

## Key Thresholds
- Price increase viable if: churn_increase < revenue_lift (breakeven analysis)
- New tier viable if: attach rate >15% within 90 days
- Discount viable if: payback period <CAC payback on organic customers

## Go/No-Go Criteria
- 🟢 Go: net MRR impact positive within 3 months
- 🟡 Test: run 30-day A/B test with 20% of new signups
- 🔴 No-go: projected churn increase exceeds revenue lift OR CAC payback extends >6 months

## Output Format
```
Change: [description]
Projected MRR impact: +/- $X/mo
Churn risk: Low / Medium / High ([X]% estimated increase)
Break-even: [N] months
Recommendation: Go / A/B Test / No-go
Key assumption to validate: [one thing]
```
