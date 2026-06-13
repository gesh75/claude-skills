# Experiment Templates

Frameworks and templates for running growth experiments, sample sizing, cohort analysis, and tracking compounding growth.

## Experimentation Framework

```
Hypothesis: "[Channel] will get us 100 users in 2 weeks"

Test:
- Effort: [how much work to set up?]
- Cost: [how much to pay for visibility?]
- Time: [how long to see results?]

Measure:
- Users acquired: [count]
- CAC: [cost per user]
- Activation rate: [% of users who take action]
- ROI: [value gained vs cost]

Decide:
- Double down (scales, low CAC)
- Optimize (good but needs work)
- Kill (doesn't work)
```

## Experiment Template

```markdown
## Experiment: [Clear Title]

### Hypothesis
If we [change], then [users] will [outcome] because [logic]

Example: If we add a "refer a friend" popup, then users will send more invites because peer recommendations are high-trust

### Baseline Metrics
- Current state: [metric A = 10%, metric B = $100]
- Sample size: [min viable]
- Duration: [2 weeks]

### Test Design
- Treatment: [what we're testing]
- Control: [what users see now]
- Randomization: [A/B split]

### Success Criteria
- Metric A increases by 20%+
- Metric B doesn't decrease
- Statistical significance: p < 0.05

### Implementation
[Code changes, copy changes, etc.]

### Results
[Actual data]

### Recommendation
[Ship, iterate, or kill?]
```

## Minimum Sample Size

```
Rule of thumb: 100-1000 conversions per variant

If signup rate = 5% and baseline = 1000 visits:
- Control: 50 signups
- Treatment: 50 signups
- Need 20,000 visits to detect 20% improvement
```

## Cohort Analysis

### Why Cohorts Matter

```
Overall retention: 20% (looks bad)
But by cohort:
- Cohort 1 (Jan): 5% retention (early, bugs)
- Cohort 2 (Feb): 15% retention (improving)
- Cohort 3 (Mar): 35% retention (product fixes)
→ Trend is positive! Product is improving.
```

### Cohort Table Example

```
Cohort      Day1   Day7   Day14  Day30
Jan-2024    100%   45%    30%    15%
Feb-2024    100%   52%    38%    22%
Mar-2024    100%   58%    45%    35%
Apr-2024    100%   62%    51%    40%
```

**Read vertically:** How is this cohort doing?
**Read horizontally:** Are later cohorts improving?

## Growth Compounding

### Power of 1% Daily Growth

```
Day 1:    1 user
Day 10:   1.1^10 = 2.6 users
Day 30:   1.1^30 = 17.5 users
Day 100:  1.1^100 = 13,780 users
Day 365:  1.1^365 = 20 million users!
```

**Key insight:** Small, consistent improvements compound exponentially.

### Growth Metrics to Track

```
Daily:
- New signups
- Activation rate
- Daily active users (DAU)

Weekly:
- Cohort retention
- Viral coefficient
- Engagement metrics

Monthly:
- Monthly active users (MAU)
- Churn rate
- Revenue
```
