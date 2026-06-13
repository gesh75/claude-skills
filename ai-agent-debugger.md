---
name: ai-agent-debugger
description: Debug agent loops — detect infinite loops, hallucination cascades, cost runaway, and context degradation.
category: AI & Claude Code Mastery
version: 1.0.0
---

# AI Agent Debugger

## Failure Mode Reference

| Failure | Symptoms | Fix |
|---|---|---|
| Infinite loop | Same tool called repeatedly, no progress | Add loop detector; check termination condition |
| Hallucination cascade | Agent invents results, builds on wrong info | Add verification step after each tool call |
| Cost runaway | Token usage exploding | Budget cap + early termination; reduce context |
| Context degradation | Quality drops mid-task | Summarize + compress history; reset if >80% full |
| Tool abuse | Model uses wrong tool or misuses it | Sharpen tool descriptions; add usage examples |

## Instrumentation
```python
# Action logging
def log_action(action, result, iteration):
    print(f"[{iteration}] {action.type}: {action.input[:100]}")
    print(f"  → {str(result)[:200]}")

# Loop detection
recent_actions = deque(maxlen=5)
if action in recent_actions:
    raise InfiniteLoopDetected(f"Repeated: {action}")
recent_actions.append(action)

# Cost tracking
total_tokens += response.usage.input_tokens + response.usage.output_tokens
if total_tokens > BUDGET: raise BudgetExceeded()
```

## Debugging Checklist
```
Symptom: Agent not completing task
□ Check iteration count — hitting max_iterations?
□ Check last 5 actions — loop pattern?
□ Check tool call inputs — hallucinated args?
□ Check context size — degradation?

Symptom: Wrong output
□ Check which tool was called at step N
□ Check the exact input passed
□ Check if result was verified before next step

Symptom: High cost
□ Which step uses the most tokens?
□ Is context growing unbounded?
□ Are tool results being truncated before insertion?
```

## Quick Fixes
- Infinite loop → add `if action in history[-3:]: force_complete()`
- Hallucination → add `assert_valid(result)` after each tool call
- Cost runaway → truncate tool outputs to 500 chars before adding to context
- Degradation → summarize every 10 turns: `context = summarize(context)`
