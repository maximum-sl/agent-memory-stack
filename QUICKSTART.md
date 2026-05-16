# Quickstart

A working, compounding memory stack in about 15 minutes, with **zero
dependencies**. No other repos, no hooks, no cron, any OS. Works with
Claude Code or Codex (or any agent that reads a rulebook file at start).

## Fast path (one command)

From your project directory:

```sh
curl -fsSL https://raw.githubusercontent.com/maximum-sl/agent-memory-stack/main/install.sh | sh
```

or, if you've cloned this repo, run `./install.sh /path/to/your/project`.

This scaffolds the core files (idempotent , it never overwrites an existing
`identity.md`, `USER.md`, or `distilled-memory.md`). Then do steps 2, 3, 6,
and 7 below.

## Manual path (5 steps + a test)

### 1. Copy the core files into your project

```
identity.md            ← agent character        (copy from examples/, then edit)
USER.md                ← user profile           (copy from examples/, then edit)
distilled-memory.md    ← durable context        (start with the section skeleton)
sessions/              ← per-day logs           (empty directory; gitignored)
PROTOCOL.md            ← read/write rules        (copy this repo's, unmodified)
```

### 2. Personalize identity.md and USER.md (do not skip)

These are **not** drop-in. Set the agent's real name, role, character, and
what "done" means; set the user's real role, working style, and
constraints. Shipping the examples unmodified gives you an agent that
thinks it's "Echo" helping "Alex Rivera." This step is the difference
between a generic assistant and one that behaves like yours.

### 3. Add the heartbeat to your rulebook

Paste this into `CLAUDE.md` (Claude Code) or `AGENTS.md` (Codex):

```markdown
This project uses agent-memory-stack. Follow PROTOCOL.md.

At session start, read in order:
1. identity.md          , agent character
2. USER.md              , user profile
3. distilled-memory.md  , durable context from past weeks (if it exists)
4. sessions/{yesterday}.md , bridge from last session (if it exists);
   read its Open threads and Pending user asks
5. Open or create sessions/{today}.md

Update today's session log incrementally as work happens. Before any
context compaction, write the 7-section snapshot from PROTOCOL.md first.
```

### 4. Run a real session

Do actual work. Make a decision. Leave one thing unfinished on purpose.
Confirm the agent wrote `sessions/{today}.md` with the active task,
decisions, and an open thread (the shape is in `examples/session-log.md`).

### 5. End the session.

That's it. The stack is installed.

### 6. The acceptance test (this is the point)

Start a **fresh session** (new conversation, ideally next day). Without you
re-explaining anything, the agent should:

- reference what you were doing and the decision you made, and
- pick up the open thread you left.

If it does, the loop is closed and you have a compounding memory stack. If
it doesn't, check: is the heartbeat actually in `CLAUDE.md`/`AGENTS.md`? Did
yesterday's `sessions/` file get written? Is `PROTOCOL.md` present?

### 7. Later: distillation

After a week or two of session logs, ask the agent once:

> "Read the last two weeks of `sessions/`, rewrite `distilled-memory.md`:
> durable decisions, standing constraints, and corrections only, as terse
> rules, capped at ~3KB. Drop anything transactional or resolved."

That keeps the always-loaded context small while memory keeps compounding.
See [`distillation.md`](distillation.md) for what to keep vs drop, and
[`examples/loop-walkthrough.md`](examples/loop-walkthrough.md) to see the
payoff across three sessions.

## When to add automation

Never required. If you get tired of the agent occasionally forgetting to
update the session log, or of asking for distillation, the optional
automation tier (hooks + a weekly cron) removes both manual steps without
changing behavior. See [`implementations/`](implementations/). Do this only
after Core works.
