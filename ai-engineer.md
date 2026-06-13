---
name: ai-engineer
description: Build production LLM apps, RAG systems, and agents — retrieval
  patterns, agent loop design, evals, and safety controls. Use for RAG,
  chatbots, AI agents, or LLM-powered features.
metadata:
  model: inherit
---

# AI Engineer

Actionable patterns for shipping production LLM features: retrieval, agent
loops, evaluation, and safety. Provider-neutral. For Anthropic-specific API
mechanics (model IDs, pricing, caching, tool-use schema) read the `claude-api`
skill — do not hardcode model names here. For the broader operating model of
eval-first agentic development, see `agentic-engineering` (this skill is the
application-architecture layer; that one is the workflow layer).

## When to Activate

- Building or improving a RAG / retrieval pipeline
- Designing an agent loop (tool use, memory, multi-step task execution)
- Adding evals, monitoring, or safety guardrails to an LLM feature
- Choosing between retrieval, fine-tuning, long-context, and agentic approaches

## First Decision: Do You Even Need RAG / Agents?

Pick the cheapest mechanism that meets the requirement:

| Need | Use |
|------|-----|
| Answer from a few small, stable docs | Put them in the prompt (long context); no retrieval infra |
| Answer over a large/changing corpus | RAG (retrieve → ground → generate) |
| Multi-step task with tools and branching | Agent loop |
| Consistent format/style on a narrow task at scale | Few-shot prompting; fine-tune only if prompting plateaus |
| Deterministic logic | Plain code — not an LLM |

Default to prompt + retrieval before reaching for agents. Agents add latency,
cost, and failure modes; justify them with a task that genuinely needs
iteration and tool use.

## RAG Patterns

Pipeline: **chunk → embed → index → retrieve → (rerank) → ground → generate.**

- **Chunking:** chunk on document structure (headings, sections) over fixed-size
  windows. Keep chunks self-contained; add a small overlap or a parent-doc
  pointer so a retrieved chunk carries enough context to stand alone.
- **Hybrid retrieval:** combine dense (embeddings) with keyword/BM25. Dense
  alone misses exact terms (IDs, names, codes); keyword alone misses paraphrase.
- **Rerank** the top-K (e.g. 50 → 8) with a cross-encoder reranker when recall
  is high but precision is low. Skip it when retrieval is already precise — it
  adds latency and cost.
- **Ground explicitly:** instruct the model to answer only from retrieved
  context and to say "not found" when the context doesn't cover the question.
  This is the single biggest lever against hallucination in RAG.
- **Cite sources:** return the chunk IDs/URLs used so answers are verifiable.
- **Vector store choice:** start with `pgvector` if you already run Postgres
  (one fewer system to operate). Move to a dedicated vector DB only when scale or
  latency forces it.

Debug retrieval failures by inspecting *what was retrieved* before blaming the
model — most "wrong answers" are retrieval misses, not generation errors.

## Agent Loop Design

Core loop: **model → tool call → observe result → model → … → final answer.**

- **Tools are the interface.** Give clear names, typed parameters, and a
  one-line description of when to use each. Return concise, structured tool
  results — verbose results waste context and confuse the model. (See
  `agent-harness-construction` for action-space design.)
- **Bound the loop:** cap max iterations and total tokens; on hitting the cap,
  return partial progress, not silence.
- **Memory:** keep short-term state in the conversation; persist long-term facts
  externally (DB/vector store) and retrieve them — don't grow the context
  unboundedly.
- **Validate tool outputs** before feeding them back; a failed tool call should
  return a structured error the model can recover from, not crash the loop.
- **Prefer one capable agent with good tools** over many hand-off agents until a
  single agent demonstrably can't cope — multi-agent adds coordination cost.

## Evaluation (non-negotiable)

You cannot improve what you don't measure. Build an eval set before scaling.

- Assemble 20–50+ representative cases with expected outputs or rubrics.
- For RAG, measure retrieval (was the right chunk retrieved?) separately from
  generation (was the answer correct given the chunk?) — they fail differently.
- Use an LLM-as-judge for open-ended outputs, but anchor it with a rubric and
  spot-check the judge against human labels.
- Run evals in CI on every prompt/model/pipeline change to catch regressions.
- Track cost and latency per case alongside quality — a "better" answer that
  costs 5x may not ship.

## Safety & Cost Controls

- **Prompt injection:** treat all retrieved/tool content as untrusted; never let
  it silently override system instructions. Separate instructions from data.
- **PII:** detect/redact sensitive data before sending to external models; get
  approval before sending regulated data off-platform.
- **Output validation:** validate structured outputs against a schema; have a
  fallback path when the model returns malformed output.
- **Cost:** route easy tasks to a cheaper/smaller model and reserve the strongest
  model for hard steps; cache stable prefixes (system prompt, retrieved context).
  See `cost-aware-llm-pipeline` for routing and budget patterns.
- **Resilience:** add timeouts, retries with backoff, and a circuit breaker
  around model and tool calls.

## Cross-References

- Anthropic API mechanics, current model IDs, pricing, caching → `claude-api`
- Eval-first agentic workflow and decomposition → `agentic-engineering`
- Tool/action-space design for agents → `agent-harness-construction`
- Model routing and budget control → `cost-aware-llm-pipeline`
