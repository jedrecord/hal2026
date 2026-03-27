---
name: hal-init
description: Initialize a project for Hal team orchestration — creates folder structure, seeds team roster, copies agent templates, and configures CLAUDE.md.
argument-hint: [optional project type, e.g. "web app", "data pipeline", "CLI tool"]
allowed-tools: [Read, Write, Edit, Bash, Glob, AskUserQuestion]
---

# Initialize Hal Orchestration

Set up the current project directory for Hal team orchestration.

## Pre-flight Check

1. Check if `Team/team_roster.md` already exists. If so, warn the team lead that this project appears to already be initialized and ask whether to proceed or abort.
2. Check if `CLAUDE.md` already exists — if so, you'll append to it rather than overwrite.

## Step 1: Gather Context

Ask the team lead (use the askuserquestion format):
- **Project name** — What is this project called?
- **Project type** — What kind of project? (e.g., web app, CLI tool, data pipeline, mobile app, API service). Use $ARGUMENTS if provided.
- **Tech stack** — What languages, frameworks, and infrastructure? Be specific (e.g., "Python + FastAPI + PostgreSQL" or "vanilla HTML/JS + SQLite via sql.js").
- **Team lead name** — What name should appear in the roster as Team Lead?
- **Orchestrator name** — What should the AI orchestrator be called? (Default: Hal). The name should be a simple word or short phrase — no special characters like |, *, [, or ]. If the team lead provides no name or an empty response, use "Hal" as the default.
- **Voice profile** — Does the team lead want a writing style guide for consistent communication across agents? (Optional — creates a placeholder if yes.)

**Placeholder note:** Template files (`templates/team_roster.md`, `templates/claude-md-append.md`) use `[Orchestrator]`, while the inline content in Steps 6 and 7 below uses `[Orchestrator Name]`. Both should be replaced with the chosen orchestrator name.

## Step 2: Create Folder Structure

Create these directories (use `mkdir -p` via Bash):
- `Owners_Inbox/`
- `Team_Inbox/`
- `Team/`
- `.agents/`
- `scratch/`
- `docs/superpowers/specs/`
- `docs/superpowers/plans/`

If the team lead wants a voice profile, also create:
- `Owner/`

## Step 3: Seed Team Roster

Create `Team/team_roster.md` based on the template at `templates/team_roster.md` in this plugin's directory. Replace `[Owner]` with the team lead's name, replace `[Orchestrator]` with the chosen orchestrator name (default: Hal), and set the date.

## Step 4: Copy and Customize Agent Templates

Copy agent templates from this plugin's `agents/` directory into the project's `.agents/` directory:
- `holly.md` → `.agents/holly.md` (copy as-is)
- `rachel.md` → `.agents/rachel.md` (copy as-is)
- `developer.md` → `.agents/developer.md`
- `qa-engineer.md` → `.agents/qa-engineer.md`
- `code-reviewer.md` → `.agents/code-reviewer.md`

**Ask the team lead to name** the Developer, QA Engineer, and Code Reviewer agents. Update the `name` field in each file's frontmatter and the Identity heading in the body.

**Customize the `### Project-Specific Constraints` sections** based on the tech stack. Remove the example blocks and replace with actual constraints for this project. Here's what to fill in for common project types:

### Local-First Browser App (sql.js + IndexedDB)
**Developer constraints:**
- Load sql.js from CDN with `locateFile` callback
- IndexedDB as sole persistence backend (never OPFS, never localStorage)
- `PRAGMA foreign_keys = ON` after every DB init and loadDb call
- Schema versioning via `PRAGMA user_version` — increment on every change
- FTS5 external-content tables with exactly 3 triggers (INSERT, UPDATE, DELETE)
- Tags always via join table, never comma-separated columns
- Timestamps as INTEGER (Unix ms via `Date.now()`), never TEXT
- Saves debounced 300-500ms, never on every mutation
- Event delegation from stable parents, never on dynamic elements
- Backup download button from first working version
- Single-file HTML deliverable — no npm, bundlers, or frameworks
- No server-side code or APIs

**QA test targets:**
- Every CRUD operation per entity type
- Persistence: write → reload page → verify data survived IndexedDB round-trip
- FTS5 search after insert, update, delete
- Edge cases: empty strings, special chars, Unicode, max-length
- PRAGMA checks: user_version, foreign_key_list, trigger existence
- Backup: download .db, verify valid SQLite

**Reviewer checklist additions:**
- PRAGMA foreign_keys = ON after every DB init and loadDb
- PRAGMA user_version incremented if schema changed
- FTS5 triggers present (all 3) for every FTS table
- No inline event handlers
- No localStorage or OPFS
- No APIs that fail on file:// protocol
- Backup download still functional
- Single-file structure maintained

### Web App (React/Vue/Svelte)
**Developer constraints:**
- Framework: [specific framework and version]
- State management: [library or pattern]
- Routing: [library or convention]
- API layer: [REST/GraphQL, client library]
- CSS approach: [Tailwind/CSS modules/styled-components]
- Build tooling: [Vite/webpack/Next.js]
- Testing: [Jest/Vitest/Playwright]

**QA test targets:**
- Pages/routes to test, form interactions, navigation flows
- Authentication flows (login, logout, session expiry)
- Responsive breakpoints
- API error states (network failure, 500s, timeouts)

**Reviewer checklist additions:**
- Component follows framework conventions
- State management patterns consistent
- No prop drilling beyond 2 levels
- Accessibility (ARIA labels, keyboard navigation)
- Bundle size impact checked

### CLI Tool
**Developer constraints:**
- Language: [Python/Node/Go/Rust]
- Argument parsing: [argparse/click/commander/clap]
- Output format: [plain text/JSON/table]
- Error handling: exit codes (0 success, 1 user error, 2 system error), stderr vs stdout
- Configuration: [config file location and format]
- No interactive prompts in non-TTY mode

**QA test targets:**
- Every command with valid args, missing args, invalid args
- Exit codes for success and each error type
- Piped input: `echo data | tool command`
- Config file: present, missing, malformed
- Output formats: default, --json, --quiet

**Reviewer checklist additions:**
- Help text complete for all commands/flags
- Exit codes correct
- Errors to stderr, output to stdout
- --json produces valid JSON
- Destructive ops require --force or confirmation

### API Service (FastAPI/Express/Rails)
**Developer constraints:**
- Framework: [specific framework]
- ORM/query builder: [SQLAlchemy/Prisma/ActiveRecord]
- Migration tool: [Alembic/Prisma migrate/Rails migrations]
- Auth: [JWT/OAuth/session-based]
- Validation: [Pydantic/Joi/ActiveModel]
- Logging: structured with correlation IDs
- Containerization: Docker Compose for local dev

**QA test targets:**
- Every endpoint: valid, invalid, unauthorized
- HTTP status codes match spec
- Pagination, filtering, sorting
- Rate limiting behavior
- Concurrent request handling

**Reviewer checklist additions:**
- Migration generated for schema changes
- Request validation on all endpoints
- Auth required unless explicitly public
- DB sessions properly managed
- N+1 queries avoided
- Rate limiting on public endpoints

## Step 5: Create .claudeignore

Copy the `.claudeignore` template from this plugin's `templates/claudeignore` into the project root as `.claudeignore`. This file uses `.gitignore` syntax to block Claude from accessing specified files and directories. The default blocks `scratch/`.

## Step 6: Create Project Files

Create `Learnings.md` in the project root:
```markdown
# Learnings

<!-- Timestamped lessons learned. See /hal skills for format. -->
```

Create `tasks.md` in the project root:
```markdown
# Tasks

<!-- Tracked by [Orchestrator Name]. Only [Orchestrator Name] reassigns tasks. Default assignee is the team lead. -->
```

If the team lead wants a voice profile, create `Owner/voice-profile.md`:
```markdown
# Voice Profile

<!-- Describe the team lead's writing style, tone, and communication preferences. -->
<!-- This profile is shared with all agents so deliverables match expectations. -->
```

## Step 7: Update CLAUDE.md

If `CLAUDE.md` exists, append the orchestration context. If it doesn't exist, create it.

Also read `templates/claude-md-append.md` from this plugin's directory and append its content, replacing `[Orchestrator]` with the chosen orchestrator name.

Append (or create with) this content, customized with the project name, team member names, and orchestrator name:

```markdown
# [Project Name] — [Orchestrator Name] Orchestration

You are **[Orchestrator Name]**, [Team Lead]'s AI orchestrator. You are the single point of contact for all requests.

## Core Guardrail

**[Orchestrator Name] NEVER does the work directly.** Every task must be delegated to the appropriate AI team member.

## How It Works

1. [Team Lead] gives [Orchestrator Name] a task
2. [Orchestrator Name] reads the team roster and delegates to the right specialist
3. The specialist does the work and reports back
4. [Orchestrator Name] summarizes the result

## Development Pipeline

For non-trivial features: Spec → Plan → Build → Review → Test → Ship
- Specs live in `docs/superpowers/specs/`
- Plans live in `docs/superpowers/plans/`

## Delegation Rules
- Research tasks → Senior Researcher
- New hire needed → Senior Researcher researches, then Holly creates the agent
- Development work → [Developer Name]
- QA / testing → [QA Name]
- Code review → [Reviewer Name]
- Unknown domain → Senior Researcher investigates first

## Folder Structure
- `Owners_Inbox/` — Drop requests here for [Orchestrator Name] to process
- `Team_Inbox/` — Completed deliverables from team members
- `Team/team_roster.md` — Active team roster (source of truth)
- `.agents/` — Agent definition files (managed by Holly)
- `Learnings.md` — Timestamped lessons learned
- `scratch/` — Working files and drafts
- `docs/superpowers/specs/` — Feature specifications
- `docs/superpowers/plans/` — Implementation plans

## Tool Usage Rules
- Use Read instead of cat, head, tail, or sed
- Use Edit instead of sed or awk
- Use Write instead of cat or echo
- Use Glob instead of find or ls
- Use Grep instead of grep or rg
- Reserve Bash for system commands and terminal operations only
- Prefer `gh` CLI over raw `git` commands
```

## Step 8: Confirm

Report what was created:
- Number of directories created
- Number of agent files installed (with names)
- Team roster location
- Development pipeline: Spec → Plan → Build → Review → Test → Ship
- How to start: "Run `/hal` followed by your request"
