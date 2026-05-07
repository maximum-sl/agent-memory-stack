# Claude Code implementation

How to wire each layer of agent-memory-stack into a Claude Code project.

Layers 5-6 only apply if you maintain a personal note system. Skip
those sections if you don't have one.

## Layer 1: Identity

Lives in `CLAUDE.md` at the project root. Claude Code reads it
automatically at session start. CLAUDE.md is the operational
rulebook (heartbeat, conventions, file pointers). Pair it with
`identity.md` for agent character and `USER.md` for user profile, both
loaded by CLAUDE.md at session start.

The files in `examples/` are illustrative, not drop-in. Personalize
`identity.md` for your agent (its name, role, character traits, what
"done" means in your context) and `USER.md` for the user (their
role, working style, preferences, constraints). The examples show
the shape and the level of specificity that lands well. Shipping
either file unmodified produces an agent that thinks it's "Echo"
helping "Alex Rivera."

A minimal CLAUDE.md heartbeat looks like:

```markdown
# CLAUDE.md

At session start, read in order:
1. `identity.md` , agent character
2. `USER.md` , user profile
3. `distilled-memory.md` if it exists , durable context from past weeks
4. `sessions/{yesterday}.md` if it exists , bridge from last session
5. Open or create `sessions/{today}.md`

Update today's session log incrementally as work happens. Before
`/compact`, write the 7-section pre-compact snapshot to today's
log first.
```

## Layer 2: Working memory

The live conversation context. No setup needed.

## Layer 3: Session log

Use [claude-session-handoff](https://github.com/maximum-sl/claude-session-handoff)
for hook-driven session log maintenance.

- `hooks/pre_compact.py` (UserPromptSubmit hook) injects the 7-section
  snapshot template into Claude's context when the user types
  `/compact`.
- `hooks/session_start_status.py` (SessionStart hook) prints a status
  block, opens or creates today's session log.
- `scripts/compress_session.py` calls Haiku to append a Compressed
  Summary block at the end of each session.

Wire into `.claude/settings.json` per claude-session-handoff's README.

## Layer 4: Distilled memory

Run a periodic compression cron job. Recommended approach: use
[claude-watchdog](https://github.com/maximum-sl/claude-watchdog) with a
weekly job that reads recent session logs and rewrites
`distilled-memory.md` via
[claude-oneshot](https://github.com/maximum-sl/claude-oneshot).

Cap the file at ~3KB so the heartbeat-loaded payload stays small.

## Layer 5: Vault

Use the official [Obsidian CLI](https://help.obsidian.md/cli) (shipped
in Obsidian 1.12, February 2026) to read, write, and search vault
contents from a Claude Code session. Wire it into a skill, or call it
directly via the Bash tool. Kepano's
[obsidian-skills](https://github.com/kepano/obsidian-skills) repo
includes a ready-to-use `obsidian-cli` skill that wraps the CLI for
agent use.

## Layer 6: Wiki

Karpathy-pattern entity pages live inside the vault, typically at
`vault/wiki/`. Build a skill (or scripts) for ingest, query, lint, and
rebuild. Ingest reads a raw source and updates the relevant entity
pages, cross-references, and contradiction notes.

See [Karpathy's LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
for the canonical pattern and the framing of compile-once /
read-many.
