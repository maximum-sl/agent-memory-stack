# 2026-05-06

## Session 1

### Active task
Build a daily digest cron job that pulls Hacker News and the Verge,
summarizes the top items, and saves the result to ~/Desktop.

### Deliverables
- `scripts/digest.sh` , wrapper for the digest job
- `cron/jobs/daily-digest.md` , job definition with `model_tier: fast`
- `examples/digest_2026-05-06.md` , one successful run output

### Decisions
- Picked Haiku over Sonnet: digest is structurally simple, no complex
  reasoning, costs roughly 1/8th.
- Saved to Desktop instead of Downloads: user prefers to see the file
  on screen at startup.
- 7am schedule chosen over 6am: user's wake time is 6:30, want the
  digest waiting.

### Open threads
- Verify the watchdog actually picks up the new job (won't fire until
  the next tick, ~1 hour).
- Decide whether to add r/webdev as a third source.

### Pending user asks
- Should we add a "skip" mechanism for travel days?

---

### Pre-compact snapshot

**Goal** , Build a daily digest cron that runs autonomously every
morning and lands on the user's desktop by 7am.

**Constraints & Preferences** , Subscription billing, never API
credits. Haiku for cost. Output to ~/Desktop. Markdown format.

**Progress**
- Done: digest.sh wrapper, cron/jobs/daily-digest.md, one tested run
- In progress: watchdog pickup verification (next tick)
- Blocked: nothing

**Key Decisions** , Haiku over Sonnet for cost. 7am schedule from
user's wake time. Two sources for v1 (HN + Verge), Reddit deferred.

**Relevant Files**
- `scripts/digest.sh` , main wrapper
- `cron/jobs/daily-digest.md` , job spec, schedule=every_24h
- `examples/digest_2026-05-06.md` , reference output

**Open Threads**
- Verify watchdog picks up the new job
- Add Reddit as a third source if user wants it

**Critical Context**
- The digest job uses `claude-oneshot.sh`, which strips
  `ANTHROPIC_API_KEY`. Don't accidentally re-introduce a path that
  uses raw `claude -p`.
- Output is saved by the script, not the agent. The agent never sees
  the file content directly.
