# Metric Formulas

Quantitative reference for the core growth metrics across the AARRR funnel.

## Activation

```
Activation rate = (signups who achieve first action) / (total signups)

Example: 1000 signups, 400 reach aha moment = 40% activation rate
```

## Retention

```
Day N retention = (users active on day N) / (users who signed up on day 0)

Benchmark curve:
Day 1: 100% (just signed up)
Day 7: ~40% (typical)
Day 30: ~10% (rough benchmark)

Good product: Flattens out at 30%+
Great product: Flattens out at 50%+
```

## Viral Coefficient

```
k = average invites per user × signup rate

k > 1 = exponential growth
k = 0.5 = linear decay
k = 0 = no virality
```

Related referral metrics:
- Invite rate (% of users who invite)
- Conversion rate (% of invites → signups)
- Sharing hooks (emails sent, link clicks)

## Revenue

```
MRR  = monthly recurring revenue
ARPU = average revenue per user
LTV  = lifetime value
Churn rate = (customers lost in period) / (customers at start of period)
```

## Acquisition

```
CPA / CAC = total acquisition spend / users acquired
Channel ROI = value gained vs cost
```

## Statistical Significance / Sample Size

```
Rule of thumb: 100-1000 conversions per variant

If signup rate = 5% and baseline = 1000 visits:
- Control: 50 signups
- Treatment: 50 signups
- Need 20,000 visits to detect 20% improvement

Target significance: p < 0.05
```

## Compounding

```
Power of 1% daily growth:
Day 1:    1 user
Day 10:   1.1^10 = 2.6 users
Day 30:   1.1^30 = 17.5 users
Day 100:  1.1^100 = 13,780 users
Day 365:  1.1^365 = 20 million users!
```

**Key insight:** Small, consistent improvements compound exponentially.
