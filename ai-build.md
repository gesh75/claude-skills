---
name: ai-build
description: "Composite super-skill: end-to-end AI product and agent development combining architecture design, implementation patterns, safety guardrails, testing, and cost optimization. Use when building AI-powered products, agents, or automation workflows."
risk: safe
---

# AI Build

A comprehensive AI product development composite that pulls together architecture design (`ai-agents-architect`), safety guardrails (`security-review`), evaluation/testing, and cost optimization (`cost-aware-llm-pipeline`).

## When to Use

- Building a new AI-powered product or feature
- Designing a multi-agent system or workflow automation
- Wrapping an LLM API into a product
- Adding AI capabilities to an existing system

## Phase 1: Requirements & Architecture (see `ai-agents-architect`)

Before writing code, define:

1. **What problem does AI solve here?** — Is AI the right tool, or would deterministic logic be simpler?
2. **Input/Output contract** — What goes in, what comes out, what's the latency budget?
3. **Agent vs pipeline** — Single LLM call / chain / autonomous agent / multi-agent?
4. **Human-in-the-loop** — Where does a human need to approve or correct?
5. **Failure modes** — What happens when the model is wrong, slow, or unavailable?

**Architecture patterns — pick one:**
- **Single call**: One prompt → one response. Use for classification, extraction, summarization.
- **Chain**: Sequential steps where output of one feeds next. Use for multi-step transforms.
- **Router**: LLM decides which tool/agent to call. Use for intent-based routing.
- **Autonomous agent**: LLM loops with tools until task complete. Use for open-ended tasks.
- **Multi-agent**: Specialized agents collaborate. Use for complex, parallel workflows.

## Phase 2: Implementation (see `claude-api`)

**Model selection:**
- Default to `claude-sonnet-4-6` for most tasks (best capability/cost balance)
- Use `claude-haiku-4-5-20251001` for high-volume, simple tasks (10x cheaper)
- Use `claude-opus-4-8` only for complex reasoning where quality is critical

**Prompt engineering:**
- Be explicit about output format (JSON schema, markdown, plain text)
- Include few-shot examples for complex tasks
- Separate system instructions from user content
- Version your prompts like code

**Tool use pattern:**
```python
tools = [
    {
        "name": "tool_name",
        "description": "When to use this tool and what it does",
        "input_schema": { "type": "object", "properties": {...} }
    }
]
```

**Structured output:**
- Always use JSON mode or tool use for machine-readable outputs
- Never parse free-text responses with regex
- Validate outputs against a schema before using them

**Context management:**
- Keep system prompts focused and under 2000 tokens where possible
- Summarize conversation history for long sessions
- Use retrieval (RAG) instead of stuffing full documents into context

## Phase 3: Safety & Guardrails (see `security-review`)

Build these in from the start, not as an afterthought:

**Input validation:**
- Sanitize user inputs before including in prompts
- Set maximum input length limits
- Filter obviously malicious or off-topic requests before hitting the API

**Output validation:**
- Validate JSON schema before using structured outputs
- Check for hallucinated references (URLs, citations, file paths)
- Don't trust model output for security decisions — use it as a signal only

**Rate limiting & abuse prevention:**
- Implement per-user rate limits at the API level
- Monitor for prompt injection attempts in user inputs
- Log all model inputs/outputs for auditing

**Fallback strategy:**
- What does the product do when the AI call fails or times out?
- Define graceful degradation — return cached result, show error, or use rule-based fallback

## Phase 4: Testing (see `eval-harness`)

AI systems require a different testing approach than deterministic code:

**Unit tests — test the scaffolding, not the model:**
- Test prompt construction functions
- Test output parsers and validators
- Test tool execution logic
- Mock the LLM in unit tests

**Evaluation suite — test the model behaviour:**
- Build a golden dataset: 20–50 input/output pairs you've manually verified
- Run evals on every prompt change and model upgrade
- Track: accuracy, hallucination rate, latency, token usage
- Use LLM-as-judge for subjective quality (but validate the judge too)

**Regression testing:**
- Save examples of bugs found in production — add to eval suite
- Run evals in CI before deploying prompt changes

## Phase 5: Cost Optimization (see `cost-aware-llm-pipeline`)

**Token reduction:**
- Audit prompt length — remove unnecessary instructions and examples
- Use shorter system prompts for simple tasks
- Truncate context windows aggressively for high-volume routes

**Caching:**
- Cache identical or near-identical prompts (semantic caching)
- Cache tool call results (e.g., web searches, DB lookups)
- Use prompt caching for static system prompts (saves ~90% on repeated tokens)

**Model routing:**
- Route simple requests to Haiku, complex to Sonnet, critical to Opus
- Start with Sonnet, downgrade to Haiku for tasks where quality is equivalent

**Monitoring:**
- Track cost per request, cost per user, cost per feature
- Set budget alerts before costs spiral
- Identify the top 10% of expensive requests — they're usually fixable

## Output

Deliver:
1. Architecture diagram (text/ASCII is fine)
2. Implementation with all phases above addressed
3. Eval suite with ≥10 test cases
4. Cost estimate: tokens per request × expected volume × price per token
5. Monitoring checklist
