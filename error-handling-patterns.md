---
name: error-handling-patterns
description: Master error handling patterns across languages including exceptions, Result types, error propagation, and graceful degradation to build resilient applications. Use when implementing error handling, designing APIs, or improving application reliability.
---

# Error Handling Patterns

Build resilient applications with error handling that fails predictably, surfaces actionable diagnostics, and degrades gracefully instead of crashing.

## Use this skill when

- Implementing error handling in new features or APIs
- Designing retry, timeout, and fallback behavior for unreliable dependencies
- Adding circuit breakers around flaky downstream services
- Replacing scattered `try/except` with a structured error model
- Improving error messages for users and operators

## Core principle: errors are values, not surprises

Two complementary styles. Use both deliberately:

- **Exceptions** — for truly exceptional, non-recoverable conditions (programmer bugs, invariant violations). Let them propagate to a boundary that logs and converts to a response.
- **Result/Either types** — for expected failures that the caller must handle (validation, not-found, parse errors). Make failure part of the function signature so callers can't ignore it.

Never use exceptions for ordinary control flow, and never swallow an exception silently (`except: pass`).

## Result / Either pattern

Return a value that is *either* success or a typed failure. The caller is forced to branch.

```python
from dataclasses import dataclass
from typing import Generic, TypeVar, Union

T = TypeVar("T"); E = TypeVar("E")

@dataclass(frozen=True)
class Ok(Generic[T]):
    value: T

@dataclass(frozen=True)
class Err(Generic[E]):
    error: E

Result = Union[Ok[T], Err[E]]

def parse_port(raw: str) -> Result[int, str]:
    if not raw.isdigit():
        return Err(f"not a number: {raw!r}")
    port = int(raw)
    if not (1 <= port <= 65535):
        return Err(f"out of range: {port}")
    return Ok(port)

match parse_port(user_input):
    case Ok(port):   start_server(port)
    case Err(msg):   log.warning("bad port: %s", msg)
```

```typescript
type Result<T, E = Error> =
  | { ok: true; value: T }
  | { ok: false; error: E };

function parsePort(raw: string): Result<number, string> {
  const n = Number(raw);
  if (!Number.isInteger(n)) return { ok: false, error: `not an int: ${raw}` };
  if (n < 1 || n > 65535)   return { ok: false, error: `out of range: ${n}` };
  return { ok: true, value: n };
}
```

Languages with native support: Rust (`Result<T, E>` / `?`), Go (`value, err` tuples), Swift (`Result`), Kotlin (`Result` / sealed classes). Prefer the idiom of the language over hand-rolled types.

## Error taxonomy

Classify every failure so callers know how to react. A minimal, useful set:

| Class | Recoverable? | Caller action |
|-------|-------------|---------------|
| `ValidationError` | no (client must fix) | return 400, show field errors |
| `NotFoundError` | no | return 404 |
| `ConflictError` | maybe | return 409, prompt retry/merge |
| `TransientError` | yes | retry with backoff |
| `DependencyError` | maybe | circuit-break, fall back |
| `FatalError` | no | log, alert, crash/restart |

Make these distinct types (subclasses or an enum), not string matching on messages. Attach context (request id, resource id) but never secrets.

## Retry with exponential backoff + jitter

Retry only **transient** errors (timeouts, 429, 503). Never retry validation or auth failures. Always cap attempts and add jitter to avoid thundering herds.

```python
import random, time

def with_retry(fn, *, attempts=4, base=0.2, cap=5.0, retry_on=(TransientError,)):
    for i in range(attempts):
        try:
            return fn()
        except retry_on as e:
            if i == attempts - 1:
                raise
            delay = min(cap, base * (2 ** i)) * (0.5 + random.random())  # full jitter
            log.warning("retry %d/%d after %.2fs: %s", i + 1, attempts, delay, e)
            time.sleep(delay)
```

Pair every retry with an overall **timeout** so the total wait is bounded.

## Circuit breaker

Stop hammering a failing dependency. After N consecutive failures, "open" the circuit and fail fast for a cooldown window, then allow one trial ("half-open") before fully closing.

```python
import time

class CircuitBreaker:
    def __init__(self, fail_max=5, reset_after=30.0):
        self.fail_max, self.reset_after = fail_max, reset_after
        self.failures, self.opened_at, self.state = 0, 0.0, "closed"

    def call(self, fn):
        if self.state == "open":
            if time.monotonic() - self.opened_at < self.reset_after:
                raise DependencyError("circuit open — failing fast")
            self.state = "half-open"           # allow one trial
        try:
            result = fn()
        except Exception:
            self.failures += 1
            if self.failures >= self.fail_max or self.state == "half-open":
                self.state, self.opened_at = "open", time.monotonic()
            raise
        self.failures, self.state = 0, "closed"  # success resets
        return result
```

Order of defenses around a remote call: **timeout → retry (transient only) → circuit breaker → fallback**.

## Graceful degradation & fallbacks

When a non-critical dependency fails, degrade instead of erroring the whole request:

- Serve a **cached** or **stale** value with a freshness flag.
- Return a **partial** response and mark the missing section.
- Use a **rule-based default** when an AI/ML call fails.
- Surface a clear, user-friendly message; log full detail server-side.

## Handle errors at the right boundary

- **Catch low, handle high.** Let errors propagate to a single boundary (HTTP middleware, message handler, CLI `main`) that logs with full context and maps the error class to a response/exit code.
- **Add context as it bubbles** (wrap with operation name + ids) — Go `fmt.Errorf("...: %w", err)`, Python `raise X from e`, Rust `.context(...)`.
- **Don't log-and-rethrow** at every layer; that produces duplicate noise. Log once, at the boundary.

## Anti-patterns

- Swallowing exceptions (`except: pass`, empty `catch {}`).
- Catching broad `Exception`/`Throwable` except at the top boundary.
- Returning `null`/`-1`/`""` as an error signal instead of a typed result.
- Retrying non-idempotent operations without idempotency keys.
- Leaking stack traces, secrets, or internal IDs in user-facing messages.
- Using exceptions for expected, frequent outcomes (hot-path control flow).

## Related skills

- `debug-full` / `error-detective` — diagnose failures once they occur.
- `api-design` / `api-complete` — consistent API error envelopes and status codes.
- `security-review` — ensure error output doesn't leak sensitive data.
