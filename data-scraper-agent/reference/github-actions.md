# Data Scraper Agent — Scheduling, Config & Requirements

GitHub Actions workflow, config.yaml template, and requirements.txt. Referenced from SKILL.md Steps 9-10.

---

## Step 9: GitHub Actions Workflow

```yaml
# .github/workflows/scraper.yml
name: Data Scraper Agent

on:
  schedule:
    - cron: "0 */3 * * *"  # every 3 hours — adjust to your needs
  workflow_dispatch:        # allow manual trigger

permissions:
  contents: write   # required for the feedback-history commit step

jobs:
  scrape:
    runs-on: ubuntu-latest
    timeout-minutes: 20

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"
          cache: "pip"

      - run: pip install -r requirements.txt

      # Uncomment if Playwright is enabled in requirements.txt
      # - name: Install Playwright browsers
      #   run: python -m playwright install chromium --with-deps

      - name: Run agent
        env:
          NOTION_TOKEN: ${{ secrets.NOTION_TOKEN }}
          NOTION_DATABASE_ID: ${{ secrets.NOTION_DATABASE_ID }}
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
        run: python -m scraper.main

      - name: Commit feedback history
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add data/feedback.json || true
          git diff --cached --quiet || git commit -m "chore: update feedback history"
          git push
```

---

## Step 10: config.yaml Template

```yaml
# Customise this file — no code changes needed

# What to collect (pre-filter before AI)
filters:
  required_keywords: []      # item must contain at least one
  blocked_keywords: []       # item must not contain any

# Your priorities — AI uses these for scoring
priorities:
  - "example priority 1"
  - "example priority 2"

# Storage
storage:
  provider: "notion"         # notion | sheets | supabase | sqlite

# Feedback learning
feedback:
  positive_statuses: ["Saved", "Applied", "Interested"]
  negative_statuses: ["Skip", "Rejected", "Not relevant"]

# AI settings
ai:
  enabled: true
  model: "gemini-2.5-flash"
  min_score: 0               # filter out items below this score
  rate_limit_seconds: 7      # seconds between API calls
  batch_size: 5              # items per API call
```

---

## Requirements Template

```
requests==2.31.0
beautifulsoup4==4.12.3
defusedxml==0.7.1      # safe XML parsing (XXE-hardened) for RSS feeds
lxml==5.1.0
python-dotenv==1.0.1
pyyaml==6.0.2
notion-client==2.2.1   # if using Notion
# playwright==1.40.0   # uncomment for JS-rendered sites
```
