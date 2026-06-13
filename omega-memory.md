---
name: omega-memory
author: Georgi Gaydarov
description: Skill for working with the omega-memory MCP — persistent semantic knowledge graph that survives session resets. Covers startup ritual, storing, searching, batch import, and integration patterns for Claude Code and claude.ai.
---

# Omega-Memory Skill

Omega-memory is the primary persistent memory system for Claude Code sessions.
It runs as a local HTTP daemon (launchd) and provides semantic search, multi-agent
coordination, and knowledge graph capabilities across all sessions.

## Connection

- **URL:** `http://127.0.0.1:8377/mcp/`
- **Transport:** MCP Streamable HTTP (SSE)
- **Required headers:** `Content-Type: application/json` + `Accept: application/json, text/event-stream`
- **Auto-starts:** macOS launchd — restarts on crash/reboot
- **Data store:** `~/.omega/` (omega.db, llm_usage.db, logs/, milestones/, backups/)

## Session Startup Ritual

Always call these at the START of every Claude Code session:

```
omega_welcome()      # loads recent context, reminders, active memories
omega_protocol()     # loads operating rules and behavioral guidelines
```

## 5 Core Tools

| Tool | When to use |
|---|---|
| `omega_welcome()` | Session start — always |
| `omega_protocol()` | After welcome, or for specific section rules |
| `omega_store(content, event_type, metadata)` | Save anything worth keeping |
| `omega_call(tool, args)` | Execute any omega tool by name |
| `omega_tools()` | Discover the full set of available tools |

## Storing Memories

### Single store
```python
omega_store(
    content="FastAPI + SQLAlchemy async requires session.commit() before returning",
    event_type="lesson_learned",
    metadata={"tags": ["fastapi", "sqlalchemy", "async"]}
)
```

### Batch store (most efficient — one call)
```python
omega_store(
    content=items[0]["content"],   # required top-level content
    items=[
        {"content": "...", "event_type": "memory", "metadata": {"tags": [...]}},
        {"content": "...", "event_type": "lesson_learned", "metadata": {}},
        # ... up to 100 items
    ]
)
```

### Event types
| Type | Use for |
|---|---|
| `memory` | General facts (default) |
| `session_summary` | End-of-session recap |
| `lesson_learned` | Bug fixes, debugging wins, workarounds |
| `decision` | Architecture and design choices |
| `user_preference` | Coding style, output format, personal prefs |
| `constraint` | Hard rules, disqualifiers, must-not-dos |
| `error_pattern` | Recurring failure modes |
| `task_completion` | Finished milestones |

### Priority (1–5)
- Use `priority=5` for urgent/critical memories (interviews, active tasks)
- Use `priority=4` for important project state
- Default is auto-set from event_type

## Searching
```python
omega_call(tool='omega_search', args={'query': 'Gesh architecture decisions'})
omega_call(tool='omega_timeline', args={})        # all memories in time order
omega_call(tool='omega_checkpoint', args={})      # snapshot before context fills
```

## Bulk Import from External Sources

Use `~/04_AI_Claude/omega_bulk_import.py` to load memories from claude.ai
chat history, Gmail, Notion, or any external source.

```bash
python3 ~/04_AI_Claude/omega_bulk_import.py
```

Script uses batch mode + SSE-aware parsing. Fixed issues:
- ✅ HTTP 406 fix: adds `Accept: application/json, text/event-stream`
- ✅ SSE parsing: scans all lines for `data:` prefix
- ✅ Batch mode: all memories in one `items[]` call
- ✅ Uses `event_type` (not `category`)

## Inspecting Current State

Omega holds a large, growing knowledge graph spanning identity, projects, job search,
preferences, interviews, history, and tooling. The live count and category breakdown
change constantly — never hardcode them. To see what is actually stored right now:

```python
omega_call(tool='omega_search', args={'query': 'your topic'})  # semantic lookup
omega_call(tool='omega_timeline', args={})                     # everything, time-ordered
omega_welcome()                                                # current briefing + counts
```

## Integration with claude.ai

Omega runs locally on Mac — not reachable from Claude.ai cloud container.
To sync Claude.ai session knowledge → omega:
1. Write memories to `~/04_AI_Claude/omega_bulk_import.py`
2. Run from Mac terminal: `python3 ~/04_AI_Claude/omega_bulk_import.py`

## Troubleshooting

| Error | Fix |
|---|---|
| HTTP 406 | Missing `Accept: application/json, text/event-stream` header |
| `Expecting value: line 1 col 1` | SSE response not parsed — scan lines for `data:` prefix |
| Connection refused | launchd not running — check `launchctl list \| grep omega` |
| Wrong params | Use `event_type` not `category`; `content` not `text` |
