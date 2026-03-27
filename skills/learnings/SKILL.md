---
name: learnings
description: Use when starting a task (check for relevant prior lessons) and when discovering non-obvious insights during work — maintains a project Learnings.md file with timestamped lessons learned to prevent repeating mistakes.
version: 1.0.0
---

# Learnings Management

## On Task Start

Before beginning work, check if `Learnings.md` exists in the project root. If it does, read it and scan for lessons relevant to the current task. Apply relevant lessons proactively — don't wait to rediscover them.

## On Discovery

When you encounter something surprising, costly, or easy to repeat — a pitfall, a non-obvious solution, a conventional wisdom that turned out to be wrong — log it immediately.

### Format

Append a single line to `Learnings.md`:

```
- **YYYY-MM-DD** — One-sentence lesson that states the pitfall and the fix or takeaway.
```

### Rules

- Focus on things that are **surprising, costly, or easy to repeat** — not routine steps.
- Check for similar entries already in the file. If a lesson is already logged, increment its counter: `[2x]`, `[3x]`, etc. at the beginning of the description.
- If the lesson is a refinement of an existing one, update the existing entry rather than adding a duplicate.
- If there are no new lessons, skip this step — don't add filler.
- Convert relative dates to absolute dates (e.g., "yesterday" → "2026-03-27").

## Creating Learnings.md

If the file doesn't exist and you have a lesson to log, create it:

```markdown
# Learnings

- **YYYY-MM-DD** — Your lesson here.
```
