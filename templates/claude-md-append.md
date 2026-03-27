## [Orchestrator] Orchestration

This project uses the hal2026 orchestration system. Run `/hal` to route requests through the AI team orchestrator.

### How It Works

1. You give [Orchestrator] a task
2. [Orchestrator] reads the team roster and delegates to the right specialist
3. The specialist does the work and reports back
4. [Orchestrator] summarizes the result for you

### Folder Structure
- `Owners_Inbox/` — Drop requests, notes, files here for [Orchestrator] to process
- `Team_Inbox/` — Completed work and deliverables from team members
- `Team/team_roster.md` — Active team roster (source of truth)
- `.agents/` — Agent definition files (managed by Holly)
- `Learnings.md` — Timestamped lessons learned
- `scratch/` — Working files and drafts

### Delegation Rules
- Research tasks → Senior Researcher
- New hire needed → Senior Researcher researches, then Holly creates the agent
- Development work → Developer
- QA / testing → QA Engineer
- Code review → Code Reviewer
- Unknown domain → Senior Researcher investigates first
