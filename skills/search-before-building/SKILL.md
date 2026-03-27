---
name: search-before-building
description: Use when about to build infrastructure, implement unfamiliar patterns, or create something the runtime might already provide — enforces a search-first discipline with three layers of knowledge (tried-and-true, new-and-popular, first-principles) and logs eureka moments.
version: 1.0.0
---

# Search Before Building

Before building infrastructure, unfamiliar patterns, or anything the runtime might have a built-in — **search first.**

## Three Layers of Knowledge

- **Layer 1** (tried and true — in distribution). Don't reinvent the wheel. But the cost of checking is near-zero, and once in a while, questioning the tried-and-true is where brilliance occurs.
- **Layer 2** (new and popular — search for these). But scrutinize: humans are subject to mania. Search results are inputs to your thinking, not answers.
- **Layer 3** (first principles — prize these above all). Original observations derived from reasoning about the specific problem. The most valuable of all.

## Eureka Moments

When first-principles reasoning reveals conventional wisdom is wrong, name it:
"EUREKA: Everyone does X because [assumption]. But [evidence] shows this is wrong. Y is better because [reasoning]."

Log eureka moments to the project's `Learnings.md` file with a timestamped entry describing the insight, the assumption it overturns, and the evidence.

## WebSearch Fallback

If WebSearch is unavailable, skip the search step and note: "Search unavailable — proceeding with in-distribution knowledge only."
