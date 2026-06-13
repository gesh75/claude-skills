# Channel Tactics

Deep channel playbook for the AARRR stages: acquisition channels, viral loop mechanics, activation optimization, retention levers, channel experimentation, and product-led growth.

## Acquisition Channels (Stage 1 detail)

**Channels:**
- Product Hunt (launch)
- Indie Hackers community
- Relevant Reddit communities (/r/[industry])
- Twitter/X threads
- Guest posts on blogs
- Guest podcasts
- Paid ads (when ready)

**Metrics:**
- Cost per acquisition (CPA)
- Traffic source
- Channel ROI

**Example:** 1000 users acquired, 100 from Product Hunt, 300 from Twitter, 200 from organic search

## Activation (Stage 2 detail)

**Goal:** Get users to experience the core value immediately

**Activation = First "aha moment" (usually <10 minutes)**

**Examples:**
- Slack: Send/receive first message
- Notion: Create first page
- Figma: Upload first design
- Stripe: Process first payment

**Optimization tactics:**
- Onboarding flow: shortest path to first win
- Skip the signup form if possible (OAuth, magic links)
- Progress indicators (visual progress)
- Tooltips on first use
- Celebrate first action (confetti, badges)

**Metrics:**
- Activation rate (% of signups who achieve first action)
- Time to activation
- Drop-off rate by step

**Example:** 1000 signups, 400 reach aha moment = 40% activation rate

## Retention (Stage 3 detail)

**Goal:** Keep users coming back

**Retention curve patterns:**
```
Day 1: 100% (just signed up)
Day 7: ~40% (typical)
Day 30: ~10% (rough benchmark)

Good product: Flattens out at 30%+
Great product: Flattens out at 50%+
```

**Retention mechanics:**
- Habit loops (email reminders, notifications)
- Regular value (weekly digest, new content)
- Community (users help each other)
- Progress (streak, points, level)
- Exclusivity (early access, beta)

**Metrics:**
- Day 1 retention (next day)
- Day 7 retention
- Day 30 retention
- Cohort retention curves

## Referral (Stage 4 detail)

**Goal:** Users bring friends (viral coefficient > 1 = exponential growth)

**Viral loops:**
1. User invites friend
2. Friend signs up
3. Friend invites another friend
4. Exponential growth

**Mechanics:**
- Dropbox model: "Free storage for you and your friend"
- LinkedIn: "See who viewed your profile" (invite to learn more)
- Slack: "See full conversation history" (invite workspace members)

**Viral coefficient:**
```
k = average invites per user × signup rate

k > 1 = exponential growth
k = 0.5 = linear decay
k = 0 = no virality
```

**Metrics:**
- Viral coefficient (k)
- Invite rate (% of users who invite)
- Conversion rate (% of invites → signups)
- Sharing hooks (emails sent, link clicks)

## Revenue (Stage 5 detail)

**Goal:** Monetize the userbase

**Models:**
- SaaS (monthly/annual subscription)
- Freemium (free + paid tier)
- Usage-based (pay per action)
- Commission (marketplace model)

**Metrics:**
- Monthly recurring revenue (MRR)
- Average revenue per user (ARPU)
- Lifetime value (LTV)
- Churn rate

## Viral Loop Mechanics

### Classic Viral Loop: Dropbox

```
User action: "Upload file"
           ↓
   Invite to share access
           ↓
    Friend clicks link
           ↓
 Friend signs up for Dropbox
           ↓
New user uploads file (loop repeats)
```

### Embedded Virality: LinkedIn

```
User action: Create profile with photo
           ↓
Network sees update (notification)
           ↓
  Friends view profile
           ↓
  "Unlock full profile" (need account)
           ↓
Friend signs up
```

### Social Sharing: Twitter

```
User action: Tweet with link
           ↓
   Followers see tweet
           ↓
  Some click and visit
           ↓
Users impressed, share again (amplification)
```

### Design Your Viral Loop

Template:
```
1. Core user action: [what users do]
2. Invite mechanism: [how they invite]
3. Friction to invite: [how easy is it?]
   - 1 click = best
   - 3 clicks = acceptable
   - 5+ clicks = too much
4. Value for invitee: [why should they join?]
5. Loop closure: [does new user repeat action?]
```

## Activation Optimization

### Onboarding Flow: Principles

**Principle 1: Skip Optional Steps**
```
Bad: Email → Verify Email → Create Profile → Setup Preferences → Start
Good: [Straight to first value]
```

**Principle 2: One Goal Per Screen**
```
Bad: [Big form with 10 fields]
Good: [Step 1: Name] [Step 2: Email] [Step 3: Password]
```

**Principle 3: Progress Indication**
```
[Step 1/5] ████░░░░░░
Show % complete + estimated time
```

**Principle 4: Celebrate First Win**
```
"🎉 You created your first project!"
"Invite team members to collaborate" ← next action
```

### A/B Testing Activation

```
CONTROL: Traditional signup form
TEST A: "Sign up with Google"
TEST B: Magic link (no password)

Metric: % who complete activation

Expected: TEST B > TEST A > CONTROL
```

## Retention Levers

### Lever 1: Habit Loops

```
Trigger (external) → Routine (your app) → Reward
    ↓                      ↓               ↓
 Email              Open app,          Get value
notification      check status       (satisfaction)
                        ↓
                     Variable reward
                    (sometimes bonus)
```

**Implementation:**
- Daily email digest (habit building)
- Push notification at best time (trigger)
- Streak counter (reward)
- Variable bonus (randomness = engagement)

### Lever 2: Community

```
Users help each other → Social bonds form → Stickiness increases
```

**Examples:**
- Forum/discussion board
- "Top contributors" leaderboard
- User-generated content
- Moderation by power users

### Lever 3: Progress & Achievement

```
Complete task → Unlock badge/level → Show friends → Stay engaged
```

**Examples:**
- Duolingo streaks
- GitHub contributions
- Fitness app milestones
- Game levels

### Lever 4: Content Freshness

```
New content every week → Users check back → Routine forms
```

**Examples:**
- New challenges (Wordle)
- New curated content (Substack, TikTok)
- User-generated content feeds

## Channel Experimentation

### Top Channels by Product Type

**B2B SaaS:**
- Product Hunt (launch)
- HackerNews (technical)
- LinkedIn (decision makers)
- Google Ads (search intent)

**B2C Apps:**
- TikTok (reach, free)
- Google App Store (organic)
- Reddit communities (word-of-mouth)
- Influencers (credibility)

**Developer Tools:**
- GitHub (developers hang out)
- Stack Overflow (problem solving)
- Dev Twitter (community)
- Indie Hackers (makers)

## Product-Led Growth (PLG)

### PLG Principles

1. **Free tier does real work** (not just a trial)
2. **Viral built-in** (invite, sharing, social proof)
3. **Self-serve** (no sales call needed)
4. **Usage-based pricing** (pay for value used)

### PLG Playbook

**Step 1: Great Free Product**
- Does one thing really well
- No crippling limitations
- Users hit upgrade when they need more

**Step 2: Upgrade Triggers**
```
User hits limit → "Upgrade to do X" → Clean path to paid
```

Examples:
- Canva: "Free tier = 1 team member, paid = unlimited"
- Figma: "Free tier = 3 files, paid = unlimited"
- Slack: "Free tier = 90 days history, paid = full history"

**Step 3: Free to Paid Journey**
```
Free user → Hit ceiling → Try premium (trial/limited features) → Convert or churn
```

**Step 4: Community Over Sales**
- Knowledge base instead of live chat
- Community forum for questions
- Power users as moderators
- Sales only for enterprise
