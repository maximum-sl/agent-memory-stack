# Claude Code implementation

There are two tiers. **Start with Core.** It has zero dependencies, works
on any OS, and is the whole stack , just maintained by instruction rather
than automatically. Add the Optional automation tier later, only once Core
is working and you want the manual steps to happen hands-off.

Layers 5-6 only apply if you maintain a personal note system. Skip those
sections if you don't have one.

---

## Core (zero dependencies)

Nothing to install. Markdown files plus a heartbeat block in `CLAUDE.md`
plus `PROTOCOL.md` so the agent knows the read/write rules. That is the
entire stack.

### Layer 1: Identity

Three files at the project root:

- `CLAUDE.md` , the operational rulebook. Claude Code reads it automatically
  at session start. It contains the heartbeat (below) and points at the
  other two.
- `identity.md` , the agent's character.
- `USER.md` , the user profile.

The `examples/` files are illustrative, not drop-in. Personalize
`identity.md` (name, role, character, what "done" means) and `USER.md`
(role, working style, preferences, constraints). Shipping either unmodified
produces an agent that thinks it's "Echo" helping "Alex Rivera."

Put this heartbeat in `CLAUDE.md`:

```markdown
# CLAUDE.md

This project uses agent-memory-stack. Follow PROTOCOL.md.

At session start, read in order:
1. `identity.md` , agent character
2. `USER.md` , user profile
3. `distilled-memory.md` if it exists , durable context from past weeks
4. `sessions/{yesterday}.md` if it exists , bridge from last session
   (pay attention to its Open threads / Pending user asks)
5. Open or create `sessions/{today}.md`

Update today's session log incrementally as work happens , as soon as a
deliverable ships, a decision is made, or an open thread surfaces. Don't
wait for end of session. Before `/compact`, write the 7-section pre-compact
snapshot (see PROTOCOL.md) to today's log first.
```

### Layer 2: Working memory

The live conversation context. No setup needed. It is the medium the other
layers feed into, not a file you maintain.

### Layer 3: Session log

In Core, the agent maintains this itself because `CLAUDE.md` and
`PROTOCOL.md` tell it to. No hooks required , a hook only makes the same
behavior automatic instead of instructed. Per `PROTOCOL.md`: open/create
`sessions/{today}.md`, read `sessions/{yesterday}.md`, write incrementally,
write the pre-compact snapshot before any compaction.

This works on day one with zero code. If the agent occasionally forgets,
the Optional tier removes the reliance on it remembering.

### Layer 4: Distilled memory

Read `distilled-memory.md` at session start (it's in the heartbeat). To
update it in Core, do it on demand: every week or two, or when session logs
pile up, ask the agent directly:

> "Read the last two weeks of `sessions/`, rewrite `distilled-memory.md`:
> durable decisions, standing constraints, and corrections only, as terse
> rules, capped at ~3KB. Drop anything transactional or already resolved."

See [`../distillation.md`](../distillation.md) for the keep/drop contract
and a worked before/after. The Optional tier turns this into a cron so you
never have to ask.

### Layer 5: Vault (optional, needs a note system)

Use the official [Obsidian CLI](https://help.obsidian.md/cli) or plain file
operations via the Bash tool to read/search/write the vault per
`PROTOCOL.md`. No dependency beyond a vault you already keep.

### Layer 6: Wiki (optional, needs a vault)

Karpathy-pattern entity pages inside the vault (`vault/wiki/`). In Core you
run ingest/query as plain instructions to the agent. See
[Karpathy's LLM Wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
for the pattern.

---

## Optional automation (removes the manual steps)

You do **not** need any of this for the stack to work. It only removes the
two places Core relies on instruction: the agent remembering to maintain
the session log, and you remembering to ask for distillation. Each is an
independent add-on , adopt none, one, or all.

- **Auto session log (Layer 3):**
  [claude-session-handoff](https://github.com/maximum-sl/claude-session-handoff)
  , a SessionStart hook that opens today's log and a pre-compact hook that
  injects the snapshot template. Wire into `.claude/settings.json` per its
  README.
- **Auto distillation (Layer 4):**
  [claude-watchdog](https://github.com/maximum-sl/claude-watchdog) running a
  weekly job that rewrites `distilled-memory.md` via
  [claude-oneshot](https://github.com/maximum-sl/claude-oneshot) (subscription
  auth, not API credits). Cap the file at ~3KB.
- **Vault skill (Layers 5-6):** kepano's
  [obsidian-skills](https://github.com/kepano/obsidian-skills) `obsidian-cli`
  skill wraps the CLI for agent use.

If you adopt the automation tier, the stack behaves identically , it just
maintains itself.
