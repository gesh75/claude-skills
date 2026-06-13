---
name: ai-shaped-readiness-advisor
description: Assess whether your product work is AI-first or AI-shaped. Score 5 competencies and recommend the next capability to build.
type: interactive
---

# AI-Shaped Readiness Advisor

**AI-first** = automating existing tasks faster (Copilot writes PRDs 2x faster).
**AI-shaped** = redesigning how work gets done (AI agent validates hypotheses in 48h vs 3 weeks).

## The 5 PM Competencies (2026)

| Competency | AI-First (score 1–2) | AI-Shaped (score 4–5) |
|---|---|---|
| **Context Design** | Pastes full PRD into chat | Maintains a versioned reality layer (constraints, glossary, evidence standards) |
| **Hypothesis Compression** | Writes specs faster | Runs 10 experiments/week via automated pipelines |
| **AI Workflow Orchestration** | Uses single-agent chat | Chains specialized agents with human checkpoints |
| **Synthetic Research** | Asks AI to summarize | Builds always-on feedback loops with real users |
| **Judgment Under Uncertainty** | Avoids ambiguous AI decisions | Defines clear human-in-the-loop trigger criteria |

## Assessment Workflow

1. **Score each competency 1–5** — ask user to describe their current practice
2. **Calculate total** (max 25) and identify the lowest-scoring competency
3. **Recommend the one next capability** to build — lowest score = highest leverage
4. **Define a 2-week experiment** to move that competency one level up

## Key Diagnostics

**Context Stuffing vs Context Engineering:**
- Stuffing: "paste the whole doc, let Claude figure it out"
- Engineering: curated context with explicit constraints, definitions, and evidence standards

**The 5 Context Hoarding Disorder questions:**
1. Do you paste the same background in every session?
2. Does context window size limit your work?
3. Do agents lose track mid-task?
4. Do outputs vary wildly on similar prompts?
5. Do you re-explain the same constraints repeatedly?

→ 3+ yes = context engineering is your priority

## Output Format
```
Competency Scores: [C1:X, C2:X, C3:X, C4:X, C5:X] Total: XX/25
Weakest: [competency name]
Next move: [one specific 2-week experiment]
Expected outcome: [measurable result]
```
