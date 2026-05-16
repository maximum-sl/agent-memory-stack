# Codex implementation

Codex has no hooks, no Skill tool, and no slash commands. That means Codex
*only* has the Core tier , everything is maintained by instruction in
`AGENTS.md`. There is no automation tier on the agent side; the only
optional add-on is a system scheduler for distillation.

Layers 5-6 only apply if you maintain a personal note system. Skip those
sections if you don't have one.

---

## Core (zero dependencies)

Nothing to install. Markdown files plus a heartbeat block in `AGENTS.md`
plus `PROTOCOL.md`. That is the entire stack.

### Layer 1: Identity

Three files at the project root:

- `AGENTS.md` , the operational rulebook (Codex's equivalent of `CLAUDE.md`).
  Codex reads it automatically at session start.
- `identity.md` , the agent's character.
- `USER.md` , the user profile.

The `examples/` files are illustrative, not drop-in. Personalize them.
Shipping either unmodified produces an agent that thinks it's "Echo"
helping "Alex Rivera."

Put this heartbeat in `AGENTS.md`:

```markdown
# AGENTS.md

This project uses agent-memory-stack. Follow PROTOCOL.md.

At session start, read in order:
1. `identity.md` , agent character
2. `USER.md` , user profile
3. `distilled-memory.md` if it exists , durable context from past weeks
4. `sessions/{yesterday}.md` if it exists , bridge from last session
   (pay attention to its Open threads / Pending user asks)
5. Open or create `sessions/{today}.md`

Update today's session log incrementally as work happens. When the context
window approaches its limit (or the user requests compaction), write the
7-section pre-compact snapshot (see PROTOCOL.md) to today's log first.
```

### Layer 2: Working memory

The live conversation context. No setup needed.

### Layer 3: Session log

Codex has no hooks, so this is purely instruction-driven , which is exactly
the Core model. A "Session log protocol" section in `AGENTS.md` (the
heartbeat above plus a pointer to `PROTOCOL.md`) is the standard place. The
agent must: open/create `sessions/{today}.md`, read `sessions/{yesterday}.md`,
update incrementally, and write the pre-compact snapshot before any
compaction or summarization.

### Layer 4: Distilled memory

Read `distilled-memory.md` at session start (in the heartbeat). Update on
demand by asking the agent directly:

> "Read the last two weeks of `sessions/`, rewrite `distilled-memory.md`:
> durable decisions, standing constraints, and corrections only, as terse
> rules, capped at ~3KB. Drop anything transactional or already resolved."

See [`../distillation.md`](../distillation.md) for the keep/drop contract
and a worked before/after.

### Layer 5: Vault (optional, needs a note system)

Use the [Obsidian CLI](https://help.obsidian.md/cli) or direct file
operations through the Codex shell, per `PROTOCOL.md`. Sandbox and
permissions are configured at the Codex level, not in this stack.

### Layer 6: Wiki (optional, needs a vault)

Same Karpathy pattern as Claude Code; run ingest/query/lint/rebuild as
shell operations the agent invokes, documented in `AGENTS.md`.

---

## Optional add-on (one only)

Codex has no hook system, so the only optional automation is **distillation
scheduling**: a system `cron`, `launchd`, `systemd` timer, or any scheduler
running a weekly job that rewrites `distilled-memory.md` from recent session
logs. Everything else stays instruction-driven by design.

## Differences from Claude Code worth knowing

- **No hooks.** Every layer behavior happens because `AGENTS.md` instructs
  it. Forgetting an instruction means the layer doesn't get maintained.
  This makes a clear, explicit `AGENTS.md` more important than in Claude Code.
- **No Skill tool.** Composite workflows are the agent following written
  instructions, not a separate orchestrator.
- **No TaskCreate / TaskUpdate.** Track session steps inline or in a
  `tasks/todo.md` file.
- **MCP configuration is user-level** (`~/.codex/config.toml`), not in this
  project. Don't expect project-level MCP setup to behave like Claude Code.
