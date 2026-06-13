---
name: agent-browser
description: Browser automation CLI for AI agents — navigate pages, fill forms, click buttons, take screenshots, extract data, test web apps, and automate any browser task. Use whenever a task requires programmatic web interaction.
allowed-tools: Bash(npx agent-browser:*), Bash(agent-browser:*)
---

# Browser Automation with agent-browser

## Core Workflow

Every browser automation follows this pattern:

1. **Navigate**: `agent-browser open <url>`
2. **Snapshot**: `agent-browser snapshot -i` (get element refs like `@e1`, `@e2`)
3. **Interact**: Use refs to click, fill, select
4. **Re-snapshot**: After navigation or DOM changes, get fresh refs

```bash
agent-browser open https://example.com/form
agent-browser snapshot -i
# Output: @e1 [input type="email"], @e2 [input type="password"], @e3 [button] "Submit"

agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3
agent-browser wait --load networkidle
agent-browser snapshot -i  # Check result
```

## Command Chaining

Commands can be chained with `&&` in a single shell invocation. The browser persists between commands via a background daemon, so chaining is safe and more efficient than separate calls.

```bash
# Chain open + wait + snapshot in one call
agent-browser open https://example.com && agent-browser wait --load networkidle && agent-browser snapshot -i

# Chain multiple interactions
agent-browser fill @e1 "user@example.com" && agent-browser fill @e2 "password123" && agent-browser click @e3

# Navigate and capture
agent-browser open https://example.com && agent-browser wait --load networkidle && agent-browser screenshot page.png
```

**When to chain:** Use `&&` when you don't need to read the output of an intermediate command before proceeding (e.g., open + wait + screenshot). Run commands separately when you need to parse the output first (e.g., snapshot to discover refs, then interact using those refs).

## Most-Used Commands

```bash
# Navigation
agent-browser open <url>              # Navigate (aliases: goto, navigate)
agent-browser close                   # Close browser

# Snapshot (get @refs for interaction)
agent-browser snapshot -i             # Interactive elements with refs (recommended)
agent-browser snapshot -s "#selector" # Scope to CSS selector

# Interaction (use @refs from snapshot)
agent-browser click @e1               # Click element
agent-browser fill @e2 "text"         # Clear and type text
agent-browser select @e1 "option"     # Select dropdown option
agent-browser check @e1               # Check checkbox
agent-browser press Enter             # Press key

# Get information
agent-browser get text @e1            # Get element text
agent-browser get url                 # Get current URL

# Wait
agent-browser wait @e1                # Wait for element
agent-browser wait --load networkidle # Wait for network idle
agent-browser wait --url "**/page"    # Wait for URL pattern

# Capture
agent-browser screenshot              # Screenshot to temp dir
agent-browser screenshot --full       # Full page screenshot
```

> Full command surface — every flag, alias, and option (scroll/keyboard/type, PDF, diff, etc.): see [agent-browser-reference/commands.md](agent-browser-reference/commands.md).

## Ref Lifecycle (Important)

Refs (`@e1`, `@e2`, etc.) are invalidated when the page changes. Always re-snapshot after:

- Clicking links or buttons that navigate
- Form submissions
- Dynamic content loading (dropdowns, modals)

```bash
agent-browser click @e5              # Navigates to new page
agent-browser snapshot -i            # MUST re-snapshot
agent-browser click @e1              # Use new refs
```

## Common Pattern: Form Submission

```bash
agent-browser open https://example.com/signup
agent-browser snapshot -i
agent-browser fill @e1 "Jane Doe"
agent-browser fill @e2 "jane@example.com"
agent-browser select @e3 "California"
agent-browser check @e4
agent-browser click @e5
agent-browser wait --load networkidle
```

## Timeouts and Slow Pages

The default Playwright timeout is 25 seconds for local browsers (override with `AGENT_BROWSER_DEFAULT_TIMEOUT`, in ms). For slow pages, prefer explicit waits over the default timeout:

```bash
agent-browser wait --load networkidle   # Best for slow pages
agent-browser wait "#content"            # Wait for a specific element
agent-browser wait --url "**/dashboard"  # Wait for URL pattern (after redirects)
```

Use `wait --load networkidle` after `open` on consistently slow sites before snapshotting.

## Session Cleanup

When running multiple agents concurrently, use named sessions to avoid conflicts, and always close when done to avoid leaked daemon processes:

```bash
agent-browser --session agent1 open site-a.com   # Isolated session
agent-browser session list                        # Check active sessions
agent-browser close                               # Close default session
agent-browser --session agent1 close              # Close specific session
```

If a previous session was not closed properly, the daemon may still be running — `agent-browser close` cleans it up before new work.

## When to Reach for the Reference

The full command reference covers everything not shown above. Pull it in when you need:

| Topic | What it covers |
|-------|----------------|
| Authentication & state | Login once, save/load/encrypt state, session persistence across restarts |
| Parallel sessions | Concurrent isolated sessions, scraping multiple sites |
| Connect to Chrome | `--auto-connect`, `--cdp <port>` for existing browsers |
| Annotated screenshots | Vision mode with numbered labels mapped to refs |
| Semantic locators | `find text/label/role/placeholder/testid` when refs are unreliable |
| Diffing | `diff snapshot` / `diff screenshot` / `diff url` for verifying changes |
| JavaScript eval | `eval` with `--stdin` / `-b` to avoid shell-quoting corruption |
| iOS Simulator | Mobile Safari automation via `-p ios` |
| Color scheme, local files, profiling, config file | Dark mode, `file://` access, DevTools profiling, `agent-browser.json` |

All of these live in [agent-browser-reference/commands.md](agent-browser-reference/commands.md).

## Reference Files

- [agent-browser-reference/commands.md](agent-browser-reference/commands.md) — full command reference (all options), plus advanced patterns: authentication & state persistence, parallel sessions, connecting to existing Chrome, color scheme, visual/debugging mode, local files, iOS Simulator, diffing, timeouts, session cleanup, annotated screenshots, semantic locators, JavaScript eval, and the configuration file.
