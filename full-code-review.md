---
name: full-code-review
description: "Composite super-skill: comprehensive code review combining security vulnerability scanning, bug detection, code quality analysis, and architecture review. Use when you want the deepest possible review of code changes or a codebase."
risk: safe
---

# Full Code Review

A three-phase composite review that combines `find-bugs`, `code-reviewer`, and `code-review-excellence` into one exhaustive pass.

## When to Use

- Before merging a significant PR
- After a major feature implementation
- When onboarding to a new codebase
- Security-sensitive changes (auth, payments, data handling)

> **This skill vs the `/code-review` command vs the `security-review` skill:**
> Reach for `/code-review` for the everyday case — a focused pass over the current
> diff or a single PR. Use the `security-review` skill when the change is primarily
> security-sensitive and you want the dedicated security checklist and patterns.
> Use **this composite skill** only when you want the deepest possible pass: bug
> hunting *plus* quality *plus* security *plus* an excellence review in one run,
> e.g. a major feature merge or codebase onboarding where the extra depth is worth
> the cost.

## Phase 1: Security & Bug Scan (from `find-bugs`)

1. Get the full diff: `git diff $(gh repo view --json defaultBranchRef --jq '.defaultBranchRef.name')...HEAD`
2. If no git context, read all relevant files
3. Map every attack surface: inputs, queries, auth checks, external calls, crypto ops

**Security checklist — verify every item:**
- [ ] Injection: SQL, command, template, header
- [ ] XSS: all outputs in templates properly escaped
- [ ] Authentication: auth checks on all protected operations
- [ ] Authorization/IDOR: access control verified, not just auth
- [ ] CSRF: state-changing operations protected
- [ ] Race conditions: TOCTOU in read-then-write patterns
- [ ] Session: fixation, expiration, secure flags
- [ ] Cryptography: secure random, proper algorithms, no secrets in logs
- [ ] Information disclosure: error messages, timing attacks
- [ ] DoS: unbounded operations, missing rate limits, resource exhaustion
- [ ] Business logic: edge cases, state machine violations, numeric overflow

## Phase 2: Code Quality Review (from `code-reviewer`)

Analyze with current best practices:

**Correctness**
- Logic errors, off-by-one, null/undefined handling
- Edge cases: empty input, max values, concurrent access
- Error handling: are errors propagated or silently swallowed

**Performance**
- N+1 queries, missing indexes, unnecessary loops
- Memory leaks, unbounded allocations
- Blocking operations in async contexts

**Maintainability**
- Functions doing more than one thing
- Magic numbers/strings without constants
- Dead code, unreachable branches
- Test coverage for new logic

**Architecture**
- Does this fit the existing patterns in the codebase?
- Tight coupling where there should be abstraction
- Violation of separation of concerns

## Phase 3: Excellence Check (from `code-review-excellence`)

Go beyond correctness — evaluate:

- **Readability**: Would a new team member understand this in 5 minutes?
- **Naming**: Variables, functions, and files named for intent, not implementation
- **Documentation**: Are non-obvious decisions explained with comments?
- **Tests**: Are tests testing behaviour, not implementation?
- **Reversibility**: Can this be rolled back safely?
- **Observability**: Is there enough logging/metrics to debug production issues?

## Output Format

Group findings by severity:

### 🔴 Critical (must fix before merge)
- **File:Line** — Description
- **Problem**: What's wrong
- **Fix**: Concrete suggestion

### 🟡 High (fix soon)
### 🟠 Medium (address in follow-up)
### 🟢 Low / Suggestions (optional improvements)

### ✅ What's Done Well
Always include positives — reinforce good patterns.

### Summary
- Files reviewed: N
- Issues found: N critical, N high, N medium, N low
- Recommendation: Approve / Request changes / Block
