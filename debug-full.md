---
name: debug-full
description: "Composite super-skill: exhaustive debugging workflow combining error analysis, root cause investigation, production debugging strategies, and fix verification. Use when standard debugging hasn't worked or the bug is complex/intermittent."
risk: safe
---

# Full Debug

A structured five-phase debugging composite combining `debugger`, `error-detective`, `error-debugging-error-analysis`, and `debugging-strategies`.

## When to Use

- Error has been investigated but root cause is unknown
- Intermittent / hard-to-reproduce bugs
- Production incidents needing fast diagnosis
- Complex multi-system failures

## Phase 1: Error Intake & Classification (from `error-debugging-error-analysis`)

Analyze: `$ARGUMENTS`

1. **Capture the full error** — stack trace, error message, error code, timestamp
2. **Classify the error type:**
   - Runtime exception (null ref, out of bounds, type mismatch)
   - Logic error (wrong output, wrong state)
   - Network/IO error (timeout, connection refused, DNS)
   - Resource error (OOM, disk full, file not found)
   - Concurrency error (race condition, deadlock)
   - Configuration error (missing env var, wrong credentials)
3. **Identify the failure boundary** — where does the system think it failed vs where did it actually fail?

## Phase 2: Evidence Collection (from `error-detective`)

Gather before forming hypotheses:

- **Logs**: Collect logs from all relevant services around the failure time window (±5 minutes)
- **Recent changes**: `git log --oneline -20` — what changed recently?
- **Environment delta**: Did anything change? Deployment, config, dependencies, infra?
- **Reproduction**: Can you reproduce it? Locally? In staging? Under what conditions?
- **Frequency**: Always / intermittent / only under load / only for certain users?
- **Blast radius**: What else is affected? Only this component or others too?

## Phase 3: Hypothesis Generation & Testing (from `debugger`)

Generate 3–5 hypotheses ranked by likelihood:

For each hypothesis:
1. State the hypothesis clearly: "The bug occurs because X"
2. Define the test: "To confirm, I will check Y"
3. Run the test
4. Confirm or eliminate

**Debugging workflow:**
```
Observe symptom
→ Form hypothesis
→ Add targeted logging / inspect state
→ Isolate the minimal reproduction case
→ Confirm root cause
→ Fix
→ Verify fix doesn't break anything else
```

Common root causes to investigate first:
- State mutation where immutability expected
- Off-by-one in loops or pagination
- Timezone / locale mismatch
- Cache stale data being served
- Race condition in async code
- Missing await / promise not caught
- Wrong environment variable loaded
- Dependency version incompatibility

## Phase 4: Production-Specific Strategies (from `debugging-production-guide`)

If the bug is in production:

1. **Mitigate first** — can you roll back, feature-flag off, or redirect traffic?
2. **Don't fix in production** — reproduce locally or in staging first
3. **Preserve evidence** — capture heap dumps, thread dumps, or core files before restart
4. **Correlate with metrics** — CPU spike? Memory climb? Error rate jump? Latency increase?
5. **Check dependencies** — external APIs, databases, queues — are they healthy?
6. **Narrow the blast radius** — is it all users or a subset? All regions or one?

## Phase 5: Fix & Verification

After identifying root cause:

1. **Write a failing test first** that reproduces the bug
2. **Implement the fix**
3. **Verify the test now passes**
4. **Check for similar patterns** elsewhere in the codebase: `grep -r "same_pattern" src/`
5. **Regression check** — run the full test suite
6. **Document** — add a comment explaining why the fix works and what caused the bug

## Output Format

```
## Root Cause
[One sentence: "The bug is caused by X in file Y at line Z"]

## Evidence
- [Key piece of evidence 1]
- [Key piece of evidence 2]

## Fix Applied
[Description of fix with file:line references]

## Verification
- [ ] Failing test written
- [ ] Test now passes
- [ ] Similar patterns checked
- [ ] Regression suite passing

## Prevention
[What could prevent this class of bug in future?]
```
