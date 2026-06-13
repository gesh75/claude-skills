---
name: ai-product-builder
description: Build AI-powered products with architecture patterns, evaluation frameworks, and safety practices.
category: AI & LLM
version: 1.0.0
---

# AI Product Builder

## Product Types
| Type | Pattern | Use when |
|---|---|---|
| Chatbot / Q&A | Single call or RAG | Knowledge retrieval, support |
| Copilot | Streaming + tool calls | Autocomplete, suggestions |
| Autonomous agent | Loop + tools | Open-ended tasks |
| Data pipeline | Batch processing | Classification, extraction at scale |
| Content generator | Structured output | Reports, summaries, drafts |

## Architecture Patterns
```
Direct call:    User → LLM → Response
RAG:            User → Retrieve(docs) → LLM(context) → Response
Tool-calling:   User → LLM → Tool → LLM → Response
Multi-agent:    User → Orchestrator → [Agent1, Agent2] → Merge → Response
```

## Model Selection
- Default: `claude-sonnet-4-6` (best balance)
- High-volume simple tasks: `claude-haiku-4-5-20251001` (10x cheaper)
- Complex reasoning only: `claude-opus-4-8`

## Evaluation Framework
Build a golden dataset (20–50 examples) and track:
- **Accuracy**: does it complete the task correctly?
- **Hallucination rate**: claims things that aren't true?
- **Latency**: p50 / p95 response time
- **Cost**: tokens per request × volume × price

Run evals in CI on every prompt change.

## Safety Checklist
- [ ] Input length limits + sanitization
- [ ] Output schema validation (never trust free-text for structured data)
- [ ] Rate limiting per user
- [ ] No security decisions based on model output alone
- [ ] Graceful fallback when model fails/times out
- [ ] All inputs + outputs logged for audit

## Cost Optimization
- Use prompt caching for static system prompts (~90% token savings)
- Semantic cache for repeated/similar queries
- Route simple requests to Haiku, complex to Sonnet
- Audit top 10% most expensive requests — usually fixable
