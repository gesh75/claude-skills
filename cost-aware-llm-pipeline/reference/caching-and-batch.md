# Caching, Batch & Token Budgeting (Reference)

Extended cost-control techniques that complement the core pipeline in `../SKILL.md`.
All examples are provider-neutral or Claude-first. Latest model IDs: Opus 4.8 / Sonnet 4.6 / Haiku 4.5.

## Token Counting & Cost Estimation

Estimate cost *before* a call so you can enforce budgets and pick a model. Use the
provider's own token counter for accuracy (Anthropic exposes `client.messages.count_tokens`;
do not assume a fixed chars-per-token ratio across providers).

```python
import anthropic

client = anthropic.Anthropic()

def count_tokens(text: str, model: str = "claude-haiku-4-5") -> int:
    """Exact input-token count via the Anthropic API (no local tokenizer drift)."""
    resp = client.messages.count_tokens(
        model=model,
        messages=[{"role": "user", "content": text}],
    )
    return resp.input_tokens

# Pricing in $/1M tokens — keep in sync with SKILL.md pricing table.
_PRICING = {
    "claude-haiku-4-5":  {"input": 0.80,  "output": 4.00},
    "claude-sonnet-4-6": {"input": 3.00,  "output": 15.00},
    "claude-opus-4-8":   {"input": 15.00, "output": 75.00},
}

def estimate_cost(input_tokens: int, output_tokens: int, model: str) -> float:
    """Estimate USD cost for a single request."""
    rates = _PRICING.get(model, _PRICING["claude-sonnet-4-6"])
    return (input_tokens / 1_000_000) * rates["input"] + \
           (output_tokens / 1_000_000) * rates["output"]
```

## Time-Windowed Token Budget

The core `CostTracker` (in `SKILL.md`) tracks cumulative dollars for a single run.
For long-lived services, add a `TokenBudget` with daily/monthly limits and automatic
reset so a runaway loop can't burn the whole month's allowance in one day.

```python
from dataclasses import dataclass, replace
from datetime import datetime

@dataclass(frozen=True, slots=True)
class TokenBudget:
    daily_limit: int
    monthly_limit: int
    daily_used: int = 0
    monthly_used: int = 0
    last_reset_date: str = ""  # ISO date string

    def _rolled(self) -> "TokenBudget":
        """Return a budget with daily counter reset if the day changed (immutable)."""
        today = datetime.now().date().isoformat()
        if today != self.last_reset_date:
            return replace(self, daily_used=0, last_reset_date=today)
        return self

    def can_afford(self, tokens: int) -> bool:
        b = self._rolled()
        return (b.daily_used + tokens <= b.daily_limit and
                b.monthly_used + tokens <= b.monthly_limit)

    def charge(self, tokens: int) -> "TokenBudget":
        """Return a new budget with usage added (never mutates self)."""
        b = self._rolled()
        return replace(b, daily_used=b.daily_used + tokens,
                       monthly_used=b.monthly_used + tokens)
```

Note: this is rewritten as a frozen/immutable dataclass to match the SKILL's
"no in-place mutation" convention (the original source used a mutable class).

## System Prompt Slimming

Trimming boilerplate from system prompts cuts input tokens on every single call —
the highest-leverage one-time optimization for high-volume endpoints.

```python
def slim_system_prompt(system_prompt: str) -> tuple[str, float]:
    """Strip filler phrases and collapse whitespace. Returns (new_prompt, savings_pct)."""
    original = count_tokens(system_prompt)
    filler = [
        "Please", "Thank you", "I appreciate", "As an AI",
        "It is important to note that", "You should always",
    ]
    optimized = system_prompt
    for phrase in filler:
        optimized = optimized.replace(phrase, "")
    optimized = " ".join(optimized.split())  # collapse whitespace
    new = count_tokens(optimized)
    savings = (original - new) / original * 100 if original else 0.0
    return optimized, savings
```

Verbose vs concise system prompt (illustrative):

```
VERBOSE  (~850 tokens): "You are an AI assistant designed to help users with various
tasks. Your primary goal is to provide accurate, helpful, and informative responses..."

CONCISE  (~120 tokens): "You are a helpful AI assistant. Be accurate, relevant, and concise."
```

## Production Response Cache (Redis)

Anthropic's `cache_control` (covered in `SKILL.md`) caches the *prompt prefix* server-side.
A separate **response cache** keyed on the full prompt avoids the API call entirely for
identical, deterministic requests — ideal for FAQ-style or idempotent workloads.

```python
import redis, json, hashlib

class RedisResponseCache:
    def __init__(self, redis_url: str = "redis://localhost:6379"):
        self.client = redis.from_url(redis_url)

    @staticmethod
    def _key(prompt: str, model: str) -> str:
        # Include model so a model swap doesn't serve stale completions.
        return "llm:" + hashlib.sha256(f"{model}\n{prompt}".encode()).hexdigest()

    def get(self, prompt: str, model: str) -> dict | None:
        cached = self.client.get(self._key(prompt, model))
        return json.loads(cached) if cached else None

    def set(self, prompt: str, model: str, response: dict, ttl_hours: int = 24) -> None:
        self.client.setex(self._key(prompt, model), int(ttl_hours * 3600),
                          json.dumps(response))

# Usage: check cache before calling, store after.
cache = RedisResponseCache()

def cached_query(prompt: str, model: str = "claude-haiku-4-5") -> str:
    hit = cache.get(prompt, model)
    if hit:
        return hit["content"]
    resp = client.messages.create(
        model=model,
        max_tokens=1024,
        messages=[{"role": "user", "content": prompt}],
    )
    text = resp.content[0].text
    cache.set(prompt, model, {"content": text})
    return text
```

Only cache deterministic requests (low/zero temperature). Caching creative or
time-sensitive responses serves stale or repetitive output.

## Batch Processing (50% cheaper, async)

For non-urgent, high-volume work, submit a batch instead of one call per item.
Anthropic's Message Batches API runs asynchronously (results within ~24h) at ~50% of
standard pricing.

```python
def submit_batch(prompts: list[str], model: str = "claude-haiku-4-5") -> str:
    """Submit many prompts as one async batch. Returns the batch id."""
    requests = [
        {
            "custom_id": f"req-{i}",
            "params": {
                "model": model,
                "max_tokens": 1024,
                "messages": [{"role": "user", "content": p}],
            },
        }
        for i, p in enumerate(prompts)
    ]
    batch = client.messages.batches.create(requests=requests)
    return batch.id

def get_batch_results(batch_id: str) -> list:
    """Fetch results once the batch has finished processing."""
    batch = client.messages.batches.retrieve(batch_id)
    if batch.processing_status != "ended":
        return []
    return list(client.messages.batches.results(batch_id))
```

If you must stay on a JSONL-file workflow (e.g. OpenAI's Batch API), the shape is the
same: one JSON object per line with a `custom_id`, write to a `.jsonl`, upload, then poll.

## Extended Checklist

Beyond the core SKILL.md best practices:

- [ ] Count tokens before calls and enforce a daily/monthly `TokenBudget`
- [ ] Slim system prompts of filler before high-volume rollout
- [ ] Add a Redis response cache for deterministic/idempotent requests
- [ ] Route non-urgent bulk work through the Batch API (~50% savings)
- [ ] Deduplicate identical in-flight requests
- [ ] Emit per-feature cost metrics and set spend alerts
