---
name: update-project-docs
description: Use after completing a batch of work to scan all project documentation for stale references, outdated statuses, missing files in folder trees, and drifted task lists. Also captures lessons learned.
version: 1.0.0
---

# Update Project Docs

## Overview

After completing work, all project documentation must be updated to reflect the current state. Documentation that says "planned" when the feature shipped is worse than no documentation — it actively misleads.

## When to Use

- A milestone, step, or batch of tasks has just been completed
- New files, agents, or infrastructure were added during the work
- Team composition changed (hires, role changes, renames)
- Task status changed (pending to complete)

## Core Pattern

**Scan every document that describes project state. For each, compare what it says to what's true now. Fix every discrepancy.**

## Process

1. **Inventory documentation files.** Glob for `*.md` at project root and in key directories. Include CLAUDE.md, any project summary, task lists, team rosters, and READMEs.

2. **Read each file.** For every document, check for:
   - Folder/file trees that are missing new files or still list removed ones
   - Status lines that say "planned", "upcoming", "pending", or "once hired" for completed work
   - Team tables missing new members or listing old names
   - Task lists with unchecked boxes for finished work
   - "What's Next" sections describing work that's now done
   - Date/version references that are stale

3. **Cross-reference reality.** Run `ls` on the project root and key directories. Compare against every documented file tree. The filesystem is the source of truth.

4. **Fix each file.** Make targeted edits — don't rewrite entire documents. Preserve voice and structure. Move completed items from "planned" to "done" sections rather than deleting them.

5. **Update timestamps and signature lines** where they exist.

6. **Capture lessons learned.** Review the current conversation context and recent work for mistakes, surprises, workarounds, or non-obvious discoveries that could prevent future errors. For each learning, append a timestamped single-line summary to `Learnings.md` in the project root, matching the existing format:
   ```
   - **YYYY-MM-DD** — One-sentence lesson that states the pitfall and the fix or takeaway.
   ```
   - Focus on things that were **surprising, costly, or easy to repeat** — not routine steps.
   - Check for similar entries already in the file. Read `Learnings.md` first and consolidate similar learnings. When consolidating, increment the counter: `[2x]`, `[3x]`, etc.
   - If there are no new lessons, skip this step — don't add filler.

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Only updating one file | Scan ALL documentation — state references hide in multiple places |
| Deleting "planned" items instead of moving them to "done" | Completed work is history worth keeping — move it, don't erase it |
| Forgetting folder tree diagrams | These go stale fastest — always cross-check against `ls` |
| Missing delegation rule updates | If a role was "once hired" and is now filled, update the reference by name |
| Skipping task list status lines | A task list header saying "pending" when all boxes are checked is contradictory |
| Skipping lessons learned | Mistakes that aren't recorded get repeated — review the session for surprises and pitfalls |
