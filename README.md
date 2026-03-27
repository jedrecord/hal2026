# hal2026

> A Plugin for [Claude Code](https://docs.anthropic.com/en/docs/claude-code)

AI team orchestration plugin for Claude Code. Hal is a personal AI orchestrator that delegates all work to specialized team members spawned as subagents — it never does the work directly.

## What It Does

Hal receives requests, assesses which team member is best suited, delegates via subagent, and reports results back. If no suitable team member exists, Hal triggers a hire through the HR pipeline.

## Installation

Add `hal2026` to your Claude Code plugins directory, or symlink it:

```bash
ln -s /path/to/hal2026 ~/.claude/plugins/hal2026
```

## Usage

- `/hal` — Send a task to Hal for delegation
- `/hal-init` — Initialize a new project with Hal's team structure (creates `.agents/`, `Team/`, and roster)

## Team Members

| Member | Role | Handles |
|--------|------|---------|
| **Holly** | HR Director | Hiring new agents, managing the team roster |
| **Rachel** | Senior Researcher | Research tasks, informing new hires, exploring unknowns |
| **Developer** | Developer | Database, backend, frontend, and UI work |
| **QA** | QA Engineer | Testing and quality assurance |
| **Reviewer** | Code Reviewer | Code review and standards enforcement |

## How to Customize

- **Add team members:** Ask Hal to hire a new specialist. Rachel will research the role, then Holly will create the agent definition.
- **Modify delegation rules:** Edit the Hal agent definition to update routing logic.
- **Add skills:** Drop a `SKILL.md` file into a new subdirectory under `skills/`. Skills are reusable prompt fragments that any team member can invoke.

## Hooks

- **`.claudeignore`** — Blocks Claude from accessing files/directories matching patterns (uses `.gitignore` syntax). Automatically installed via `/hal-init`.

## Development Pipeline

For non-trivial features, Hal enforces: **Spec → Plan → Build → Review → Test → Ship**

## Skills Included

- **askuserquestion** — Structured 5-point question format for clear, actionable prompts
- **completion-status** — Standardized status reporting (DONE, BLOCKED, etc.) with escalation protocol
- **search-before-building** — Search-first discipline with three layers of knowledge
- **learnings** — Project-level lessons-learned management to prevent repeating mistakes
- **update-project-docs** — Post-work documentation sweep to fix stale references, statuses, and folder trees

## Documentation

See [plugin-documentation.md](plugin-documentation.md) for the complete architecture, design decisions, workflow details, and the intent behind the system.
