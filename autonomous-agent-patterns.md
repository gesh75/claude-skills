---
name: autonomous-agent-patterns
description: "Design patterns for building autonomous coding agents. Covers tool integration, permission systems, browser automation, and human-in-the-loop workflows."
---

# Autonomous Agent Patterns

## Core Agent Loop
```
while not done:
  observation = get_environment_state()
  action = llm(system_prompt, history, observation, tools)
  if action.requires_approval: ask_human(action)
  result = execute(action)
  history.append(action, result)
  if is_terminal(result): break
```

## Goal Definition Template
```
Goal:      [specific, measurable outcome]
Success:   [how to verify]
Avoid:     [constraints — what NOT to do]
Fallback:  [what to do if blocked]
Budget:    [max time / API calls / cost]
```

## Tool Schema Pattern
```typescript
{
  name: "edit_file",
  description: "Replace exact string in file. Use for targeted edits.",
  input_schema: {
    type: "object",
    properties: {
      path: { type: "string", description: "Absolute file path" },
      old_str: { type: "string", description: "Exact string to replace" },
      new_str: { type: "string", description: "Replacement string" }
    },
    required: ["path", "old_str", "new_str"]
  }
}
```

## Permission Levels
| Level | Examples | Requires approval |
|---|---|---|
| Read-only | read_file, list_dir, search | Never |
| Safe write | write_new_file, append_log | Never |
| Destructive | delete_file, overwrite | Always |
| System | run_command, network_call | Configurable |

## Human-in-the-Loop Triggers
- File deletion or destructive operations
- Spend over $X / N API calls
- Confidence below threshold
- Action outside defined scope
- First time doing a new action type

## Multi-Model Architecture
```
Orchestrator (Opus/Sonnet) — planning, reasoning, tool selection
    ↓ delegates subtasks
Executor (Haiku/Sonnet)   — file edits, searches, transforms
    ↓ results back
Verifier (Sonnet)         — checks output matches intent
```

## Self-Healing / Error Recovery
| Failure | Recovery |
|---|---|
| Command fails | Retry modified → try alternative |
| File not found | Search similar → ask clarification |
| Tests fail | Revert → analyze → different approach |
| Permission denied | Log + skip + report at end |
| Loop detected | Checkpoint → resume from last verified state |

## Safety Guardrails
- Whitelist allowed directories for file operations
- Max iterations cap (prevent infinite loops)
- Budget cap: max tokens + max wall time
- Checkpoint state every N actions for rollback
- Log all tool calls with input/output for audit
- Per-action timeout; require human approval for destructive ops
