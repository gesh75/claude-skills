---
name: context-engineering-advisor
description: Diagnose and fix context management issues in AI workflows. Identifies stuffing, poisoning, and degradation. Recommends memory architecture improvements.
type: interactive
---

# Context Engineering Advisor

**Stuffing** = pasting volume without intent. **Engineering** = curating what the model needs, when.

## 5-Question Diagnosis
1. Do you paste the same background every session?
2. Does context window size limit your work?
3. Do agents lose track mid-task?
4. Do outputs vary wildly on similar prompts?
5. Do you re-explain the same constraints repeatedly?

→ **3+ yes** = context engineering is your highest-leverage fix

## Failure Patterns

| Pattern | Symptom | Fix |
|---|---|---|
| Context stuffing | Long prompt, mediocre output | Keep constraints + glossary + evidence only |
| Lost-in-middle | Model ignores middle content | Move critical info to start or end |
| Context poisoning | Early wrong assumption ruins later steps | Explicit correction + reset |
| Context distraction | Too many irrelevant details | Strip to minimum viable context |
| Degradation | Quality drops over long conversation | Summarize + reset |

## Two-Layer Memory
```
Short-term (in-context):  Current task, recent decisions, working state
Long-term (persistent):   Constraints, glossary, evidence standards, past decisions
```

## Research → Plan → Reset → Implement
1. **Research**: gather context, read files
2. **Plan**: synthesize into explicit plan
3. **Reset**: new context with plan + only essential background
4. **Implement**: execute with lean context

## Checklist
- [ ] Constraints documented (technical, regulatory, strategic)
- [ ] Shared glossary defined
- [ ] Evidence standards set (what counts as validated)
- [ ] System prompt <2000 tokens for high-volume routes
- [ ] Use retrieval (RAG) instead of stuffing large knowledge bases
