---
name: autonomous-scanner
description: Daily stock opportunity scanner — runs 8 parallel screeners, filters by market regime, ranks by alpha signal, delivers top 10 setups. Trading intelligence skill for US equities.
---

# Autonomous Scanner

Run once daily (market open). Returns top 10 ranked opportunities across 8 screeners.

## Usage
```
/autonomous-scanner [--universe S&P500|Russell1000|watchlist] [--count 500]
```

## Pipeline

**1. Universe** → S&P 500 (default) | Russell 1000 | watchlist | sector leaders

**2. Liquidity filter** → Min ADTV $1M, price $5–$500, float >10M shares

**3. Eight parallel screeners:**
| # | Screener | Key Signal |
|---|---|---|
| 1 | CANSLIM Growth | EPS+Rev growth >25%, RS >80 |
| 2 | VCP (Volatility Contraction) | Volume dry-up + tight price range |
| 3 | Value / Dividend Income | P/E <15, yield >3%, payout <60% |
| 4 | Post-Earnings Drift (PEAD) | Beat+raise, price +5% day 1 |
| 5 | Short Squeeze | SI >15%, borrow cost high, catalyst |
| 6 | Insider Cluster | 3+ insiders buying within 30 days |
| 7 | Chart Breakouts | BO from base, volume 2x avg |
| 8 | Options Flow | Unusual call sweep, OI spike |

**4. Regime weighting:**
- Bull: weight breakout + momentum screeners
- Bear: weight value + short squeeze
- Sideways: weight mean reversion + income

**5. Output:** Top 10 ranked with entry, stop, target, R:R, conviction score

## Output Format
```
Rank | Ticker | Setup | Entry | Stop | Target | R:R | Conviction
1    | AAPL   | VCP   | 185   | 180  | 200    | 3:1 | High
```

## Files
- Watchlist: `~/.claude/finance/watchlists.json`
- Cache: `~/.claude/finance/scanner-cache.json`
