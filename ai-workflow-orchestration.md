---
name: ai-workflow-orchestration
description: "Orchestrate multi-step AI/agent workflows with LangGraph, CrewAI, or AutoGen. Use when choosing a state-machine vs role-crew vs conversational-group orchestration style, adding human-in-the-loop approval gates, or making multi-agent runs robust with retries."
category: AI & LLM
version: 1.0.0
---

# AI Workflow Orchestration: State Machines & Automation

Patterns for orchestrating multi-step AI workflows: choosing an orchestration style,
adding human approval gates, and making runs robust with retries and async fan-out.

> **Provider note:** LangGraph, CrewAI, and AutoGen are all provider-agnostic. The heavy
> reference examples show OpenAI-style config because that is their default in the docs,
> but each can drive **Claude via the Anthropic API** — see the per-framework reference
> files for the one-line swap, and the **`claude-api`** skill for current model ids,
> pricing, and SDK usage.

## Orchestration Patterns — When to Use Which

| Style | Framework | Best for | Avoid when |
|-------|-----------|----------|------------|
| **State-machine / graph** | LangGraph, hand-rolled FSM | Deterministic flows with explicit branches and loops (plan → execute → review → revise); auditable, resumable runs | The control flow is genuinely open-ended dialogue |
| **Role-based crew** | CrewAI | A pipeline of specialized agents with clear task dependencies (researcher → writer → editor) | You need fine-grained control over each transition |
| **Conversational group** | AutoGen | Open-ended collaborative problem solving where agents negotiate turns (coder ↔ analyst ↔ user) | The flow is fixed and you want determinism |

Rules of thumb:

- **Start with a plain state machine** (below). Reach for a framework only when its
  abstractions earn their dependency weight.
- **Prefer the graph/FSM style** when you need replayability, audit logs, or the ability
  to resume from a checkpoint — it makes state explicit.
- **Use a role-based crew** when the work decomposes cleanly into specialist hand-offs.
- **Use a conversational group** only when the number/order of turns can't be known up
  front and agents genuinely need to react to each other.

### When to add human-in-the-loop

Insert an approval gate before any **irreversible or high-blast-radius** action:
deletes, fund transfers, production deploys, external sends, spend above a threshold.
Keep autonomous steps autonomous — gating everything destroys throughput. See the
Human-in-the-Loop pattern below for a synchronous gate and an async approval queue.

## Concise Inline Example — Plan/Execute/Review FSM

A minimal, dependency-free orchestration loop that captures the core idea behind the
graph frameworks: a shared state, named steps, and a conditional loop-back.

```python
def orchestrate(goal: str, llm, max_revisions: int = 2) -> dict:
    """Plan -> execute -> review, looping back on 'revise' up to a cap."""
    state = {"goal": goal, "revisions": 0}

    while True:
        state["plan"] = llm.predict(f"Create a plan for: {state['goal']}")
        state["result"] = execute_plan(state["plan"])
        state["review"] = llm.predict(f"Review result: {state['result']}")

        if "revise" not in state["review"].lower():
            return state                       # accepted
        if state["revisions"] >= max_revisions:
            return {**state, "status": "max_revisions_reached"}
        state["revisions"] += 1                # loop back into planning
```

For the full framework implementations of this same plan/execute/review loop, see the
**Reference Files** below.

## State Machines

```python
from enum import Enum
from typing import Dict, Callable

class State(Enum):
    INIT = 1
    PROCESSING = 2
    COMPLETED = 3
    ERROR = 4

class StateMachine:
    def __init__(self):
        self.state = State.INIT
        self.handlers: Dict[State, Callable] = {}
        self.transitions: Dict[State, Dict[str, State]] = {}

    def register_handler(self, state: State, handler: Callable):
        """Register handler for state."""
        self.handlers[state] = handler

    def register_transition(self, from_state: State, event: str, to_state: State):
        """Register state transition."""
        if from_state not in self.transitions:
            self.transitions[from_state] = {}
        self.transitions[from_state][event] = to_state

    def transition(self, event: str) -> bool:
        """Attempt state transition."""
        if self.state not in self.transitions:
            return False

        if event not in self.transitions[self.state]:
            return False

        self.state = self.transitions[self.state][event]
        return True

    def handle(self, data):
        """Handle current state."""
        if self.state in self.handlers:
            return self.handlers[self.state](data)

# Configure workflow
sm = StateMachine()

sm.register_handler(State.INIT, lambda data: print("Starting..."))
sm.register_handler(State.PROCESSING, lambda data: print(f"Processing {data}"))
sm.register_handler(State.COMPLETED, lambda data: print("Done!"))

sm.register_transition(State.INIT, "start", State.PROCESSING)
sm.register_transition(State.PROCESSING, "finish", State.COMPLETED)
sm.register_transition(State.PROCESSING, "error", State.ERROR)

sm.handle(None)
sm.transition("start")
sm.handle("task data")
sm.transition("finish")
```

## Human-in-the-Loop

```python
class HumanInLoopWorkflow:
    def __init__(self, llm):
        self.llm = llm
        self.approval_required_steps = ["delete", "transfer_funds"]

    def execute_step(self, step_name: str, step_input: str) -> str:
        """Execute with human approval if needed."""
        # Generate action
        action = self.llm.predict(f"Execute: {step_input}")

        # Check if approval required
        if any(keyword in step_name.lower() for keyword in self.approval_required_steps):
            print(f"Proposed action: {action}")
            approval = input("Approve? (yes/no): ")

            if approval.lower() != "yes":
                return "Action cancelled by user"

        # Execute
        return execute_action(action)

class ApprovalQueue:
    def __init__(self):
        self.pending = []

    def submit_for_approval(self, action: str, priority: str = "normal"):
        """Submit action for approval."""
        self.pending.append({
            "action": action,
            "priority": priority,
            "status": "pending"
        })

    def approve(self, action_id: int):
        """Approve action."""
        self.pending[action_id]["status"] = "approved"
        return execute_action(self.pending[action_id]["action"])

    def get_pending(self) -> list:
        """Get pending approvals."""
        return [a for a in self.pending if a["status"] == "pending"]

workflow = HumanInLoopWorkflow(llm)
workflow.execute_step("transfer_funds", "Move 1000 to account X")

queue = ApprovalQueue()
queue.submit_for_approval("Delete database", priority="high")
pending = queue.get_pending()
```

## Error Handling & Retries

```python
class RobustWorkflow:
    def __init__(self, max_retries: int = 3):
        self.max_retries = max_retries
        self.execution_log = []

    def execute_with_fallback(self, primary: Callable, fallback: Callable, input_data):
        """Execute primary, fallback on failure."""
        try:
            result = primary(input_data)
            self.log_execution("primary", True, input_data)
            return result
        except Exception as e:
            print(f"Primary failed: {e}")
            try:
                result = fallback(input_data)
                self.log_execution("fallback", True, input_data)
                return result
            except Exception as e2:
                self.log_execution("fallback", False, input_data)
                raise

    def execute_with_retry(self, func: Callable, input_data, backoff_factor: int = 2):
        """Retry with exponential backoff."""
        import time

        last_error = None
        for attempt in range(self.max_retries):
            try:
                result = func(input_data)
                self.log_execution(f"attempt_{attempt}", True, input_data)
                return result
            except Exception as e:
                last_error = e
                if attempt < self.max_retries - 1:
                    wait_time = backoff_factor ** attempt
                    print(f"Retry in {wait_time}s")
                    time.sleep(wait_time)

        raise last_error

    def log_execution(self, phase: str, success: bool, input_data):
        """Log for auditing."""
        self.execution_log.append({
            "phase": phase,
            "success": success,
            "input": input_data
        })

workflow = RobustWorkflow()
result = workflow.execute_with_retry(process_data, input_data)
```

## Async Workflows

```python
import asyncio
from typing import Coroutine

class AsyncWorkflow:
    async def parallel_tasks(self, tasks: list[Coroutine]):
        """Execute tasks in parallel."""
        results = await asyncio.gather(*tasks)
        return results

    async def sequential_tasks(self, tasks: list[Coroutine]):
        """Execute sequentially."""
        results = []
        for task in tasks:
            result = await task
            results.append(result)
        return results

    async def with_timeout(self, coro: Coroutine, timeout_seconds: int):
        """Execute with timeout."""
        try:
            return await asyncio.wait_for(coro, timeout=timeout_seconds)
        except asyncio.TimeoutError:
            return None

async def task1():
    await asyncio.sleep(1)
    return "Task 1 done"

async def task2():
    await asyncio.sleep(2)
    return "Task 2 done"

workflow = AsyncWorkflow()
results = asyncio.run(workflow.parallel_tasks([task1(), task2()]))
```

## Reference Files

Heavy, per-framework implementations of the plan/execute/review loop (moved out of this
overview for progressive disclosure). Each file includes the one-line swap to drive
**Claude via the Anthropic API**:

- [`reference/langgraph.md`](ai-workflow-orchestration/reference/langgraph.md) — LangGraph graph definition with nodes, edges, and conditional loop-back.
- [`reference/crewai.md`](ai-workflow-orchestration/reference/crewai.md) — CrewAI role-based crew with task dependencies.
- [`reference/autogen.md`](ai-workflow-orchestration/reference/autogen.md) — AutoGen conversational group chat with a manager and human proxy.

## Key Takeaways

- **Pick the simplest style that fits**: plain FSM → graph (LangGraph) → role crew
  (CrewAI) → conversational group (AutoGen). Don't adopt a framework you won't use.
- **State machines formalize transitions** and give you auditable, resumable runs.
- **Human-in-loop gates** belong only on irreversible / high-blast-radius actions.
- **Error handling** (fallbacks + exponential backoff) makes runs production-grade.
- **Async execution** parallelizes independent steps for throughput.
- **All three frameworks are provider-agnostic** — drive Claude via the Anthropic API;
  see the `claude-api` skill for current model ids (Opus / Sonnet / Haiku tiers).
