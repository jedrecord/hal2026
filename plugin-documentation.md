# hal2026 — Plugin Documentation

## Intent

hal2026 exists because of a simple observation: **Claude is more effective when it doesn't try to do everything itself.**

Most AI coding workflows put a single model in charge of understanding, planning, building, reviewing, and testing — all in one conversation. This works for small tasks, but breaks down as complexity grows. Context gets lost. Quality drifts. The model starts cutting corners because it "knows" what it built.

hal2026 solves this by introducing **separation of concerns at the AI layer**. Instead of one model doing everything, a team of specialized agents each own a piece of the workflow. A developer who only builds. A reviewer who only reads diffs against the spec. A QA engineer who only tests observable behavior. An orchestrator who only routes and coordinates.

The result: higher quality work, clearer accountability, and a workflow that scales with project complexity.

## The Core Idea

**Hal never does the work.** This is the non-negotiable rule at the heart of the system.

Hal is the orchestrator — the single point of contact between you (the team lead) and your AI team. When you give Hal a task, Hal's job is to:

1. Understand what you're asking
2. Determine who on the team should handle it
3. Dispatch them with full context
4. Report the result back to you

Hal does not write code. Hal does not run tests. Hal does not conduct research. Hal routes, coordinates, and communicates. This constraint is what makes the system work — it forces clean handoffs, explicit context sharing, and accountability at every step.

## Why This Architecture

### The Problem with Single-Agent Workflows

When one model does everything:
- **Context pollution.** The model that wrote the code is biased toward thinking it's correct. It will unconsciously skip edge cases it "knows" it handled.
- **Role confusion.** Is it building or reviewing? Testing or fixing? The boundaries blur, and quality suffers.
- **Scope creep.** Without explicit delegation, the model adds "helpful" features nobody asked for, refactors working code, or makes architectural decisions that should be yours.
- **No accountability.** When something breaks, there's no trail of who decided what.

### How Hal Fixes This

- **Separate agents can't see each other's reasoning.** The Code Reviewer reads the diff fresh — it doesn't remember writing it. The QA Engineer tests observable behavior — it doesn't know what the code "should" do, only what it actually does.
- **Explicit dispatch forces context clarity.** Hal must package the task, the spec, the relevant learnings, and the completion protocol into every dispatch. This eliminates the "I assumed you knew" failure mode.
- **Role boundaries prevent overreach.** The developer can't skip review. The reviewer can't modify code. QA can't declare "pass" without running the test. Each agent stays in their lane.
- **The orchestrator stays above the work.** Hal makes routing decisions, not implementation decisions. This keeps the team lead in control of direction while the team handles execution.

## The Team

### Leadership
| Role | Purpose |
|------|---------|
| **Team Lead** (you) | Direction, decisions, final say on everything |
| **Hal** (orchestrator, opus) | Routes tasks, enforces pipeline, reports results |

### Core Team
| Role | Purpose | Model |
|------|---------|-------|
| **Holly** (HR Director) | Designs and hires new agents, maintains roster | sonnet |
| **Rachel** (Senior Researcher) | Deep research, expert profiling, due diligence | sonnet |
| **Developer** (customized per project) | All implementation work — code, schema, UI | sonnet |
| **QA Engineer** (customized per project) | Testing, persistence verification, edge cases | sonnet |
| **Code Reviewer** (customized per project) | Spec compliance, pattern enforcement, data safety | sonnet |

### Why These Five Roles

These aren't arbitrary. They map to the natural stages of a software development workflow:

1. **Research** (Rachel) — Before building anything, understand the domain. Before hiring anyone, understand the role.
2. **Build** (Developer) — Implement the feature according to spec and constraints.
3. **Review** (Code Reviewer) — Verify the implementation matches the spec. Catch what the developer missed.
4. **Test** (QA Engineer) — Verify the feature works in practice. Observable behavior, not code reading.
5. **Hire** (Holly) — When a new capability is needed, create a new specialist. Always research-first.

The orchestrator (Hal) sits above all five, ensuring work flows through the pipeline in the right order.

## The Development Pipeline

hal2026 enforces a disciplined development pipeline:

```
Spec → Plan → Build → Review → Test → Ship
```

### Why Each Step Matters

**Spec (PRD):** Defines WHAT to build and WHY. Without a spec, the developer guesses at requirements and the reviewer has nothing to check against. Specs live in `docs/superpowers/specs/`.

**Plan:** Defines HOW to build it — step by step, with dependencies and sequencing. Prevents the developer from making architectural decisions on the fly. Plans live in `docs/superpowers/plans/`.

**Build:** The developer implements according to the plan and spec. Scope discipline is critical — build exactly what's scoped, nothing more.

**Review:** The Code Reviewer reads the diff against the spec. Not against vibes, not against "best practices" — against the spec. Three possible verdicts:
- **APPROVE** — Ship it.
- **REQUEST CHANGES** — Fix these issues, then I'll re-review.
- **BLOCK** — Data-safety violation or spec contradiction. Cannot ship.

**Test:** The QA Engineer tests the running application. Not the code — the application. They don't know what the code says; they know what the spec promises and what the UI shows. Every test is executed, not reasoned about.

**Ship:** Only after review approval and test passage. Hal coordinates the final delivery.

### Pipeline Enforcement

Hal enforces sequencing:
- Review cannot begin before build is complete
- Testing cannot begin before review approves
- If review returns REQUEST CHANGES, the developer fixes and review re-runs
- If tests fail, the developer fixes and tests re-run
- If review returns BLOCK, work stops and the team lead decides

This prevents the common antipattern of "building and testing at the same time" or "skipping review because we're in a hurry."

## The Hiring Pipeline

When the team needs a new capability:

1. **Rachel researches first.** She investigates what real-world experts in that domain actually do — their key skills, thinking patterns, daily tools, and what separates great from average. This produces a structured research report.
2. **Holly hires second.** Using Rachel's research, Holly designs an opinionated, specific agent definition with distinct identity, clear scope boundaries, and concrete constraints.
3. **The new agent joins the roster.** Added to `Team/team_roster.md` and available for Hal to dispatch.

**This order is mandatory.** The system learned early that going straight to hiring (skipping research) produces generic, weak agent definitions. Research-then-hire is a validated pattern — tested twice, confirmed both times.

## The Dispatch Protocol

When Hal delegates a task, it includes:

1. **Agent identity** — The full `.agents/*.md` file so the agent knows who it is
2. **The task** — Clear description with acceptance criteria
3. **The spec/PRD** — Relevant sections so the agent knows what success looks like
4. **Relevant learnings** — Past lessons from `Learnings.md` that apply to this task
5. **Tool usage rules** — Read not cat, Edit not sed, Glob not find, Grep not grep, gh not git
6. **Completion protocol** — Report back as DONE, DONE_WITH_CONCERNS, BLOCKED, or NEEDS_CONTEXT
7. **CodeGraph instructions** — If `.codegraph/` exists, use codegraph tools for code exploration

This explicitness is intentional. Agents don't share context. Every dispatch is a clean handoff with everything the agent needs to succeed.

## The Learnings System

`Learnings.md` is a timestamped log of non-obvious discoveries — pitfalls, surprises, and insights that prevent the team from repeating mistakes.

### What Gets Logged
- Things that were **surprising** (conventional wisdom was wrong)
- Things that were **costly** (wasted significant time or effort)
- Things that are **easy to repeat** (subtle traps that look correct)

### What Doesn't Get Logged
- Routine steps anyone would know
- Things already documented in the codebase
- One-time fixes unlikely to recur

### How Learnings Are Used
- Hal checks `Learnings.md` at startup before dispatching
- Relevant lessons are included in agent dispatches
- Duplicate lessons increment a counter (`[2x]`, `[3x]`) rather than being re-logged

## Skills

Skills are reusable prompt fragments that standardize how agents communicate and work:

### askuserquestion
Enforces a 5-point structure for every question asked of the team lead:
1. Re-ground (project, branch, task)
2. Simplify (plain English, no jargon)
3. Recommend (with completeness score)
4. Options (lettered, with effort estimates)
5. One decision per question

**Why:** Questions asked without context waste the team lead's time. They have to re-read code to understand what you're asking. This format assumes the team lead hasn't looked at the screen in 20 minutes.

### completion-status
Standardized status reporting: DONE, DONE_WITH_CONCERNS, BLOCKED, NEEDS_CONTEXT. Includes escalation rules — if you've tried 3 times without success, STOP and escalate.

**Why:** "I think I fixed it" is not a status. Structured reporting prevents agents from hiding uncertainty or continuing past their capability.

### search-before-building
Enforces search-first discipline with three layers of knowledge:
- Layer 1: Tried and true (don't reinvent)
- Layer 2: New and popular (search but scrutinize)
- Layer 3: First principles (prize above all)

**Why:** Agents love to build things from scratch. This forces them to check if a solution already exists before writing one.

### learnings
Maintains `Learnings.md` — checks for relevant lessons before work and logs new discoveries after.

**Why:** Without this, the same mistakes get repeated across sessions. The learnings log is the team's institutional memory.

### update-project-docs
After completing a batch of work, scans all project documentation for stale references — outdated folder trees, status lines that say "planned" for shipped features, task lists with unchecked boxes for finished work, team tables with old names. Cross-references against the filesystem and fixes every discrepancy. Also captures lessons learned.

**Why:** Documentation drifts from reality the moment work is completed. A folder tree that lists files that no longer exist, or a status page that says "upcoming" for a feature that shipped last week, actively misleads. This skill catches the drift immediately.

## Plugin Structure

```
hal2026/
├── .claude-plugin/
│   └── plugin.json                     # Plugin metadata
├── agents/                             # Agent definitions (5 team members)
│   ├── holly.md                        # HR Director — hiring, roster management
│   ├── rachel.md                       # Senior Researcher — research, profiling
│   ├── developer.md                    # Developer template — customized per project
│   ├── qa-engineer.md                  # QA Engineer template — customized per project
│   └── code-reviewer.md               # Code Reviewer template — customized per project
├── skills/                             # Reusable prompt fragments (7 skills)
│   ├── hal/SKILL.md                    # /hal — main orchestrator command
│   ├── hal-init/SKILL.md              # /hal-init — project initialization
│   ├── askuserquestion/SKILL.md       # Structured question format
│   ├── completion-status/SKILL.md     # Status reporting protocol
│   ├── search-before-building/SKILL.md # Search-first discipline
│   ├── learnings/SKILL.md            # Learnings log maintenance
│   └── update-project-docs/SKILL.md  # Post-work documentation sweep
├── hooks/                              # Hook implementations
│   ├── hooks.json                      # Hook configuration (PreToolUse)
│   └── check-ignore.sh                # .claudeignore enforcement script
├── templates/                          # Seed files for project init
│   ├── team_roster.md                  # Roster template
│   ├── learnings.md                    # Empty learnings template
│   ├── claude-md-append.md           # CLAUDE.md orchestration context
│   └── claudeignore                   # .claudeignore template (copied as .claudeignore)
├── plugin-documentation.md             # This file
└── README.md                           # Quick-start guide
```

## The .claudeignore Hook

The plugin includes a `PreToolUse` hook that enforces a `.claudeignore` file in the project root. This works exactly like `.gitignore` — any file or directory matching a pattern in `.claudeignore` is blocked from Claude's access.

### How It Works
1. Before any file operation (Read, Write, Edit, Grep, Glob), the hook fires
2. It checks if `.claudeignore` exists in the project directory
3. If it does, it runs `git check-ignore` against the target path
4. If the path matches a pattern, the tool call is blocked with a clear message
5. If no match (or no `.claudeignore`), the operation proceeds normally

### Default Patterns
The `/hal-init` command creates a `.claudeignore` with:
```
scratch/
```

### Customization
Add any `.gitignore`-compatible pattern:
```
# Block sensitive files
.env
secrets/
credentials.json

# Block large generated files
*.db
node_modules/
dist/

# Block working drafts
scratch/
drafts/
```

### Why This Matters
Without `.claudeignore`, Claude has access to every file in the project. This is usually fine, but some files should be off-limits — credentials, large binaries, working drafts that aren't ready for agent consumption, or directories that would waste context. The hook provides a clean, familiar mechanism for file-level access control.

## Getting Started

### Installation
Install hal2026 as a Claude Code plugin (local path or marketplace).

### First Use
1. Run `/hal-init` in your project directory
2. Answer the setup questions (project name, tech stack, team member names)
3. Review the generated `.agents/` files and customize constraints
4. Run `/hal` followed by your first request

### Example Session
```
You: /hal I need to add user authentication to this app

Hal: [reads roster, reads agent capabilities]
     This is a development task, but we don't have a spec for authentication.
     I recommend we write one before building.

You: Good call. Let's write the spec.

Hal: [coordinates spec writing with team lead input]
     Spec complete: docs/superpowers/specs/auth-feature.md

You: /hal Spec is ready. Build it.

Hal: [dispatches Developer with spec, learnings, tool rules]
     Devon is building authentication per the spec.
     ...
     Devon reports DONE. Sending to Richard for review.

     [dispatches Code Reviewer with diffs + spec]
     Richard: APPROVE. No issues found.

     [dispatches QA Engineer]
     Quinn ran 24 tests — ALL PASS.

     Authentication feature is shipped.
```

## Design Decisions

### Why Sonnet for agents, Opus for Hal?
Agents do focused, well-scoped work (write code, run tests, review diffs). Sonnet handles this efficiently. Hal needs to make judgment calls about routing, assess ambiguity, and manage multi-step workflows. Opus handles nuance better.

### Why generic agent templates instead of pre-built specialists?
Every project has different tech stacks and constraints. A developer who knows SQLite patterns would be wrong for a PostgreSQL project. The templates provide the workflow discipline and role boundaries; `/hal-init` fills in the domain expertise.

### Why separate agents instead of one agent with different modes?
Separation of concerns. The reviewer who reads the diff doesn't remember writing the code. The QA engineer who tests the app doesn't know what the code "should" do. This independence is the quality mechanism.

### Why require specs before building?
Because "just build it" produces features that don't match what was wanted. A spec forces alignment before effort is spent. The reviewer checks against the spec, not against the developer's interpretation. This catches misunderstandings early.

### Why the Rachel-then-Holly hiring pattern?
Because domain research before agent design produces stronger agents. This was validated empirically — agents created with research are more opinionated, specific, and effective than agents created from generic descriptions. Tested twice, confirmed both times.

### Why Learnings.md instead of memory?
Learnings are project-specific and visible to everyone. Memory is conversation-specific and invisible. A lesson learned in Tuesday's session should be available on Friday without relying on Claude's memory system to surface it.

### Why the completion-status protocol?
Because "I'm done" doesn't tell you if it actually worked. Structured status reporting (DONE/DONE_WITH_CONCERNS/BLOCKED/NEEDS_CONTEXT) forces agents to be honest about outcomes and gives the orchestrator the information needed to decide what happens next.

### Why tool usage rules?
"Use Read instead of cat" isn't a style choice — it affects how work is reviewed and understood by the user. Dedicated tools provide better output formatting, permission management, and auditability than raw shell commands. Enforce it.

### Why the development pipeline?
Spec → Plan → Build → Review → Test isn't overhead — it's the mechanism that produces quality. Skipping steps always costs more time than it saves. The pipeline exists because building without a spec produces rework, and shipping without review produces bugs.

## Lessons from Building This System

These lessons came from building and operating the PKM project that hal2026 was extracted from:

1. **Delegation is a feature, not a limitation.** The constraint that Hal can't do work directly feels restrictive but produces better outcomes than letting the orchestrator "help" with implementation.

2. **Specificity beats flexibility.** Generic agents produce generic work. The more specific an agent's constraints, the better its output. Don't be afraid to add hard rules.

3. **Research before hiring. Always.** The temptation to skip research and "just create the agent" produces weak definitions that need to be rewritten later. The Rachel-then-Holly pipeline is validated.

4. **Learnings compound.** The first few entries in Learnings.md feel ceremonial. By the 20th entry, you have a genuine knowledge base that prevents repeated mistakes.

5. **The pipeline is the product.** Spec → Plan → Build → Review → Test isn't overhead — it's the mechanism that produces quality. Skipping steps always costs more time than it saves.

6. **Explicit context beats shared context.** Every agent dispatch should include everything the agent needs. Don't assume they "know" anything from previous conversations.

7. **Names matter.** Agents with distinct names and personalities produce more consistent, higher-quality work than generic "assistant" prompts. It's not just branding — it's a cognitive anchor that shapes behavior.

8. **Tool preferences are constraints, not suggestions.** "Use Read instead of cat" isn't a style choice — it affects how work is reviewed and understood. Enforce it in every dispatch.

9. **The orchestrator should be opinionated.** Hal doesn't just route — Hal decides whether a spec is needed, whether a plan should be written, and when to loop back for review. A passive orchestrator is just a dispatcher.

10. **The team lead stays in control.** Hal asks upfront, not mid-stream. Questions use structured format. The team lead makes decisions; the team executes them. This isn't a democracy — it's a well-run team with clear authority.

11. **Grep the entire tree when renaming.** References hide in specs, plans, agent cross-references, schema seed data, and research deliverables. A targeted file list will miss surprises.

12. **Single source of truth for everything.** Duplicate documentation files drift apart silently. The roster is in one place. Agent definitions are in one place. Don't maintain two copies of anything.

13. **Batch tightly coupled work.** Splitting CSS + HTML + JS for a single feature across multiple dispatches creates integration issues. Ship related changes together.

14. **The user hasn't looked at the screen in 20 minutes.** Every question, every status update, every report should be understandable without context. Re-ground, simplify, recommend.
