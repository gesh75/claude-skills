---
name: ai-pair-programmer
description: Complete AI-assisted development workflow — planning, implementation, testing, and review loops.
category: AI & Claude Code Mastery
version: 1.0.0
---

# AI Pair Programmer

## 4-Phase Workflow

**Phase 1: Plan (before any code)**
```
Ask Claude for a plan, not code.
"I need to build X. What's the approach? What are the risks? What should I decide first?"
Review + agree on approach → then ask for implementation.
```

**Phase 2: Implement (guided generation)**
- One feature/function at a time — don't ask for everything at once
- Provide context: existing patterns, constraints, what already exists
- Ask for the test first, then the implementation

**Phase 3: Review loop**
```
After each chunk:
1. Read the generated code yourself — don't skip this
2. Run tests
3. Ask: "What could go wrong with this approach?"
4. Ask: "What did you simplify or skip?"
```

**Phase 4: Handoff**
- Ask Claude to write a commit message describing what was done and why
- Ask: "What would the next developer need to know about this code?"

## Feature Requirements Template
```
Feature: [name]
What: [what it does]
Why: [why it's needed]
Success criteria: [how to know it's done]
Constraints: [performance, security, compatibility]
Existing patterns to follow: [file/function references]
```

## Effective Prompting Patterns
| Instead of | Say |
|---|---|
| "Write me a login system" | "What's the simplest auth approach for this stack?" |
| "Fix this bug" | "Here's the error + stack trace + what I've tried" |
| "Make it better" | "This is slow under load — what would you change first?" |

## Warning Signs
- Claude generates >100 lines without you reviewing = too much at once
- You don't understand what was generated = ask for explanation before continuing
- Tests are passing but you didn't write them = verify they actually test the right thing
