# Codex implementation

How to wire each layer into a Codex project. Codex differs from Claude
Code in that it has no hooks system, no Skill tool, and no slash
commands. Most of what hooks do automatically in Claude Code must
instead be instructed explicitly in `AGENTS.md`.

Layers 5-6 only apply if you maintain a personal note system. Skip
those sections if you don't have one.

## Layer 1: Identity

Lives in `AGENTS.md` at the project root. Codex reads it automatically
at session start. AGENTS.md is the operational rulebook for Codex,
the equivalent of CLAUDE.md for Claude Code. Pair it with `identity.md`
for agent character and `USER.md` for user profile, both loaded by
AGENTS.md at session start.

The files in `examples/` are illustrative, not drop-in. Personalize
`identity.md` for your agent (its name, role, character traits) and
`USER.md` for the user (their role, working style, preferences). The
examples show the shape and level of specificity that lands well.
Shipping either file unmodified produces an agent that thinks it's
"Echo" helping "Alex Rivera."

A minimal AGENTS.md heartbeat looks like:

```markdown
# AGENTS.md

At session start, read in order:
1. `identity.md` , agent character
2. `USER.md` , user profile
3. `distilled-memory.md` if it exists , durable context from past weeks
4. `sessions/{yesterday}.md` if it exists , bridge from last session
5. Open or create `sessions/{today}.md`

Update today's session log incrementally as work happens. When the
context window approaches its limit, write the 7-section pre-compact
snapshot to today's log first, then continue or summarize.
```

## Layer 2: Working memory

The live conversation context. No setup needed.

## Layer 3: Session log

Codex has no hooks. The agent must be instructed explicitly in
`AGENTS.md` to:

1. At session start: open `sessions/YYYY-MM-DD.md` (create if missing).
2. Read `sessions/{yesterday}.md` if it exists.
3. Update today's file incrementally as work happens.
4. When the context window approaches its limit (or the user requests
   compaction): write the 7-section structured snapshot manually
   before any compaction or summarization.

A "Session log protocol" section in AGENTS.md is the standard place
for these instructions.

## Layer 4: Distilled memory

Same compression pattern as Claude Code, but without the watchdog
integration. Use system cron, launchd, or whatever scheduler you
prefer to run a weekly job that reads recent session logs and
rewrites `distilled-memory.md`.

## Layer 5: Vault

Same shell access. Use the official
[Obsidian CLI](https://help.obsidian.md/cli) or direct file operations
through the Codex shell. Permissions and sandbox are configured at
the Codex level, not in this stack.

## Layer 6: Wiki

Same pattern as Claude Code. Build ingest, query, lint, and rebuild
as shell scripts the agent can invoke. Document the commands in
`AGENTS.md` so the agent knows the workflow.

## Differences worth knowing

- **No hooks.** Everything happens because AGENTS.md tells the agent
  to do it. Forgetting an instruction means the layer doesn't get
  maintained.
- **No Skill tool.** Composite workflows are run by the agent
  following written instructions, not by a separate skill orchestrator.
- **No TaskCreate / TaskUpdate.** Track session steps inline in the
  agent's reasoning or in a `tasks/todo.md` file.
- **MCP configuration is user-level.** Lives in `~/.codex/config.toml`,
  not in this project. Don't expect project-level MCP setup to work
  the way it does in Claude Code.
